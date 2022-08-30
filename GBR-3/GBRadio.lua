GBRadioAddonData = LibStub("AceAddon-3.0"):NewAddon("GBRadio3", "AceComm-3.0", "AceSerializer-3.0", "AceEvent-3.0", "AceConsole-3.0");
GBRadio = {};
GBR_Singletons = nil;

function GBRadioAddonData:OnInitialize()

    GBR_Singletons = GBR_SingletonService:New();

    GBRadio
        :AddServices()
        :AddConfiguration()
        :AddCommunication()
        :AddHooks();

end

function GBRadio:AddServices()

    GBR_Singletons:RegisterManualService(GBR_Constants.SRV_ADDON_SERVICE, GBRadioAddonData);
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

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_CONFIG_SERVICE);

    return self;

end

function GBRadio:AddHooks()

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_HOOK_SERVICE)
        :RegisterHooks();


    return self;

end