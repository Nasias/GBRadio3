GBRadioAddonData = LibStub("AceAddon-3.0"):NewAddon("GBRadio3", "AceComm-3.0", "AceSerializer-3.0", "AceEvent-3.0", "AceConsole-3.0");
GBRadio = {};
GBR_Singletons = nil;

function GBRadioAddonData:OnInitialize()

    -- # Begin Globals
    GBR_Singletons = GBR_SingletonService:New();
    GBRadio:ConfigureServices();
    GBRadio:ConfigureCommunication();
    -- # End Globals    

end

function GBRadio:ConfigureServices()

    GBR_Singletons:RegisterManualService(GBR_Constants.SRV_ADDON_SERVICE, GBRadioAddonData);
    GBR_Singletons:InstantiateService(GBR_Constants.SRV_COMMAND_SERVICE);    

    local defaultSettings = GBR_ConfigPresets.BuzzBox;
    
    GBRadioAddonData.SettingsDB = LibStub(GBR_Constants.LIB_ACE_DB):New(GBR_Constants.OPT_ADDON_SETTINGS_DB, defaultSettings);

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_CONFIG_SERVICE);

end

function GBRadio:ConfigureCommunication()

    local frameMA = CreateFrame("FRAME");
    frameMA:RegisterEvent("PLAYER_ENTERING_WORLD");
    
    function frameMA:OnEvent(event)
        JoinChannelByName(GBR_Constants.OPT_COMM_CHANNEL_NAME, nil);
    end
    
    frameMA:SetScript("OnEvent", frameMA.OnEvent);

    GBRadioAddonData:RegisterComm(GBR_Constants.OPT_ADDON_CHANNEL_PREFIX, GBR_MessageService.StaticReceiveMessage);

end