GBR_ConfigService = GBR_Object:New();

function GBR_ConfigService:New(obj)

    self._mrpService = GBR_Singletons:FetchService(GBR_Constants.SRV_MRP_SERVICE);
    self._locationService = GBR_SingletonService:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
    self._serialiserService = GBR_SingletonService:FetchService(GBR_Constants.SRV_SERIALISER_SERVICE);
    self._addonService = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
    self._roleService = GBR_SingletonService:FetchService(GBR_Constants.SRV_ROLE_SERVICE);

    self.StagingVars =
    {
        NewChannelName = nil,
        NewChannelFrequency = nil,
        NewTransmitterName = nil,
        GeoToolsWorldCoordinates = GBR_Vector3:New(),
        GeoToolsLocalCoordinates = GBR_Vector3:New(),
        FrequencyListeners = {},
        DeserializedImportString = nil,
        ImportFrequencyExists = false,
    };

    self:Initialize();

    return self:RegisterNew(obj);

end

function GBR_ConfigService:Initialize()

    --local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
    
    self._addonService.OptionsTable = 
    {
        type = "group",
        name = string.format("GB|cff00c0ffRadio|r 3 (v%s) - by |cff00c0ffNasias Darkstar|r, Argent Dawn (EU)", GBR_Constants.OPT_ADDON_VERSION),
        childGroups = "tree",
        handler = self._addonService,        
        args = {
            deviceConfig = 
            {
                type = "group",
                name = "Device config",
                cmdHidden = true,
                order = 0,
                args = 
                {
                    deviceConfigGroup =
                    {
                        type = "group",
                        name = "Device configuration",
                        guiInline = true,
                        args =
                        {
                            deviceName = 
                            {
                                name = "Device name",
                                desc = "The name of your comms device\n\nNote: This is used in emotes to describe the type of device you're using",
                                type = "input",
                                get = 
                                    function(info) 
                                        return GBRadioAddonDataSettingsDB.char.DeviceName;
                                    end,
                                set = 
                                    function(info, value) 
                                        GBRadioAddonDataSettingsDB.char.DeviceName = value;
                                    end,
                                width = "full",
                                cmdHidden = true,
                                order = 0
                            },
                            deviceNameDescription =
                            {
                                type = "description",
                                name = "Your device's name is used in emotes to describe the type of device you're using.",
                                order = 1
                            },
                            primaryChannel =
                            {
                                name = "Primary channel",
                                desc = "Select the primary channel for your device.",
                                type = "select",
                                values = 
                                    function()                                        
                                        local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                        local channels = configService:GetRegisteredCommunicationFrequencies();
                                        local dropdownValues = {};

                                        for k,v in pairs(channels) do
                                            dropdownValues[k] = GBR_ConfigService.GetChannelGroupName(v.IsEnabled, v.ChannelName, k);
                                        end

                                        return dropdownValues;
                                    end,
                                width = "full",
                                sorting =
                                    function()
                                        local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                        local channels = configService:GetRegisteredCommunicationFrequencies();
                                        local dropdownValues = {};

                                        for k,v in pairs(channels) do
                                            table.insert(dropdownValues, k);
                                        end

                                        table.sort(dropdownValues, function(a, b) return a < b end);
                                        return dropdownValues;
                                    end,
                                get = 
                                    function(info)
                                        return GBRadioAddonDataSettingsDB.char.PrimaryFrequency;
                                    end,
                                set = 
                                    function(info, value)
                                        local microMenuService = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
                                        GBRadioAddonDataSettingsDB.char.PrimaryFrequency = value;
                                        microMenuService:RefreshChannels();
                                    end,
                                order = 2
                            },
                            primaryChannelDescription =
                            {
                                type = "description",
                                name = "You can listen on multiple different channels at once, but you can only send messages on one at a time.\n\nYour primary channel determines the channel that you use to send messages.",
                                order = 3
                            },
                            radioMessagedDelay = 
                            {
                                type = "range",
                                min = 0,
                                max = 10,
                                softMin = 0,
                                softMax = 10,
                                step = 0.5,
                                width = "full",
                                name = "Radio message delay (seconds)",
                                desc = "The delay (in seconds) between /saying a message and the message being sent over the radio.\n\nThe purpose of this setting is to prevent messages appearing over the radio channel before your character has spoken it aloud in laggy environments.",
                                get = 
                                    function(info) 
                                        return GBRadioAddonDataSettingsDB.char.RadioMessageDelay;
                                    end,
                                set = 
                                    function(info, value) 
                                        GBRadioAddonDataSettingsDB.char.RadioMessageDelay = value;
                                    end,
                                order = 4
                            },
                            showMicroMenuOnLogIn = 
                            {
                                name = "Show micro menu on log in",
                                desc = "Automatically show the GBRadio micro menu when you log in, allowing you to quickly change frequency and access other menus, from a small floating frame."
                                    .."\n\nNote this can always be accessed by typing '/gbr'.",
                                type = "toggle",
                                get = 
                                    function(info) 
                                        return GBRadioAddonDataSettingsDB.char.ShowMicroMenuOnLogIn;
                                    end,
                                set = 
                                    function(info, value) 
                                        GBRadioAddonDataSettingsDB.char.ShowMicroMenuOnLogIn = value;
                                    end,
                                width = "full",
                                cmdHidden = true,
                                order = 5
                            },
                            showMicroMenuOnLogInDescription =
                            {
                                type = "description",
                                name = "Automatically show the GBRadio micro menu when you log in, allowing you to quickly change frequency and access other menus, from a small floating frame."
                                .."\n\nNote this can always be accessed by typing '/gbr'.",
                                order = 6
                            },
                        }
                    }
                }
            },
            characterConfig =
            {
                type = "group",
                name = "Character config",
                cmdHidden = true,
                order = 1,
                args =
                {
                    characterConfigGroup =
                    {
                        
                        type = "group",
                        name = "Character configuration",
                        guiInline = true,
                        args =
                        {
                            characterGenderDesc =
                            {
                                name = "Select from a pre-set list of genders for your character, or specify your own custom pronouns to use in auto-generated emotes.",
                                type = "description",
                                order = 0
                            },
                            characterGender =
                            {
                                name = "Character gender",
                                type = "select",
                                values =
                                {
                                    "Custom",
                                    "Male",
                                    "Female"
                                },
                                width = "full",
                                get = GBR_ConfigService.GetCharacterGender,
                                set = 
                                    function(info, value)
                                        local newPronouns = GBR_ConfigService.GetDefaultPronouns(value);
                                        GBRadioAddonDataSettingsDB.char.Gender = value;
                                        GBR_ConfigService.SetPronouns(newPronouns);
                                    end,
                                order = 1
                            },
                            customPronounA =
                            {
                                name = "Pronoun A",
                                type = "input",
                                width = 0.75,
                                get =
                                    function(info)
                                        local pronouns = GBR_ConfigService.GetCharacterPronouns();
                                        return pronouns.A;
                                    end,
                                order = 2
                            },
                            characterVoiceTypeDesc =
                            {
                                name = "Your character's voice type determines the voice audio that plays when messages are sent and received.",
                                type = "description",
                                order = 5
                            },
                            characterVoiceType =
                            {
                                name = "Character voice type",
                                type = "select",
                                values =
                                {
                                    [2] = "Masculine",
                                    [3] = "Feminine"
                                },
                                width = "full",
                                get = GBR_ConfigService.GetCharacterVoiceType,
                                set = 
                                    function(info, value)
                                        GBRadioAddonDataSettingsDB.char.VoiceType = value;
                                    end,
                                order = 6
                            },
                        }
                    }
                }
            },
            channelConfig =
            {
                type = "group",
                name = "Channels",
                cmdHidden = true,
                childGroups = "tree",
                order = 2,
                args =
                {
                    addChannelGroupPage =
                    {
                        type = "group",
                        name = "|TInterface\\BUTTONS\\UI-PlusButton-Up:16:16:0:0|t Add new channel",
                        order = 0,
                        args =
                        {
                            addChannelGroup =
                            {
                                type = "group",
                                name = "Add new channel",
                                order = 0,
                                guiInline = true,
                                args =
                                {
                                    addChannelDescription =
                                    {
                                        type = "description",
                                        name = "Add a new channel by providing a name and frequency that you'd like to use.\n\nNote that you can't use the same frequency on multiple channels.",
                                        order = 0
                                    },
                                    newChannelName =
                                    {
                                        name = "New channel name",
                                        desc = "Enter a descriptive name for the channel you would like to use.",
                                        type = "input",
                                        width = "full",
                                        cmdHidden = true,
                                        validate = GBR_ConfigService.ValidateChannelName,
                                        set = 
                                            function(info, value)
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                local microMenuService = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);

                                                configService:SetNewChannelName(value);
                                                microMenuService:RefreshChannels();
                                            end,
                                        get = 
                                            function(info, value)
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                return configService:GetNewChannelName(value);
                                            end,
                                        order = 0,
                                    },
                                    newChannelFrequency =
                                    {
                                        name = "New channel frequency",
                                        desc = "Enter a descriptive name for the channel you would like to use.",
                                        type = "input",
                                        width = "full",
                                        cmdHidden = true,
                                        validate = GBR_ConfigService.ValidateChannelFrequency,
                                        set = 
                                            function(info, value)
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                local microMenuService = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
                                                configService:SetNewChannelFrequency(value);
                                                microMenuService:RefreshChannels();
                                            end,
                                        get = 
                                            function(info, value)
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                return configService:GetNewChannelFrequency(value);
                                            end,
                                        order = 1,
                                    },
                                    addNewChannelButton =
                                    {
                                        name = "Add new channel",
                                        type = "execute",
                                        disabled = 
                                            function(info) 
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                return not configService:IsAddChannelReady(info);
                                            end,
                                        order = 2,
                                        func = 
                                            function(info, value)                                        
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                local microMenuService = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
                                                local newChannelName = configService:GetNewChannelName();
                                                local newChannelFrequency = configService:GetNewChannelFrequency();
                                                local newSettingsModel = GBR_ConfigService.GetNewChannelSettingsModel(newChannelFrequency, newChannelName);
                                                local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                                                local channelKey = configService:GetNextRandomKey();

                                                GBR_ConfigService.AddChannelToUi(
                                                    addon.OptionsTable.args.channelConfig.args, 
                                                    channelKey, 
                                                    newSettingsModel);

                                                GBR_ConfigService.AddChannelToDb(
                                                    GBRadioAddonDataSettingsDB.char.Channels,
                                                    channelKey,
                                                    newSettingsModel);

                                                configService:SetNewChannelName("");
                                                configService:SetNewChannelFrequency("");

                                                microMenuService:RefreshChannels();
                                            end
                                    }
                                }
                            },
                            importChannelGroup =
                            {
                                type = "group",
                                name = "Import channel",
                                order = 0,
                                guiInline = true,
                                args =
                                {
                                    importChannelDescription =
                                    {
                                        type = "description",
                                        name = "Add a new channel via a shared import string.",
                                        order = 0
                                    },
                                    importChannelString =
                                    {
                                        name = "Import string",
                                        desc = "Paste the import string for the channel.",
                                        type = "input",
                                        multiline = 5,
                                        width = "full",
                                        cmdHidden = true,
                                        confirm = 
                                            function(info, value)
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                local settings = configService:GetImportedSettingsFromString(value);
                                                local frequencyExists, message = GBR_ConfigService.ImportedFrequencyExists(settings.ChannelSettings.ChannelFrequency);

                                                configService.StagingVars.DeserializedImportString = settings;                                               
                                                configService.StagingVars.ImportFrequencyExists = frequencyExists;
                                                return message;

                                            end,
                                        set = 
                                            function(info, value)
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                local settings = configService.StagingVars.DeserializedImportString;
                                                local inportToExisting = configService.StagingVars.ImportFrequencyExists;

                                                if settings == nil then return end;

                                                configService:ImportSettingsFromString(settings, inportToExisting);
                                            end,
                                        order = 2,
                                    }
                                }
                            }
                        }
                    }
                }
            },            
            geoLocationTools =
            {
                name = "Geolocation tools",
                type = "group",
                order = 3,
                args =
                {
                    geoLocationToolsGroup =
                    {
                        name = "Geolocation Tools",
                        type = "group",
                        guiInline = true,
                        order = 0,
                        args =
                        {
                            geoLocationToolsDesc =
                            {
                                name = "A number of components of GBRadio use a coordinates system, such as transmitter locations.\n\nUse the geolocation tools to find out your local or world coordinates to help you discover these values.",
                                type = "description",
                                order = 0
                            },
                            worldCoordinatesInput =
                            {
                                name = "World coordinates",
                                type = "input",
                                order = 1,
                                get =
                                    function(info)
                                        local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                        local worldCoordinates = configService:GetGeoToolsWorldCoordinates();

                                        if worldCoordinates.X == nil or worldCoordinates.Y == nil then
                                            return "";
                                        end

                                        return string.format("%.2f, %.2f", worldCoordinates.X, worldCoordinates.Y);
                                    end,
                            },
                            getWorldCoordinatesButton =
                            {
                                name = "Get world coordinates",
                                type = "execute",
                                order = 2,
                                func =
                                    function(info)
                                        local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                        local locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
                                        local playerPosition = locationService:GetCurrentCharacterLocation();

                                        configService:SetGeoToolsWorldCoordinates(playerPosition.WorldPosition.X, playerPosition.WorldPosition.Y);
                                    end
                            },
                            localCoordinatesInput =
                            {
                                name = "Local coordinates",
                                type = "input",
                                order = 3,
                                get =
                                    function(info)
                                        local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                        local localCoordinates = configService:GetGeoToolsLocalCoordinates();
                                        
                                        if localCoordinates.X == nil or localCoordinates.Y == nil then
                                            return "";
                                        end

                                        return string.format("%.2f, %.2f", localCoordinates.X, localCoordinates.Y);
                                    end,
                            },
                            getLocalCoordinatesButton =
                            {
                                name = "Get local coordinates",
                                type = "execute",
                                order = 4,
                                func =
                                    function(info)
                                        local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                        local locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
                                        local playerPosition = locationService:GetCurrentCharacterLocation();

                                        configService:SetGeoToolsLocalCoordinates(playerPosition.ZonePosition.X * 100, playerPosition.ZonePosition.Y * 100);
                                    end
                            },
                        }
                    }                    
                }
            },
            about =
            {
                name = "About",
                type = "group",
                order = 4,
                args =
                {
                    aboutDesc =
                    {
                        type = "description",
                        fontSize = "medium",
                        name = "Thanks for using GBRadio 3!"
                            .. "\n\nGBRadio was developed with immersion in mind. If you roleplay a guard, no doubt you use a radio, a walker or a buzzbox (whatever your flavour) and the aim of this addon is to make that as easy, seamless and immersive as possible."
                            .. "\n\nMy thanks to my friends listed below who have helped test GBRadio 3 and offer their feedback:\n"
                            .. "\n|cFF82C2FFÉphráim|r (Matthew Preston) @ Argent Dawn, EU"
                            .. "\n|cFF82C2FFHlídka|r (Company Unit) @ Argent Dawn, EU"
                            .. "\n|cFF82C2FFCadwëll|r (Andy Cadwell) @ Argent Dawn, EU"
                            .. "\n|cFF82C2FFLizbelli|r (Lizbelli Darkstar) @ Argent Dawn, EU"
                            .. "\n|cFF82C2FFKaspbrák|r (Hendrick Kaspbrak) @ Argent Dawn, EU"
                            .. "\n|cFFFFD700Agrovane|r (Darius Agrovane) @ Argent Dawn, EU"
                            .. "\n|cFF82C2FFEcireth|r (Ecireth Eckleheart) @ Argent Dawn, EU"
                            .. "\n\nGBRadio 3 is written in Lua, powered by the ACE-3.0 framework. All rights reserved."
                            .. "\n\n|cFF82C2FFAuthor:|r Nasias (Nasias Darkstar) @ Argent Dawn (EU)\n|cFF82C2FFContact:|r n@siasdarkstar.com\n|cFF82C2FFDiscord:|r Nasias#0001",
                    }
                }
            },
            help =
            {
                name = "Help",
                type = "group",
                order = 5,
                args =
                {
                    aboutDesc =
                    {
                        type = "description",
                        fontSize = "medium",
                        name = "Commands"
                            .. "\n\n|cFF82C2FF/gbr|r - Shows the micro menu"
                                .. "\n\n|cFF82C2FF/gbr config|r - Shows the config menu"
                                .. "\n\n|cFF82C2FF/gbr dispatch|r - Shows the notification dispatcher menu"
                                .. "\n\n|cFF82C2FF/bb <message>|r - Send a message"
                                .. "\n\n|cFF82C2FF/wbb <message>|r - Send a quiet message (no /say)"
                                .. "\n\n|cFF82C2FF/pb|r - Panic button - Sends an alert out to all listeners that you need assistance",
                        order = 0,
                    },
                    wikiDesc =
                    {
                        type = "description",
                        fontSize = "medium",
                        name = "\n\nVisit the GBRadio 3 wiki for guidance and how-tos.",
                        order = 1,
                    },
                    wikiInput =
                    {
                        name = "Wiki",
                        type = "input",
                        desc = "Visit the GBRadio 3 wiki for guidance and how-tos.",
                        width = "full",
                        order = 2,
                        get =
                            function(info)
                                return "https://github.com/Nasias/GBRadio3/wiki/";
                            end,
                    },
                }
            }
        }
    };

    for channelKey, channelData in pairs(GBRadioAddonDataSettingsDB.char.Channels) do
        self.AddChannelToUi(self._addonService.OptionsTable.args.channelConfig.args, channelKey, channelData);
    end
    
    self._addonService.ConfigRegistry = LibStub(GBR_Constants.LIB_ACE_CONFIG):RegisterOptionsTable(GBR_Constants.OPT_ADDON_ID, self._addonService.OptionsTable);
    self._addonService.OptionsFrame = LibStub(GBR_Constants.LIB_ACE_CONFIG_DIALOG):AddToBlizOptions(GBR_Constants.OPT_ADDON_ID, "GB|cff00c0ffRadio|r 3");

