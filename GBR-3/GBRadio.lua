GBRadioAddonData = LibStub(GBR_Constants.LIB_ACE_ADDON):NewAddon(
    GBR_Constants.OPT_ADDON_ID, 
    GBR_Constants.LIB_ACE_COMM, 
    GBR_Constants.LIB_ACE_SERIALISER,
    GBR_Constants.LIB_ACE_EVENT,
    GBR_Constants.LIB_ACE_CONSOLE);
    
GBRadio = {};
GBR_Singletons = nil;

function GBRadioAddonData:OnInitialize()

    GBR_Singletons = GBR_SingletonService:New();

    GBRadio
        :AddServices()
        :AddCommands()
        :AddConfiguration()
        :AddCommunication()
        :AddHooks();

end

function GBRadio:AddServices()

    GBR_Singletons:RegisterManualService(GBR_Constants.SRV_ADDON_SERVICE, GBRadioAddonData);

    return self;

end

function GBRadio:AddCommands()

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_COMMAND_SERVICE);

    return self;
end

function GBRadio:AddCommunication()

    local frameMA = CreateFrame("FRAME");
    frameMA:RegisterEvent("PLAYER_ENTERING_WORLD");
    
    function frameMA:OnEvent(event)
        JoinChannelByName(GBR_Constants.OPT_COMM_CHANNEL_NAME, nil);
    end
    
    frameMA:SetScript("OnEvent", frameMA.OnEvent);
    
    GBRadioAddonData:RegisterComm(GBR_Constants.OPT_ADDON_CHANNEL_PREFIX, GBR_MessageService.StaticReceiveMessage);

    return self;

end

function GBRadio:AddConfiguration()

    local defaultSettings = GBR_ConfigPresets.BuzzBox;
    
    GBRadioAddonDataSettingsDB = LibStub(GBR_Constants.LIB_ACE_DB):New(GBR_Constants.OPT_ADDON_SETTINGS_DB, defaultSettings);

    local channelCount = 0;

    for k,v in pairs(GBRadioAddonDataSettingsDB.char.Channels) do
        channelCount = channelCount + 1;
    end

    if channelCount == 0 then 
        GBRadioAddonDataSettingsDB.char.Channels["DEFAULT"] = GBR_ConfigPresets.DefaultChannel;
    end

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_CONFIG_SERVICE);

    return self;

end

function GBRadio:AddHooks()

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_HOOK_SERVICE)
        :RegisterHooks();


    return self;

end
