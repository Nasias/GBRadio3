LEASuiteAddonData = LibStub(LEASuite_Constants.LIB_ACE_ADDON):NewAddon(
    LEASuite_Constants.OPT_ADDON_ID, 
    LEASuite_Constants.LIB_ACE_COMM, 
    LEASuite_Constants.LIB_ACE_SERIALISER,
    LEASuite_Constants.LIB_ACE_EVENT,
    LEASuite_Constants.LIB_ACE_CONSOLE);
    
LEASuite = {};
LEASuite_Singletons = nil;

function LEASuiteAddonData:OnInitialize()

    LEASuite_Singletons = LEASuite_SingletonService:New();

    LEASuite
        :AddSavedVars()
        :AddServices()
        :AddConfiguration()
        :AddCommands()
        :AddHooks();
end

function LEASuite:AddSavedVars()

    if not LEASuite_SavedVars then
        LEASuite_SavedVars = {
            Reports = {},
            Recorder = {},
        };
    end

    return self;
end

function LEASuite:AddConfiguration()
   
    LEASuiteAddonDataSettingsDB = LibStub(LEASuite_Constants.LIB_ACE_DB):New(LEASuite_Constants.OPT_ADDON_SETTINGS_DB, LEASuite_ConfigPreset);

    return self;

end

function LEASuite:AddServices()

    LEASuite_Singletons:RegisterManualService(LEASuite_Constants.SRV_ADDON_SERVICE, LEASuiteAddonData);

    return self;

end

function LEASuite:AddCommands()

    LEASuite_Singletons:InstantiateService(LEASuite_Constants.SRV_COMMAND_SERVICE);

    return self;
end

function LEASuite:AddHooks()
    if TRP3_API then
        if TRP3_API.globals.extended_version then
            TRP3_API.globals.extended_display_version = TRP3_API.globals.extended_display_version .. LEASuite:GetTooltipVersionDisplay();
        else
            TRP3_API.globals.display_version = TRP3_API.globals.display_version .. LEASuite:GetTooltipVersionDisplay();
        end
    end

    return self;
end

function LEASuite:GetTooltipVersionDisplay()

    local versionDisplay = GBRadio
        and string.format(" |cFFFFC000//|r |cFF00C0FFOffice of Justice LEA Suite v-%s|r", LEASuite_Constants.OPT_ADDON_VERSION)
        or string.format("\n|cFF00C0FFOffice of Justice LEA Suite v-%s|r", LEASuite_Constants.OPT_ADDON_VERSION);

    return versionDisplay ..
        string.format("\n"
            .. "|cFFD6FF00PolSim|r"
            .. [[|TInterface\BUTTONS\WHITE8X8:8:20:0:0:8:8:0:8:0:8:0:60:255|t]]
            .. [[|TInterface\BUTTONS\WHITE8X8:8:20:0:0:8:8:0:8:0:8:214:255:0|t]]
            .. [[|TInterface\BUTTONS\WHITE8X8:8:20:0:0:8:8:0:8:0:8:0:60:255|t]]
            .. [[|TInterface\BUTTONS\WHITE8X8:8:20:0:0:8:8:0:8:0:8:214:255:0|t]]
            .. [[|TInterface\BUTTONS\WHITE8X8:8:20:0:0:8:8:0:8:0:8:0:60:255|t]]
            .. [[|TInterface\BUTTONS\WHITE8X8:8:20:0:0:8:8:0:8:0:8:214:255:0|t]],
            LEASuite_Constants.OPT_ADDON_VERSION);
end