end

function GBR_ConfigService.AddChannelSettingsConfigurationPage(channelData)

    return 
    {
        channelSettingsHeader = 
        {
            order = 0,
            type = "group",
            name = "Channel settings",
            guiInline = true,
            args = 
            {
                channelIsEnabled =
                {
                    order = 0,
                    name = "Channel is enabled",
                    desc = "Toggle to determine whether you can send and receive messages on this channel",
                    type = "toggle",
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelIsEnabled;
                        end,
                    set = 
                        function(info, value)
                            local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                            local microMenuService = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
                          
                            local key = info[#info-3];

                            addon.OptionsTable.args.channelConfig.args[key].name = GBR_ConfigService.GetChannelGroupName(
                                value, 
                                GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelName,                            
                                GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency);

                            GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelIsEnabled = value;
                            microMenuService:RefreshChannels();
                        end,
                },
                channelNotificationsEnabled =
                {
                    order = 1,
                    name = "Channel notifications enabled",
                    desc = "Show important messages in their own notification pop-up.",
                    type = "toggle",
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelNotificationsEnabled;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];

                            GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelNotificationsEnabled = value;
                        end,
                },
                channelName = 
                {
                    order = 2,
                    name = "Channel name",
                    desc = "Enter a descriptive name for the channel you would like to use.",
                    type = "input",
                    cmdHidden = true,
                    validate = GBR_ConfigService.ValidateChannelName,
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelName;
                        end,
                    set = 
                        function(info, value)
                            local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                            local microMenuService = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
                            local key = info[#info-3];

                            addon.OptionsTable.args.channelConfig.args[key].name = GBR_ConfigService.GetChannelGroupName(
                                GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelIsEnabled, 
                                value,
                                GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency);

                            addon.OptionsTable.args.channelConfig.args[key].args.channelSettingsDesc.name = value;
                            GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelName = value;
                            microMenuService:RefreshChannels();
                        end,
                },
                channelFrequency = 
                {
                    order = 3,
                    name = "Channel frequency",
                    desc = "Enter the channel's frequency. .\n\nOnly use letters and numbers, and don't use spaces.",
                    type = "input",
                    cmdHidden = true,
                    validate = GBR_ConfigService.ValidateChannelFrequency,
                    width = "full",
                    get = 
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency;
                        end,
                    set = 
                        function(info, value) 
                            local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                            local microMenuService = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
                            local key = info[#info-3];
                            local oldFrequencyValue = GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency;

                            if GBRadioAddonDataSettingsDB.char.PrimaryFrequency == oldFrequencyValue then
                                GBRadioAddonDataSettingsDB.char.PrimaryFrequency = value;
                            end

                            addon.OptionsTable.args.channelConfig.args[key].name = GBR_ConfigService.GetChannelGroupName(
                                GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelIsEnabled,
                                GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelName,
                                value);

                            GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency = value;
                            microMenuService:RefreshChannels();
                        end,
                },
                channelNotes =
                {
                    order = 4,
                    name = "Channel notes",
                    desc = "Enter any notes that you want to keep for this channel",
                    type = "input",
                    width = "full",
                    multiline = 4,
                    get = 
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelNotes;
                        end,
                    set = 
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelNotes = value;
                        end,
                }
            }
        },
        channelChatFramesGroup = 
        {
            order = 1,
            name = "Chat frame settings",
            type = "group",
            guiInline = true,
            args = 
            {
                channelChatMessageColour = 
                {
                    order = 0,
                    name = "Message colour",
                    type = "color",
                    hasAlpha = false,
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            local colour = GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelChatMessageColour;
                            return colour.R, colour.G, colour.B, colour.A;
                        end,
                    set = 
                        function(info, r, g, b, a)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelChatMessageColour = 
                            { 
                                A = a, 
                                R = r, 
                                G = g, 
                                B = b 
                            } 
                        end,
                },
                channelChatFrames = 
                {
                    order = 1,
                    name = "Output chat frame",
                    type = "multiselect",
                    values = {
                        "Chat Frame #1",
                        "Chat Frame #2",
                        "Chat Frame #3",
                        "Chat Frame #4",
                        "Chat Frame #5",
                        "Chat Frame #6",
                        "Chat Frame #7",
                        "Chat Frame #8",
                        "Chat Frame #9",
                        "Chat Frame #10",
                    },
                    dialogControl = "Dropdown",
                    width = "full",
                    get =
                        function(info, keyname)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelChatFrames[keyname];
                        end,
                    set =
                        function(info, keyname, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelChatFrames[keyname] = value;
                        end,
                },
                channelChatFramesIdentify = 
                {
                    order = 2,
                    name = "Identify chat frames",
                    type = "execute",
                    width = "full",
                    func = 
                        function(info, val)
                            local key = info[#info-3];
                            local channelColour = GBR_ARGB:New(GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelChatMessageColour);

                            for i = 1, NUM_CHAT_WINDOWS do
                                local frame = _G["ChatFrame"..i]
                                if frame then
                                    
                                    frame:AddMessage(string.format(GBR_Constants.MSG_CHAT_FRAME_IDENTITY,
                                        channelColour:ToEscapedHexString(),
                                        i));
                                end
                            end
                        end
                },
            }
        }
    }

end

function GBR_ConfigService.AddIdentitySettingsConfigurationPage(channelData)

    return 
    {
        identityGroup = 
        {
            order = 0,
            type = "group",
            name = "Identity settings",
            guiInline = true,
            args = 
            {
                identifyOnChannelAs = 
                {
                    order = 0,
                    type = "select",
                    name = "Identify using",
                    values = 
                    {
                        [GBR_ENameType.Character] = "Character name", 
                        [GBR_ENameType.Mrp] = "TRP3 full Name", 
                        [GBR_ENameType.Callsign] = "Channel callsign",
                        [GBR_ENameType.CharacterWithCallsign] = "Character name with channel callsign",
                        [GBR_ENameType.MrpWithCallsign] = "TRP3 full name with channel callsign",
                    },
                    style = "dropdown",
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].IdentitySettings.IdentifyOnChannelAs;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].IdentitySettings.IdentifyOnChannelAs = value;
                        end,
                },
                channelCallsign = 
                {
                    order = 1,
                    type = "input",
                    name = "Channel callsign",
                    validate = GBR_ConfigService.ValidateCallsign,
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].IdentitySettings.ChannelCallsign;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].IdentitySettings.ChannelCallsign = value;
                        end,
                },
                showChannelRoles =
                {
                    order = 2,
                    type = "toggle",
                    name = "Show channel roles",
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].IdentitySettings.ShowChannelRoles;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].IdentitySettings.ShowChannelRoles = value;
                        end,
                },
                channelRoles =
                {
                    order = 3,
                    type = "multiselect",
                    name = "Channel roles",
                    dialogControl = "Dropdown",
                    width = "full",
                    values =
                        function(info)
                            local roleService = GBR_SingletonService:FetchService(GBR_Constants.SRV_ROLE_SERVICE);
                            return roleService:GetRolesAsKeyValuePairs();
                        end,
                    get =
                        function(info, keyname)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].IdentitySettings.SelectedChannelRoles[keyname];
                        end,
                    set =
                        function(info, keyname, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].IdentitySettings.SelectedChannelRoles[keyname] = value;
                        end,
                }
            }
        },
        displayNameGroup =
        {
            order = 1,
            type = "group",
            name = "Identity preview",
            guiInline = true,
            args =
            {
                displayNamePreviewDesc =
                {
                    name = "Your name will appear in messages as the example below:\n\n",
                    type = "description",
                    order = 0
                },
                displayNamePreview =
                {
                    name = 
                        function(info)
                            local key = info[#info-3];
                            local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                            local frequency = GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency;
                            local outputString = "|cFF00FF00[";

                            if configService:ShowChannelRolesForFrequency(frequency) then
                                local roleString = configService:GetRoleDisplayForFrequency(frequency);

                                if roleString:len() > 0 then -- Don't want to include empty brackets. If role is empty then don't show any of this.
                                    outputString = outputString .. configService:GetRoleDisplayForFrequency(frequency) .. "][";
                                end
                            end

                            outputString = outputString .. configService:GetCharacterDisplayNameForFrequency(frequency) .. "]|r";

                            return outputString;
                        end,
                    type = "description",
                    fontSize = "medium",
                    order = 1
                },
                displayNamePreviewHelpDesc =
                {
                    name = "|CFFFFFF00\nNote that if you use a TRP3 name option or a callsign option, but you don't have TRP3 installed or you don't specify a callsign, then those respective elements will either default back to your base character name, or they will be omitted.",
                    type = "description",
                    order = 2
                },
            }
        }
    }

end

function GBR_ConfigService.AddInteractionSettingsConfigurationPage(channelData)

    return
    {
        interactionTextGroup = 
        {
            order = 0,
            type = "group",
            name = "Interaction text settings",
            guiInline = true,
            args = 
            {
                speakOnSend = 
                {
                    order = 0,
                    type = "toggle",
                    name = "Speak on send",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.SpeakOnSend;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.SpeakOnSend = value;
                        end,
                },
                emoteOnSend = 
                {
                    order = 1,
                    type = "toggle",
                    name = "Emote on send",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.EmoteOnSend;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.EmoteOnSend = value;
                        end,
                },
                emoteOnReceive =
                {
                    order = 2,
                    type = "toggle",
                    name = "Emote on receive",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.EmoteOnReceive;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.EmoteOnReceive = value;
                        end,
                },
                emoteOnEmergency = 
                {
                    order = 3,
                    type = "toggle",
                    name = "Emote on emergency",
                    get = 
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.EmoteOnEmergency;
                        end,
                    set = 
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.EmoteOnEmergency = value;
                        end,
                }
            }
        },
        interactionAudioGroup = 
        {
            order = 1,
            type = "group",
            name = "Interaction audio settings",
            guiInline = true,
            args = 
            {
                audioOnSend =
                {
                    order = 4,
                    type = "toggle",
                    name = "Play audio on send",
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnSend;
                        end,
                    set = 
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnSend = value;
                        end,
                },
                audioOnReceive =
                {
                    order = 5,
                    type = "toggle",
                    name = "Play audio on receive",
                    width = "full",
                    get =
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnReceive;
                        end,
                    set =
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnReceive = value;
                        end,
                },
                audioOnEmergencySend =
                {
                    order = 6,
                    type = "toggle",
                    name = "Play audio on emergency send",
                    width = "full",
                    get =
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnEmergencySend;
                        end,
                    set =
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnEmergencySend = value;
                        end,
                },
                audioOnEmergencyReceive =
                {
                    order = 7,
                    type = "toggle",
                    name = "Play audio on emergency receive",
                    width = "full",
                    get =
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnEmergencyReceive;
                        end,
                    set =
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnEmergencyReceive = value;
                        end,
                },
                audioOnNoSignal =
                {
                    order = 8,
                    type = "toggle",
                    name = "Play audio on no signal",
                    width = "full",
                    get =
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnNoSignal;
                        end,
                    set =
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnNoSignal = value;
                        end,
                },
                audioOnNotifications =
                {
                    order = 9,
                    type = "toggle",
                    name = "Play audio on notifications",
                    width = "full",
                    get =
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnNotifications;
                        end,
                    set =
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.AudioOnNotifications = value;
                        end,
                }
            }
        },
        interactionCooldownGroup = 
        {
            order = 2,
            name = "Cooldown settings",
            type = "group",
            guiInline = true,
            args = 
            {
                channelEmoteCooldown = 
                {
                    order = 0,
                    name = "Receive emote cooldown (seconds)",
                    type = "range",
                    min = 0,
                    max = 30,
                    softMin = 0,
                    softMax = 30,
                    step = 1,
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.ChannelEmoteCooldown;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.ChannelEmoteCooldown = value;
                        end,
                },
                channelAudioCooldown = 
                {
                    order = 1,
                    name = "Receive audio cooldown (seconds)",
                    type = "range",
                    min = 0,
                    max = 30,
                    softMin = 0,
                    softMax = 30,
                    step = 1,
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.ChannelAudioCooldown;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonDataSettingsDB.char.Channels[key].InteractionSettings.ChannelAudioCooldown = value;
                        end,
                },
            }
        },
    }

end

function GBR_ConfigService.AddTransmitterSettingsConfigurationPage(channelData)

    local transmitterUiData =
    {
        transmitterSettingsGroup =
        {
            type = "group",
            name = "Transmitter config",
            order = 0,
            childGroups = "tree",
            args =
            {
                transmitterSettings =
                {
                    name = "Transmitter configuration",
                    type = "group",
                    guiInline = true,
                    order = 0,
                    args =
                    {
                        useTransmitters =
                        {
                            name = "Use transmitters",
                            type = "toggle",
                            order = 0,
                            get =
                                function(info)
                                    local channelKey = info[#info-4];
                                    return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.UseTransmitters;
                                end,
                            set =
                                function(info, value)
                                    local channelKey = info[#info-4];
                                    GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.UseTransmitters = value;
                                end,
                        },
                        alwaysOnInInstances =
                        {
                            name = "Always on in instances",
                            type = "toggle",
                            desc = "\n\nEnable this setting if you want your device to work inside instanced locations."
                                .."Enabling transmitters means a range test is performed each time messages are sent or received, but this range test means that communications will stop working in instanced locations. This may or may not be desired functionality.",
                            order = 1,
                            get =
                                function(info)
                                    local channelKey = info[#info-4];
                                    return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.AlwaysOnInInstances;
                                end,
                            set =
                                function(info, value)
                                    local channelKey = info[#info-4];
                                    GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.AlwaysOnInInstances = value;
                                end,
                        },
                        transmitterRange =
                        {
                            name = "Range (yards)",
                            type = "range",
                            min = 0,
                            max = 10000,
                            softMin = 0,
                            softMax = 1000,
                            step = 1,
                            width = "full",
                            order = 2,
                            get =
                                function(info)
                                    local channelKey = info[#info-4];
                                    return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.TransmitterRange;
                                end,
                            set =
                                function(info, value)
                                    local channelKey = info[#info-4];
                                    GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.TransmitterRange = value;
                                end,
                        },
                        lowIntensityInterferenceFalloff =
                        {
                            name = "Static(L) falloff (yards)",
                            type = "range",
                            min = 0,
                            max = 10000,
                            softMin = 0,
                            softMax = 1000,
                            step = 1,
                            width = "full",
                            order = 3,
                            get =
                                function(info)
                                    local channelKey = info[#info-4];
                                    return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.LowIntensityInterferenceFalloff;
                                end,
                            set =
                                function(info, value)
                                    local channelKey = info[#info-4];
                                    GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.LowIntensityInterferenceFalloff = value;
                                end,
                        },
                        highIntensityInterferenceFalloff =
                        {
                            name = "Static(H) falloff (yards)",
                            type = "range",
                            min = 0,
                            max = 10000,
                            softMin = 0,
                            softMax = 1000,
                            step = 1,
                            width = "full",
                            order = 4,
                            get =
                                function(info)
                                    local channelKey = info[#info-4];
                                    return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.HighIntensityInterferenceFalloff;
                                end,
                            set =
                                function(info, value)
                                    local channelKey = info[#info-4];
                                    GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.HighIntensityInterferenceFalloff = value;
                                end,
                        }
                    }
                },
                addTransmitterGroup =
                {
                    type = "group",
                    name = "|TInterface\\BUTTONS\\UI-PlusButton-Up:16:16:0:0|t Add new transmitter",
                    order = 0,
                    args =
                    {
                        addTransmitterDescription =
                        {
                            type = "description",
                            name = "Add a new transmitter at your current location by providing a name and clicking \"Add at my location\".",
                            order = 0
                        },
                        newTransmitterName =
                        {
                            name = "New transmitter name",
                            desc = "Enter a descriptive name for this transmitter.",
                            type = "input",
                            cmdHidden = true,
                            validate = GBR_ConfigService.ValidateTransmitterName,
                            set = 
                                function(info, value)
                                    local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                    configService:SetNewTransmitterName(value);
                                end,
                            get = 
                                function(info, value)
                                    local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                    return configService:GetNewTransmitterName(value);
                                end,
                            order = 1,
                        },
                        addNewTransmitterButton =
                        {
                            name = "Add at my location",
                            type = "execute",
                            disabled = 
                                function(info) 
                                    local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                    return not configService:IsAddTransmitterReady(info);
                                end,
                            order = 2,
                            func = 
                                function(info, value)
                                    local channelKey = info[#info-4];
                                    local transmitterKey = info[#info-1];

                                    local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                    local newTransmitterName = configService:GetNewTransmitterName();
                                    local newSettingsModel = configService:GetNewTransmitterSettingsModel(newTransmitterName);
                                    local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                                    local transmitterKey = configService:GetNextRandomKey();
        
                                    GBR_ConfigService.AddTransmitterToUi(
                                        addon.OptionsTable.args.channelConfig.args[channelKey].args.transmitterSettingsConfigurationPage.args.transmitterSettingsGroup.args, 
                                        transmitterKey, 
                                        newSettingsModel);
        
                                    GBR_ConfigService.AddTransmitterToDb(
                                        GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters,
                                        transmitterKey,
                                        newSettingsModel);
        
                                    configService:SetNewTransmitterName("");
                                end
                        }
                    }
                }
            }
        }        
    }
    
    for transmitterKey, transmitterData in pairs(channelData.TransmitterSettings.StationaryTransmitters) do
        GBR_ConfigService.AddTransmitterToUi(
            transmitterUiData.transmitterSettingsGroup.args, 
            transmitterKey, 
            transmitterData);
    end

    return transmitterUiData;

end

function GBR_ConfigService.AddChannelListenerToUi(targetSettingsTable, key, listenerData)
    targetSettingsTable[key] =
    {
        name = listenerData.CharacterName,
        type = "group",
        args =
        {
            characterName =
            {
                name = "Character name",
                type = "input",
                order = 0,
                width = "full",
                get = 
                    function(info)
                        local channelKey = info[#info-4];                        
                        local characterKey = info[#info-1];
                        local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);

                        return configService.StagingVars.FrequencyListeners[channelKey][characterKey].CharacterName;
                    end,
            },
            lastSeen =
            {
                name = "Last seen",
                type = "input",
                order = 1,
                width = "full",
                get = 
                    function(info)
                        local channelKey = info[#info-4];                        
                        local characterKey = info[#info-1];
                        local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE); 

                        return configService.StagingVars.FrequencyListeners[channelKey][characterKey].LastSeenDateTime;
                    end,
            }
        }
    };
end

function GBR_ConfigService.AddTransmitterToDb(targetDbTable, key, transmitterData)
    targetDbTable[key] = transmitterData;
end

function GBR_ConfigService.AddTransmitterToUi(targetSettingsTable, key, transmitterData)
    targetSettingsTable[key] =
    {
        name = GBR_ConfigService.GetTransmitterGroupName(
            transmitterData.TransmitterIsEnabled, 
            transmitterData.TransmitterName),
        type = "group",
        args =
        {
            transmitterIsActive =
            {
                name = "Transmitter is enabled",
                type = "toggle",
                order = 0,
                width = "full",
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].TransmitterIsEnabled;
                    end,
                set = 
                    function(info, value)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);

                        addon.OptionsTable.args.channelConfig.args[channelKey].args.transmitterSettingsConfigurationPage
                            .args.transmitterSettingsGroup.args[transmitterKey].name = GBR_ConfigService.GetTransmitterGroupName(
                                value,
                                GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].TransmitterName);

                        GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].TransmitterIsEnabled = value;
                    end,
            },
            transmitterName =
            {
                name = "Transmitter name",
                type = "input",
                order = 1,
                width = "full",
                validate = GBR_ConfigService.ValidateTransmitterName,
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];       

                        return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].TransmitterName;
                    end,
                set = 
                    function(info, value)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);

                        addon.OptionsTable.args.channelConfig.args[channelKey].args.transmitterSettingsConfigurationPage
                            .args.transmitterSettingsGroup.args[transmitterKey].name = GBR_ConfigService.GetTransmitterGroupName(
                                GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].TransmitterIsEnabled,
                                value);

                        GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].TransmitterName = value;
                    end,
            },
            transmitterDescription =
            {
                name = "Transmitter notes",
                type = "input",
                order = 2,
                multiline = 4,
                width = "full",
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];                                    
                        return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].TransmitterNotes;
                    end,
                set = 
                    function(info, value)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];                                    
                        GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].TransmitterNotes = value;
                    end,
            },
            updateCoordsToCurrentLocationButton =
            {
                name = "Use current location",
                type = "execute",
                order = 3,
                func =
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        local configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);

                        configService:AddCurrentLocationToTransmitterData(GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey]);
                    end,
            },
            transmitterCoordX =
            {
                name = "X pos",
                type = "input",
                width = "half",
                disabled = true,
                order = 4,
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        return string.format("%.2f", GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].WorldPositionX);
                    end,
            },
            transmitterCoordY =
            {
                name = "Y pos",
                type = "input",
                width = "half",
                disabled = true,
                order = 5,
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        return string.format("%.2f", GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].WorldPositionY);
                    end,
            },
            transmitterZoneCoordX =
            {
                name = "Zone X pos",
                type = "input",
                width = "half",
                disabled = true,
                order = 6,
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        return string.format("%.2f", GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].ZonePositionX * 100);
                    end,
            },
            transmitterZoneCoordY =
            {
                name = "Zone Y pos",
                type = "input",
                width = "half",
                disabled = true,
                order = 7,
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        return string.format("%.2f", GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].ZonePositionY * 100);
                    end,
            },
            zone =
            {
                name = "Zone",
                type = "input",
                width = "full",
                order = 8,
                disabled = true,
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].Zone;
                    end,
            },
            subZone =
            {
                name = "Sub zone",
                type = "input",
                width = "full",
                order = 9,
                disabled = true,
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].SubZone;
                    end,
            },
            transmitterDeleteDescr =
            {
                name = "|cFFFF0000If you no longer need this transmitter then you can delete it here.\nNote that this action is irreversible!|r",
                type = "description",
                width = "full",
                order = 11,
                disabled = true,
                get = 
                    function(info)
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];
                        return GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey].SubZone;
                    end,
            },
            transmitterDeleteButton = 
            {
                order = 12,
                type = "execute",
                name = "DELETE TRANSMITTER",
                width = "full",
                confirm = 
                    function()
                        return "|cFFFF0000Are you sure that you want to delete this transmitter?\n\nNote that this action is irreversible!|r"
                    end,
                func =
                    function(info, value)
                        local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                        local channelKey = info[#info-4];
                        local transmitterKey = info[#info-1];

                        addon.OptionsTable.args.channelConfig.args[channelKey].args.transmitterSettingsConfigurationPage
                            .args.transmitterSettingsGroup.args[transmitterKey] = nil;

                        GBRadioAddonDataSettingsDB.char.Channels[channelKey].TransmitterSettings.StationaryTransmitters[transmitterKey] = nil;
                    end,
            }
        }
    };
end

function GBR_ConfigService.AddChannelToDb(targetDbTable, key, channelData)
    targetDbTable[key] = channelData;

    return targetDbTable[key];
end

function GBR_ConfigService.AddChannelToUi(targetSettingsTable, key, channelData)
    targetSettingsTable[key] = 
    {
        type = "group",
        name = GBR_ConfigService.GetChannelGroupName(
            channelData.ChannelSettings.ChannelIsEnabled, 
            channelData.ChannelSettings.ChannelName,
            channelData.ChannelSettings.ChannelFrequency),
        childGroups = "tab",
        args =
        {
            channelSettingsDesc = 
            {
                order = 0,
                type = "description",
                name = channelData.ChannelSettings.ChannelName,
                fontSize = "large",
                image = "Interface\\Icons\\inv_gizmo_goblingtonkcontroller",
                imageWidth = 40,
                imageHeight = 40
            },
            channelSettingsConfigurationPage = 
            {
                type = "group",
                name = "Channel",
                args = GBR_ConfigService.AddChannelSettingsConfigurationPage(channelData),
                order = 1
            },
            identitySettingsConfigurationPage = 
            {
                type = "group",
                name = "Identity",
                args = GBR_ConfigService.AddIdentitySettingsConfigurationPage(channelData),
                order = 2
            },
            interactionSettingsConfigurationPage = 
            {
                type = "group",
                name = "Interaction",
                args = GBR_ConfigService.AddInteractionSettingsConfigurationPage(channelData),
                order = 3
            },
            transmitterSettingsConfigurationPage =
            {
                type = "group",
                name = "Transmitter",
                args = GBR_ConfigService.AddTransmitterSettingsConfigurationPage(channelData),
                childGroups = "tree",
                order = 4
            },
            channelAdminPage =
            {
                type = "group",
                name = "Admin",
                childGroups = "tab",
                args = 
                {                    
                    userAdminPage =
                    {
                        type = "group",
                        name = "Channel Users",
                        childGroups = "tree",
                        args = {
                            refreshChannelUsers =
                            {
                                type = "execute",
                                name = "Refresh user list",
                                order = 0,
                                func =
                                    function(info)
                                        local channelKey = info[#info-3];
                                        local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
                                        local frequency = GBRadioAddonDataSettingsDB.char.Channels[channelKey].ChannelSettings.ChannelFrequency;
                                        local messageModel = GBR_MessageModel:New();
                                    
                                        messageModel.MessageData.MessageType = GBR_EMessageType.WhoIsListening;                                    
                                        messageService:SendMessageForFrequency(messageModel, frequency);
                                    end,
                            },
                        },
                        order = 0
                    },
                    exportPage =
                    {
                        type = "group",
                        name = "Export",
                        childGroups = "tree",
                        args = {
                            exportChannelHeader = 
                            {
                                order = 1,
                                type = "group",
                                name = "Export channel",
                                guiInline = true,
                                args = 
                                {
                                    exportChannelDesc = 
                                    {
                                        order = 0,
                                        type = "description",
                                        name = "You can share a channel's 'Channel' and 'Transmitter' settings with other users by sharing the export string below."
                                    },
                                    channelExportString = 
                                    {
                                        order = 1,
                                        type = "input",
                                        multiline = 5,
                                        name = "Export string",
                                        width = "full",
                                        get = function(info)
                                            local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                            local key = info[#info-4];

                                            return configService:GetExportableSettingsForChannel(key);
                                        end
                                    }
                                }
                            }
                        },
                        order = 1,
                    },
                    deleteChannelPage =
                    {
                        type = "group",
                        name = "Delete",
                        childGroups = "tree",
                        args = {
                            channelDeleteHeader = 
                            {
                                order = 1,
                                type = "group",
                                name = "Delete channel",
                                guiInline = true,
                                args = 
                                {
                                    channelDeleteDesc = 
                                    {
                                        order = 0,
                                        type = "description",
                                        name = "|cFFFF0000If you no longer need this channel then you can delete it here.\nNote that this action is irreversible!|r"
                                    },
                                    channelDeleteButton = 
                                    {
                                        order = 1,
                                        type = "execute",
                                        name = "DELETE CHANNEL",
                                        width = "full",
                                        confirm = 
                                            function()
                                                return "|cFFFF0000Are you sure that you want to delete this channel?\n\nNote that this action is irreversible!|r"
                                                .."\n\nIf you proceed, please confirm that your primary channel is still set afterwards.";
                                            end,
                                        func =
                                            function(info, value)
                                                local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                                                local key = info[#info-4];
                                                local channelFrequency = GBRadioAddonDataSettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency;
                                                local resetPrimaryChannel = channelFrequency == GBRadioAddonDataSettingsDB.char.PrimaryFrequency;
                    
                                                GBRadioAddonDataSettingsDB.char.Channels[key] = nil;
                                                addon.OptionsTable.args.channelConfig.args[key] = nil;

                                                if resetPrimaryChannel then
                                                    for k,v in pairs(GBRadioAddonDataSettingsDB.char.Channels) do -- Pick the first channel to set the primary channel to.
                                                        GBRadioAddonDataSettingsDB.char.PrimaryFrequency = v.ChannelSettings.ChannelFrequency;
                                                        return;
                                                    end
                                                end
                                            end
                                    }
                                }
                            }
                        },
                        order = 2
                    }
                }
            }
        }
    };

    return targetSettingsTable[key];
end

function GBR_ConfigService:IsAddChannelReady(info)
    if self.StagingVars.NewChannelName ~= nil 
        and self.StagingVars.NewChannelName:len() > 0
        and self.StagingVars.NewChannelFrequency ~= nil 
        and self.StagingVars.NewChannelFrequency:len() > 0 then
            return true;
    end

    return false;
end

function GBR_ConfigService:IsFirstTimeUser()
    return GBRadioAddonDataSettingsDB.char.IsFirstTimeUser;
end

function GBR_ConfigService:SetIsFirstTimeUser(value)
    GBRadioAddonDataSettingsDB.char.IsFirstTimeUser = value;
end

function GBR_ConfigService:ShowMicroMenuOnLogIn()
    return GBRadioAddonDataSettingsDB.char.ShowMicroMenuOnLogIn;
end

function GBR_ConfigService:SaveMicroMenuPosition(x, y)
    GBRadioAddonDataSettingsDB.char.LastMicroMenuPosition.X = x;
    GBRadioAddonDataSettingsDB.char.LastMicroMenuPosition.Y = y;
end

function GBR_ConfigService:GetMicroMenuPosition()
    return GBRadioAddonDataSettingsDB.char.LastMicroMenuPosition;
end

function GBR_ConfigService:SetGeoToolsWorldCoordinates(x, y)
    self.StagingVars.GeoToolsWorldCoordinates.X = x;
    self.StagingVars.GeoToolsWorldCoordinates.Y = y;
end

function GBR_ConfigService:GetGeoToolsWorldCoordinates()
    return self.StagingVars.GeoToolsWorldCoordinates;
end

function GBR_ConfigService:SetGeoToolsLocalCoordinates(x, y)
    self.StagingVars.GeoToolsLocalCoordinates.X = x;
    self.StagingVars.GeoToolsLocalCoordinates.Y = y;
end

function GBR_ConfigService:GetGeoToolsLocalCoordinates()
    return self.StagingVars.GeoToolsLocalCoordinates;
end

function GBR_ConfigService:SetNewChannelName(value)
    self.StagingVars.NewChannelName = value;
end

function GBR_ConfigService:SetNewChannelFrequency(value)
    self.StagingVars.NewChannelFrequency = value;
end

function GBR_ConfigService:GetNewChannelName()
    return self.StagingVars.NewChannelName;
end

function GBR_ConfigService:GetNewChannelFrequency()
    return self.StagingVars.NewChannelFrequency;
end

function GBR_ConfigService:GetNextRandomKey()
    return date("!%Y%m%d%H%M%S");
end

function GBR_ConfigService:IsAddTransmitterReady(info)
    if self.StagingVars.NewTransmitterName ~= nil 
        and self.StagingVars.NewTransmitterName:len() > 0 then
            return true;
    end

    return false;
end

function GBR_ConfigService:SetNewTransmitterName(value)
    self.StagingVars.NewTransmitterName = value;
end

function GBR_ConfigService:GetNewTransmitterName()
    return self.StagingVars.NewTransmitterName;
end

function GBR_ConfigService:GetNewTransmitterSettingsModel(transmitterName)
    local transmitterData =
    {
        TransmitterIsEnabled = true,
        TransmitterName = transmitterName,
        TransmitterNotes = "",
    };

    self:AddCurrentLocationToTransmitterData(transmitterData);

    return transmitterData;
end

function GBR_ConfigService.GetNewChannelSettingsModel(frequency, channelName)
    return
    {
        ChannelSettings =
        {
            ChannelIsEnabled = true,
            ChannelNotificationsEnabled = true,
            ChannelName = channelName,
            ChannelFrequency = frequency,
            ChannelNotes = "",
            ChannelChatMessageColour = 
            { 
                A = 1,
                R = 1,
                G = 1,
                B = 1
            },
            ChannelChatFrames = 
            {
                [1] = true,
                [2] = false,
                [3] = false,
                [4] = false,
                [5] = false,
                [6] = false,
                [7] = false,
                [8] = false,
                [9] = false,
                [10] = false,
            },
        },
        IdentitySettings =
        {
            IdentifyOnChannelAs = GBR_ENameType.Character,
            ChannelCallsign = "",            
            ShowChannelRoles = true,
            SelectedChannelRoles =
            {
                [GBR_ERoleType.FLP] = false,
                [GBR_ERoleType.POR] = false,
                [GBR_ERoleType.AHO] = false,
                [GBR_ERoleType.AFO] = false,
                [GBR_ERoleType.AMO] = false,
                [GBR_ERoleType.ELS] = false,
                [GBR_ERoleType.EOD] = false,
                [GBR_ERoleType.JNOPGC] = false,
                [GBR_ERoleType.JNOPSC] = false,
                [GBR_ERoleType.JNOPBC] = false,
            },
        },
        InteractionSettings =
        {
            SpeakOnSend = true,
            EmoteOnSend = true,
            EmoteOnReceive = true,
            EmoteOnEmergency = true,
            AudioOnSend = true,
            AudioOnReceive = true,
            AudioOnEmergencySend = true,
            AudioOnEmergencyReceive = true,
            AudioOnNoSignal = true,
            AudioOnNotifications = true,
            ChannelEmoteCooldown = 10,
            ChannelAudioCooldown = 10,
        },
        TransmitterSettings =
        {
            UseTransmitters = false,
            AlwaysOnInInstances = true,
            TransmitterRange = 500,
            LowIntensityInterferenceFalloff = 25,
            HighIntensityInterferenceFalloff = 25,
            StationaryTransmitters = {}
        }
    };
end

function GBR_ConfigService.GetTransmitterGroupName(transmitterIsEnabled, transmitterName)
    local isEnabledElement = transmitterIsEnabled and "|TInterface\\COMMON\\Indicator-Green:16:16:0:-2|t" or "|TInterface\\COMMON\\Indicator-Red:16:16:0:-2|t";
    return isEnabledElement .. " " .. transmitterName;
end

function GBR_ConfigService.GetChannelGroupName(channelIsEnabled, channelName, channelFrequency)
    local isEnabledElement = channelIsEnabled and "|TInterface\\COMMON\\Indicator-Green:16:16:0:-2|t" or "|TInterface\\COMMON\\Indicator-Red:16:16:0:-2|t";
    return isEnabledElement .. " " .. channelName .. " (".. channelFrequency ..")";
end

function GBR_ConfigService.ValidateChannelName(info, value)
    if value:len() < 1 then return "Channel name must be at least 1 character." end;
    if value:len() > 20 then return "Channel name must be 20 characters or less." end;
    return true;
end

function GBR_ConfigService.ValidateChannelFrequency(info, value)
    if value:match("[^%w-_]") then return "Channel frequency must only contain letters, numbers, hyphens (-) or underscores (_)." end;
    if value:len() < 3 then return "Channel frequency must be at least 3 characters." end;
    if value:len() > 8 then return "Channel frequency must be 8 characters or less." end;
    return GBR_ConfigService.ValidateChannelFrequencyIsUnique(info, value);
end

function GBR_ConfigService.ValidateCallsign(info, value)
    if value:len() > 20 then return "Channel callsign must be less than 20 characters." end;
    return true;
end

function GBR_ConfigService.ValidateChannelFrequencyIsUnique(info, value)
    for k, v in pairs(GBRadioAddonDataSettingsDB.char.Channels) do
        if v.ChannelSettings.ChannelFrequency == value then 
            return "Channel frequencies must be unique.\n\nChannel frequency \"" .. value .. "\" is already in use by channel \"".. v.ChannelSettings.ChannelName .."\".\n\nPlease enter a different frequency."
        end;
    end
    return true;
end

function GBR_ConfigService.ValidateTransmitterName(info, value)
    if value:len() < 1 then return "Transmitter name must be at least 1 character." end;
    if value:len() > 20 then return "Transmitter name must be 20 characters or less." end;
    return true;
end

function GBR_ConfigService:AddFrequencyListener(frequency, characterName)

    local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
    local settingsKey = self:GetSettingsKeyForFrequency(frequency);
    local lastSeenHours, lastSeenMinutes = GetGameTime();

    local iAmListeningModel = GBR_IAmListeningModel:New
    {
        CharacterName = characterName,
        LastSeenDateTime = lastSeenHours .. ":" .. lastSeenMinutes,
    };

    if self.StagingVars.FrequencyListeners[settingsKey] == nil then
        self.StagingVars.FrequencyListeners[settingsKey] = {};
    end

    self.StagingVars.FrequencyListeners[settingsKey][characterName] = iAmListeningModel;

    self.AddChannelListenerToUi(
        addon.OptionsTable.args.channelConfig.args[settingsKey].args.channelAdminPage.args.userAdminPage.args,
        characterName,
        iAmListeningModel);

    LibStub(GBR_Constants.LIB_ACE_CONFIG_REGISTRY):NotifyChange(GBR_Constants.OPT_ADDON_ID);
end

function GBR_ConfigService.SetPronouns(pronounTable)

    GBRadioAddonDataSettingsDB.char.PronounA = pronounTable.A;

end

function GBR_ConfigService.GetDefaultPronouns(genderId)

    local defaultPronouns =
    {
        { A = "their" },
        { A = "his" },
        { A = "her" }
    };

    return defaultPronouns[genderId];

end

------------------------------------------------------

function GBR_ConfigService:GetRegisteredCommunicationFrequencies()

    local registeredFrequencies = {};

    for k, v in pairs(GBRadioAddonDataSettingsDB.char.Channels) do
        registeredFrequencies[v.ChannelSettings.ChannelFrequency] =
        {
            ChannelKey = k,
            ChannelName = v.ChannelSettings.ChannelName,
            IsEnabled = v.ChannelSettings.ChannelIsEnabled,
        };
    end

    return registeredFrequencies;

end

function GBR_ConfigService:GetAddonChannelPrefix()
    
    return GBR_Constants.OPT_ADDON_CHANNEL_PREFIX;

end

function GBR_ConfigService:GetCommChannelName()
    
    return GBR_Constants.OPT_COMM_CHANNEL_NAME;

end

function GBR_ConfigService:GetCommChannelTarget()
    
    return GBR_Constants.OPT_COMM_CHANNEL_TARGET;

end

function GBR_ConfigService.GetCharacterGender()

    if GBRadioAddonDataSettingsDB.char.Gender == nil then
        local defaultGender = UnitSex(GBR_Constants.ID_PLAYER);
        local defaultPronouns = GBR_ConfigService.GetDefaultPronouns(defaultGender);
        local defaultVoiceType = UnitSex(GBR_Constants.ID_PLAYER);
        
        GBRadioAddonDataSettingsDB.char.Gender = defaultGender;
        GBR_ConfigService.SetPronouns(defaultPronouns);
        GBRadioAddonDataSettingsDB.char.VoiceType = defaultVoiceType;
    end

    return GBRadioAddonDataSettingsDB.char.Gender;

end

function GBR_ConfigService.GetCharacterPronouns()

    local gender = GBR_ConfigService.GetCharacterGender();

    return
    {
        A = GBRadioAddonDataSettingsDB.char.PronounA,
    };
    
end

function GBR_ConfigService.GetCharacterVoiceType()

    return GBRadioAddonDataSettingsDB.char.VoiceType;

end

function GBR_ConfigService.GetDeviceName()

    return GBRadioAddonDataSettingsDB.char.DeviceName;

end

function GBR_ConfigService:IsEmoteOnEmergencyEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonDataSettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.EmoteOnEmergency;

end

function GBR_ConfigService:IsSendMessageSpeechEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonDataSettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.SpeakOnSend;

end

function GBR_ConfigService:IsSendMessageEmoteEnabled()    

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonDataSettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.EmoteOnSend;

end

function GBR_ConfigService:IsReceiveMessageEmoteEnabledForFrequency(frequency)    

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.EmoteOnReceive;

end

function GBR_ConfigService:IsSendMessageAudioEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonDataSettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.AudioOnSend;

end

function GBR_ConfigService:IsNoSignalAudioEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonDataSettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.AudioOnNoSignal;

end

function GBR_ConfigService:IsReceiveMessageAudioEnabledForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.AudioOnReceive;

end

function GBR_ConfigService:IsReceiveEmergencyMessageAudioEnabledForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.AudioOnEmergencyReceive;

end

function GBR_ConfigService:IsNotificationAudioEnabledForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.AudioOnNotifications;

end

function GBR_ConfigService:IsSendEmergencyMessageAudioEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonDataSettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.AudioOnEmergencySend;

end

function GBR_ConfigService:ShowChannelRolesForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.IdentitySettings.ShowChannelRoles;

end

function GBR_ConfigService:GetChannelEmoteCooldownPeriodForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.ChannelEmoteCooldown;

end

function GBR_ConfigService:GetChannelAudioCooldownPeriodForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.ChannelAudioCooldown;

end

function GBR_ConfigService:GetCharacterRolesForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.IdentitySettings.SelectedChannelRoles;

end

function GBR_ConfigService:GetRoleDisplayForFrequency(frequency)

    local roles = self:GetCharacterRolesForFrequency(frequency);
    local roleString = "";

    for k,v in ipairs(roles) do
        if v then
            roleString = roleString .. self._roleService:GetRoleForType(k).Icon;
        end
    end

    return roleString;

end

function GBR_ConfigService:GetCharacterDisplayNameForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    local t =
    {
        [GBR_ENameType.Character] = function()
            return UnitName(GBR_Constants.ID_PLAYER);
        end,
        [GBR_ENameType.Mrp] = function()
            return self._mrpService:GetPlayerName();
        end,
        [GBR_ENameType.Callsign] = function()
            return settingsForFrequency.IdentitySettings.ChannelCallsign;
        end,
        [GBR_ENameType.CharacterWithCallsign] = function()
            local playerName = UnitName(GBR_Constants.ID_PLAYER);

            if settingsForFrequency.IdentitySettings.ChannelCallsign ~= nil and settingsForFrequency.IdentitySettings.ChannelCallsign:len() > 0 then
                playerName = playerName .. " (" .. settingsForFrequency.IdentitySettings.ChannelCallsign .. ")";
            end

            return playerName;
        end,
        [GBR_ENameType.MrpWithCallsign] = function()
            local playerName = self._mrpService:GetPlayerName();
            
            if playerName == nil then
                playerName = UnitName(GBR_Constants.ID_PLAYER);
            end

            if settingsForFrequency.IdentitySettings.ChannelCallsign ~= nil and settingsForFrequency.IdentitySettings.ChannelCallsign:len() > 0 then
                playerName = playerName .. " (" .. settingsForFrequency.IdentitySettings.ChannelCallsign .. ")";
            end

            return playerName;
        end,
    };

    local displayName = t[settingsForFrequency.IdentitySettings.IdentifyOnChannelAs]();

    if displayName == nil or displayName:len() < 1 then
        displayName = UnitName(GBR_Constants.ID_PLAYER);
    end

    return displayName;

end

function GBR_ConfigService:GetRadioMessageDelay()
    return GBRadioAddonDataSettingsDB.char.RadioMessageDelay;
end

function GBR_ConfigService:GetChatFramesForChannel(frequency)

    local settings = self:GetSettingsForFrequency(frequency);    
    return settings.ChannelSettings.ChannelChatFrames;

end

function GBR_ConfigService:GetSettingsForFrequency(frequency)

    for k,v in pairs(GBRadioAddonDataSettingsDB.char.Channels) do
        if v.ChannelSettings.ChannelFrequency == frequency then
            return v;
        end
    end

end

function GBR_ConfigService:GetSettingsKeyForFrequency(frequency)

    for k,v in pairs(GBRadioAddonDataSettingsDB.char.Channels) do
        if v.ChannelSettings.ChannelFrequency == frequency then
            return k;
        end
    end

end

function GBR_ConfigService:GetPrimaryFrequency()
    return GBRadioAddonDataSettingsDB.char.PrimaryFrequency;
end

function GBR_ConfigService:SetPrimaryFrequency(value)
    GBRadioAddonDataSettingsDB.char.PrimaryFrequency = value;
    LibStub(GBR_Constants.LIB_ACE_CONFIG_REGISTRY):NotifyChange(GBR_Constants.OPT_ADDON_ID);
end

function GBR_ConfigService:GetTransmitterInterferenceTypeForChannelSettings(channelSettings)

    local currentPlayerLocation = self._locationService:GetCurrentCharacterLocation();
    local closestInYards = nil;
    local closestTransmitterKey = nil;    

    for k,v in pairs(channelSettings.TransmitterSettings.StationaryTransmitters) do

        if v.WorldInstanceId == currentPlayerLocation.WorldInstanceId and v.TransmitterIsEnabled then
            local distance, _, _ = self._locationService:GetWorldDistance(
                v.WorldInstanceId, 
                currentPlayerLocation.WorldPosition.X,
                currentPlayerLocation.WorldPosition.Y,
                v.WorldPositionX, 
                v.WorldPositionY);

            if closestInYards == nil or distance < closestInYards then
                closestInYards = distance;
                closestTransmitterKey = k;
            end
        end 
        
    end

    return self:GetInterferenceTypeForDistance(channelSettings, closestInYards);

end

function GBR_ConfigService:GetInterferenceTypeForDistance(primaryChannelSettings, distanceToTransmitter)

    if distanceToTransmitter == nil then 
        return GBR_EMessageInterferenceType.OutOfRange;
    end

    local transmitterRange = primaryChannelSettings.TransmitterSettings.TransmitterRange;
    local lowIntensityFalloff = primaryChannelSettings.TransmitterSettings.LowIntensityInterferenceFalloff;
    local highIntensityFalloff = primaryChannelSettings.TransmitterSettings.HighIntensityInterferenceFalloff;

    if distanceToTransmitter <= transmitterRange then 
        return GBR_EMessageInterferenceType.None;
    end

    if distanceToTransmitter <= transmitterRange + lowIntensityFalloff then 
        return GBR_EMessageInterferenceType.Low;
    end

    if distanceToTransmitter <= transmitterRange + lowIntensityFalloff + highIntensityFalloff then 
        return GBR_EMessageInterferenceType.High;
    end

    return GBR_EMessageInterferenceType.OutOfRange;

end

function GBR_ConfigService:AddCurrentLocationToTransmitterData(stationaryTransmitter)
    local playerPosition = self._locationService:GetCurrentCharacterLocation();

    stationaryTransmitter.WorldPositionX = playerPosition.WorldPosition.X;
    stationaryTransmitter.WorldPositionY = playerPosition.WorldPosition.Y;
    stationaryTransmitter.ZonePositionX = playerPosition.ZonePosition.X;
    stationaryTransmitter.ZonePositionY = playerPosition.ZonePosition.Y;
    stationaryTransmitter.MapId = playerPosition.MapId;
    stationaryTransmitter.WorldInstanceId = playerPosition.WorldInstanceId;
    stationaryTransmitter.MapTypeId = playerPosition.MapTypeId;
    stationaryTransmitter.Zone = playerPosition.Zone;
    stationaryTransmitter.SubZone = playerPosition.SubZone;

end

function GBR_ConfigService:GetExportableSettingsForChannel(channelKey)
    
    local channelSettings = GBRadioAddonDataSettingsDB.char.Channels[channelKey];
    local exportableSettings = GBR_ExportableChannelSettingsModel:New
    {
        ChannelFrequency = channelSettings.ChannelSettings.ChannelFrequency,
        ChannelSettings = channelSettings.ChannelSettings,
        InteractionSettings = channelSettings.InteractionSettings,
        TransmitterSettings = channelSettings.TransmitterSettings,
    };

    return self._serialiserService:Serialize(exportableSettings);

end

function GBR_ConfigService:GetImportedSettingsFromString(settingsString)

    local importedSettings = GBR_ExportableChannelSettingsModel:New(
        self._serialiserService:Deserialize(settingsString)
    );   

    return importedSettings;
end

function GBR_ConfigService.ImportedFrequencyExists(frequency)    

    for k, v in pairs(GBRadioAddonDataSettingsDB.char.Channels) do
        if v.ChannelSettings.ChannelFrequency == frequency then 
            return true, string.format("Channel frequency is already in use."
                .. "\n\nChannel frequency '%s' is already in use by channel '%s' and proceeding will delete your current channel settings, replacing them entirely with the new settings."
                .. "\n\nDo you want to continue?", frequency, v.ChannelSettings.ChannelName);
        end
    end

    return false, nil;

end

function GBR_ConfigService:ImportSettingsFromString(importedSettings, addToExisting)

    local microMenuService = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
    if addToExisting then
        local existingChannelKey = self:GetSettingsKeyForFrequency(importedSettings.ChannelSettings.ChannelFrequency);
        GBRadioAddonDataSettingsDB.char.Channels[existingChannelKey] = nil;
        self._addonService.OptionsTable.args.channelConfig.args[existingChannelKey] = nil;
    end

    local channelKey = self:GetNextRandomKey();
    local newSettingsModel = self.GetNewChannelSettingsModel(nil, nil); -- We're overriding the name and freq at the next step

    newSettingsModel.ChannelSettings = importedSettings.ChannelSettings;
    newSettingsModel.InteractionSettings = importedSettings.InteractionSettings;
    newSettingsModel.TransmitterSettings = importedSettings.TransmitterSettings;

    GBR_ConfigService.AddChannelToUi(
        self._addonService.OptionsTable.args.channelConfig.args, 
        channelKey, 
        newSettingsModel);

    GBR_ConfigService.AddChannelToDb(
        GBRadioAddonDataSettingsDB.char.Channels,
        channelKey,
        newSettingsModel);
                                                
    microMenuService:RefreshChannels();

end