GBR_ConfigService = GBR_Object:New();

function GBR_ConfigService:New(obj)

    self._mrpService = GBR_Singletons:FetchService(GBR_Constants.SRV_MRP_SERVICE);

    self.StagingVars =
    {
        NewChannelName = nil,
        NewChannelFrequency = nil,
    };

    self:Initialize();

    return self:RegisterNew(obj);

end

function GBR_ConfigService:Initialize()

    local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
    
    addon.OptionsTable = 
    {
        type = "group",
        name = "GB|cff00c0ffRadio|r 3 (v3.0.0) - by |cff00c0ffNasias Darkstar|r, Argent Dawn (EU)",
        childGroups = "tree",
        handler = addon,        
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
                                        return GBRadioAddonData.SettingsDB.char.DeviceName;
                                    end,
                                set = 
                                    function(info, value) 
                                        GBRadioAddonData.SettingsDB.char.DeviceName = value;
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
                                        return GBRadioAddonData.SettingsDB.char.PrimaryFrequency;
                                    end,
                                set = 
                                    function(info, value)                                        
                                        GBRadioAddonData.SettingsDB.char.PrimaryFrequency = value;
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
                                        return GBRadioAddonData.SettingsDB.char.RadioMessageDelay;
                                    end,
                                set = 
                                    function(info, value) 
                                        GBRadioAddonData.SettingsDB.char.RadioMessageDelay = value;
                                    end,
                                order = 4
                            }
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
                                        GBRadioAddonData.SettingsDB.char.Gender = value;
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
                            customPronounB =
                            {
                                name = "Pronoun B",
                                type = "input",
                                width = 0.75,
                                get =
                                    function(info)
                                        local pronouns = GBR_ConfigService.GetCharacterPronouns();
                                        return pronouns.B;
                                    end,
                                order = 3
                            },
                            customPronounC =
                            {
                                name = "Pronoun C",
                                type = "input",
                                width = 0.75,
                                get =
                                    function(info)
                                        local pronouns = GBR_ConfigService.GetCharacterPronouns();
                                        return pronouns.C;
                                    end,
                                order = 4
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
                                    [3] = "Femanine"
                                },
                                width = "full",
                                get = GBR_ConfigService.GetCharacterVoiceType,
                                set = 
                                    function(info, value)
                                        GBRadioAddonData.SettingsDB.char.VoiceType = value;
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
                        order = 999,
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
                                                configService:SetNewChannelName(value);
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
                                                configService:SetNewChannelFrequency(value);
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
                                                return configService:IsAddChannelReady(info);
                                            end,
                                        order = 2,
                                        func = 
                                            function(info, value)                                        
                                                local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                                                local newChannelName = configService:GetNewChannelName();
                                                local newChannelFrequency = configService:GetNewChannelFrequency();
                                                local newSettingsModel = GBR_ConfigService.GetNewSettingsModel(newChannelFrequency, newChannelName);
                                                local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                                                local channelKey = configService:GetNextChannelKey();

                                                GBR_ConfigService.AddChannelToUi(
                                                    addon.OptionsTable.args.channelConfig.args, 
                                                    channelKey, 
                                                    newSettingsModel);

                                                GBR_ConfigService.AddChannelToDb(
                                                    GBRadioAddonData.SettingsDB.char.Channels,
                                                    channelKey,
                                                    newSettingsModel);

                                                configService:SetNewChannelName("");
                                                configService:SetNewChannelFrequency("");
                                            end
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
                            },
                            getWorldCoordinatesButton =
                            {
                                name = "Get world coordinates",
                                type = "execute",
                                order = 2,
                            },
                            localCoordinatesInput =
                            {
                                name = "World coordinates",
                                type = "input",
                                order = 3,
                            },
                            getLocalCoordinatesButton =
                            {
                                name = "Get local coordinates",
                                type = "execute",
                                order = 4,
                            },
                        }
                    }                    
                }
            },
        }
    };

    for frequencyKey, channelData in pairs(GBRadioAddonData.SettingsDB.char.Channels) do
        self.AddChannelToUi(addon.OptionsTable.args.channelConfig.args, frequencyKey, channelData);
    end
    
    addon.ConfigRegistry = LibStub("AceConfig-3.0"):RegisterOptionsTable("GBRadio3", addon.OptionsTable);
    addon.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GBRadio3", "GB|cff00c0ffRadio|r 3");

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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelIsEnabled;
                        end,
                    set = 
                        function(info, value)
                            local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                            local key = info[#info-3];

                            addon.OptionsTable.args.channelConfig.args[key].name = GBR_ConfigService.GetChannelGroupName(
                                value, 
                                GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelName,                            
                                GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency);

                            GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelIsEnabled = value;
                        end,
                },
                channelName = 
                {
                    order = 1,
                    name = "Channel name",
                    desc = "Enter a descriptive name for the channel you would like to use.",
                    type = "input",
                    cmdHidden = true,
                    validate = GBR_ConfigService.ValidateChannelName,
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelName;
                        end,
                    set = 
                        function(info, value)
                            local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                            local key = info[#info-3];

                            addon.OptionsTable.args.channelConfig.args[key].name = GBR_ConfigService.GetChannelGroupName(
                                GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelIsEnabled, 
                                value,
                                GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency);

                            addon.OptionsTable.args.channelConfig.args[key].args.channelSettingsDesc.name = value;
                            GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelName = value;
                        end,
                },
                channelFrequency = 
                {
                    order = 2,
                    name = "Channel frequency",
                    desc = "Enter the channel's frequency. .\n\nOnly use letters and numbers, and don't use spaces.",
                    type = "input",
                    cmdHidden = true,
                    validate = GBR_ConfigService.ValidateChannelFrequency,
                    width = "full",
                    get = 
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency;
                        end,
                    set = 
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency = value; 
                        end,
                },
                channelNotes =
                {
                    order = 3,
                    name = "Channel notes",
                    desc = "Enter any notes that you want to keep for this channel",
                    type = "input",
                    width = "full",
                    multiline = 4,
                    get = 
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelNotes;
                        end,
                    set = 
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelNotes = value;
                        end,
                }
            }
        },
        channelChatFrameGroup = 
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
                            local colour = GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelChatMessageColour;
                            return colour.R, colour.G, colour.B, colour.A;
                        end,
                    set = 
                        function(info, r, g, b, a)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelChatMessageColour = 
                            { 
                                A = a, 
                                R = r, 
                                G = g, 
                                B = b 
                            } 
                        end,
                },
                channelChatFrame = 
                {
                    order = 1,
                    name = "Output chat frame",
                    type = "range",
                    min = 1,
                    max = 10,
                    softMin = 1,
                    softMax = 10,
                    step = 1,
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelChatFrame;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelChatFrame = value;
                        end,
                },
                channelChatFrameIdentify = 
                {
                    order = 2,
                    name = "Identify chat frames",
                    type = "execute",
                    width = "full",
                    func = 
                        function(info, val)
                            local key = info[#info-3];
                            local channelColour = GBR_ARGB:New(GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelChatMessageColour);

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
        },
        channelDeleteHeader = 
        {
            order = 4,
            type = "group",
            name = "Delete channel",
            guiInline = true,
            args = 
            {
                channelDeleteDesc = 
                {
                    order = 0,
                    type = "description",
                    name = "|cFFFF0000If you no longer need this channel then you can delete it here.\nNote that this action is irreversible!"
                },
                channelDeleteButton = 
                {
                    order = 1,
                    type = "execute",
                    name = "DELETE CHANNEL",
                    width = "full",
                    confirm = 
                        function()
                            return "|cFFFF0000Are you sure that you want to delete this channel?\n\nNote that this action is irreversible!"
                        end,
                    func =
                        function(info, value)
                            local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                            local key = info[#info-3];

                            GBRadioAddonData.SettingsDB.char.Channels[key] = nil;
                            addon.OptionsTable.args.channelConfig.args[key] = nil;
                        end
                }
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
                        [GBR_ENameType.MrpWithCallsign] = "TRP3 full name, with channel callsign",
                    },
                    style = "dropdown",
                    width = "full",
                    get = 
                        function(info)
                            local key = info[#info-3];
                            return GBRadioAddonData.SettingsDB.char.Channels[key].IdentitySettings.IdentifyOnChannelAs;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].IdentitySettings.IdentifyOnChannelAs = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].IdentitySettings.ChannelCallsign;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].IdentitySettings.ChannelCallsign = value;
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
                            local frequency = GBRadioAddonData.SettingsDB.char.Channels[key].ChannelSettings.ChannelFrequency;

                            return "|cFF00FF00[" .. GBR_ConfigService:GetCharacterDisplayNameForFrequency(frequency) .. "]|r";
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.SpeakOnSend;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.SpeakOnSend = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.EmoteOnSend;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.EmoteOnSend = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.EmoteOnReceive;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.EmoteOnReceive = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.EmoteOnEmergency;
                        end,
                    set = 
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.EmoteOnEmergency = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.AudioOnSend;
                        end,
                    set = 
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.AudioOnSend = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.AudioOnReceive;
                        end,
                    set =
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.AudioOnReceive = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.AudioOnEmergencySend;
                        end,
                    set =
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.AudioOnEmergencySend = value;
                        end,
                },
                audioOnEmergencyReceive =
                {
                    order = 6,
                    type = "toggle",
                    name = "Play audio on emergency receive",
                    width = "full",
                    get =
                        function(info) 
                            local key = info[#info-3];
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.AudioOnEmergencyReceive;
                        end,
                    set =
                        function(info, value) 
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.AudioOnEmergencyReceive = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.ChannelEmoteCooldown;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.ChannelEmoteCooldown = value;
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
                            return GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.ChannelAudioCooldown;
                        end,
                    set = 
                        function(info, value)
                            local key = info[#info-3];
                            GBRadioAddonData.SettingsDB.char.Channels[key].InteractionSettings.ChannelAudioCooldown = value;
                        end,
                },
            }
        },
    }

end

function GBR_ConfigService.AddTransmitterSettingsConfigurationPage()

    return
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
                        },
                        HighIntensityInterferenceFalloff =
                        {
                            name = "Static(H) falloff (yards)",
                            type = "range",
                            min = 0,
                            max = 10000,
                            softMin = 0,
                            softMax = 1000,
                            step = 1,
                            width = "full",
                        }
                    }
                },
                addTransmitterGroup =
                {
                    type = "group",
                    name = "Add new transmitter",
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
                            -- set = 
                            --     function(info, value)
                            --         local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                            --         configService:SetNewChannelName(value);
                            --     end,
                            -- get = 
                            --     function(info, value)
                            --         local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                            --         return configService:GetNewChannelName(value);
                            --     end,
                            order = 1,
                        },
                        addNewTransmitterButton =
                        {
                            name = "Add at my location",
                            type = "execute",
                            -- disabled = 
                            --     function(info) 
                            --         local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                            --         return configService:IsAddChannelReady(info);
                            --     end,
                            order = 2,
                            -- func = 
                            --     function(info, value)                                        
                            --         local configService = GBR_SingletonService:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
                            --         local newChannelName = configService:GetNewChannelName();
                            --         local newChannelFrequency = configService:GetNewChannelFrequency();
                            --         local newSettingsModel = GBR_ConfigService.GetNewSettingsModel(newChannelFrequency, newChannelName);
                            --         local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
                            --         local channelKey = configService:GetNextChannelKey();
        
                            --         GBR_ConfigService.AddChannelToUi(
                            --             addon.OptionsTable.args.channelConfig.args, 
                            --             channelKey, 
                            --             newSettingsModel);
        
                            --         GBR_ConfigService.AddChannelToDb(
                            --             GBRadioAddonData.SettingsDB.char.Channels,
                            --             channelKey,
                            --             newSettingsModel);
        
                            --         configService:SetNewChannelName("");
                            --         configService:SetNewChannelFrequency("");
                            --     end
                        }
                    }
                },
                tmp = {
                    name = "Test transmitter 1",
                    type = "group",
                    args =
                    {
                        transmitterIsActive =
                        {
                            name = "Transmitter is enabled",
                            type = "toggle",
                            order = 0,
                            width = "full",
                        },
                        transmitterName =
                        {
                            name = "Transmitter name",
                            type = "input",
                            order = 1,
                            width = "full",
                        },
                        transmitterCoordX =
                        {
                            name = "X Pos",
                            type = "input",
                            width = "half",
                            order = 2,
                        },
                        transmitterCoordY =
                        {
                            name = "Y Pos",
                            type = "input",
                            width = "half",
                            order = 3,
                        },
                        updateCoordsToCurrentLocationButton =
                        {
                            name = "Use current location",
                            type = "execute",
                            order = 4,
                        },
                        transmitterDescription =
                        {
                            name = "Transmitter notes",
                            type = "input",
                            order = 5,
                            multiline = 4,
                            width = "full"
                        }
                    }
                },
                tmp2 = {
                    name = "Test transmitter 2",
                    type = "group",
                    args =
                    {
                        transmitterName =
                        {
                            name = "Transmitter name",
                            type = "input",
                            order = 0,
                            width = "full",
                        },
                        transmitterCoordX =
                        {
                            name = "X Pos",
                            type = "input",
                            width = "half",
                            order = 1,
                        },
                        transmitterCoordY =
                        {
                            name = "Y Pos",
                            type = "input",
                            width = "half",
                            order = 2,
                        },
                        transmitterDescription =
                        {
                            name = "Transmitter notes",
                            type = "input",
                            order = 4,
                            multiline = 4,
                            width = "full"
                        }
                    }
                }   
            }
        }        
    }

end

function GBR_ConfigService.AddChannelToDb(targetDbTable, key, channelData)
    targetDbTable[key] = channelData;
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
                disabled = true,
                args = {                    
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
                                order = 0
                            },
                            ["Testcharacter1"] =
                            {
                                type = "group",
                                name = "Nasias",
                                args = {
                                    blacklistUserDesc =
                                    {
                                        type = "description",
                                        name = "Blacklist this user from being able to send and receive messages on this frequency."
                                    },
                                    blacklistUser =
                                    {
                                        type = "execute",
                                        name = "Blacklist user",
                                        order = 1
                                    }
                                }
                            },
                            ["Testcharacter2"] =
                            {
                                type = "group",
                                name = "Róok",
                                args = {
                                    blacklistUserDesc =
                                    {
                                        type = "description",
                                        name = "Blacklist this user from being able to send and receive messages on this frequency."
                                    },
                                    blacklistUser =
                                    {
                                        type = "execute",
                                        name = "Blacklist User",
                                        order = 1
                                    }
                                }
                            },
                            ["Testcharacter3"] =
                            {
                                type = "group",
                                name = "Isilador",
                                args = {
                                    blacklistUserDesc =
                                    {
                                        type = "description",
                                        name = "Blacklist this user from being able to send and receive messages on this frequency."
                                    },
                                    blacklistUser =
                                    {
                                        type = "execute",
                                        name = "Blacklist User",
                                        order = 1
                                    }
                                }
                            },
                        },
                        order = 0
                    }
                },
                order = 5
            }
        }
    }

end

function GBR_ConfigService:IsAddChannelReady(info)

    if self.StagingVars.NewChannelName ~= nil 
        and self.StagingVars.NewChannelName:len() > 0
        and self.StagingVars.NewChannelFrequency ~= nil 
        and self.StagingVars.NewChannelFrequency:len() > 0 then
            return false;
    end

    return true;
end

function GBR_ConfigService:SetNewChannelName(value)
    self.StagingVars.NewChannelName = value;
end

function GBR_ConfigService:SetNewChannelFrequency(value)
    self.StagingVars.NewChannelFrequency = value;
end

function GBR_ConfigService:GetNewChannelName(value)
    return self.StagingVars.NewChannelName;
end

function GBR_ConfigService:GetNewChannelFrequency(value)
    return self.StagingVars.NewChannelFrequency;
end

function GBR_ConfigService:GetNextChannelKey()
    return date("!%Y%m%d%H%M%S");
end

function GBR_ConfigService.GetNewSettingsModel(frequency, channelName)
    return
    {
        ChannelSettings =
        {
            ChannelIsEnabled = true,
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
            ChannelChatFrame = 1,
        },
        IdentitySettings =
        {
            IdentifyOnChannelAs = GBR_ENameType.Character,
            ChannelCallsign = "",
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
            ChannelEmoteCooldown = 10,
            ChannelAudioCooldown = 10,
        }
    };
end

function GBR_ConfigService.GetChannelGroupName(channelIsEnabled, channelName, channelFrequency)
    --local isEnabledElement = channelIsEnabled and "|cFF00FF00•|r" or "|cFFFF0000•|r";
    local isEnabledElement = channelIsEnabled and "|TInterface\\COMMON\\Indicator-Green:16:16:0:-2|t" or "|TInterface\\COMMON\\Indicator-Red:16:16:0:-2|t";
    return isEnabledElement .. " " .. channelName .. " (".. channelFrequency ..")";
end

function GBR_ConfigService.ValidateChannelName(info, value)
    if value:len() < 1 then return "Channel name must be at least 1 character." end;
    if value:len() > 20 then return "Channel name must be 12 characters or less." end;
    return true;
end

function GBR_ConfigService.ValidateChannelFrequency(info, value)
    if value:match("%W") then return "Channel frequency must only contain letters or numbers." end;
    if value:len() < 3 then return "Channel frequency must be at least 3 characters." end;
    if value:len() > 8 then return "Channel frequency must be 8 characters or less." end;
    return GBR_ConfigService.ValidateChannelFrequencyIsUnique(info, value);
end

function GBR_ConfigService.ValidateCallsign(info, value)
    if value:len() > 20 then return "Channel callsign must be less than 20 characters." end;
    return true;
end

function GBR_ConfigService.ValidateChannelFrequencyIsUnique(info, value)
    for k, v in pairs(GBRadioAddonData.SettingsDB.char.Channels) do
        if v.ChannelSettings.ChannelFrequency == value then 
            return "Channel frequencies must be unique.\n\nChannel frequency \"" .. value .. "\" is already in use by channel \"".. v.ChannelSettings.ChannelName .."\".\n\nPlease enter a different frequency."
        end;
    end
    return true;
end


function GBR_ConfigService:GetRegisteredCommunicationFrequencies()

    local registeredFrequencies = {};

    for k, v in pairs(GBRadioAddonData.SettingsDB.char.Channels) do
        registeredFrequencies[v.ChannelSettings.ChannelFrequency] =
        {
            ChannelKey = k,
            ChannelName = v.ChannelSettings.ChannelName,
            IsEnabled = v.ChannelSettings.ChannelIsEnabled,
        };
    end

    return registeredFrequencies;

end

------------------------------------------------------

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

    if GBRadioAddonData.SettingsDB.char.Gender == nil then
        local defaultGender = UnitSex(GBR_Constants.ID_PLAYER);
        local defaultPronouns = GBR_ConfigService.GetDefaultPronouns(defaultGender);
        local defaultVoiceType = UnitSex(GBR_Constants.ID_PLAYER);
        
        GBRadioAddonData.SettingsDB.char.Gender = defaultGender;
        GBR_ConfigService.SetPronouns(defaultPronouns);
        GBRadioAddonData.SettingsDB.char.VoiceType = defaultVoiceType;
    end

    return GBRadioAddonData.SettingsDB.char.Gender;

end

function GBR_ConfigService.SetPronouns(pronounTable)

    GBRadioAddonData.SettingsDB.char.PronounA = pronounTable.A;
    GBRadioAddonData.SettingsDB.char.PronounB = pronounTable.B;
    GBRadioAddonData.SettingsDB.char.PronounC = pronounTable.C;

end

function GBR_ConfigService.GetDefaultPronouns(genderId)

    local defaultPronouns =
    {
        { A = "their", B = "them", C = "they" },
        { A = "his",  B = "him",    C = "he" },
        { A = "her",  B = "her",   C = "she" }
    };

    return defaultPronouns[genderId];

end

function GBR_ConfigService.GetCharacterPronouns()

    local gender = GBR_ConfigService.GetCharacterGender();

    return
    {
        A = GBRadioAddonData.SettingsDB.char.PronounA,
        B = GBRadioAddonData.SettingsDB.char.PronounB,
        C = GBRadioAddonData.SettingsDB.char.PronounC
    };
    
end

function GBR_ConfigService.GetCharacterVoiceType()

    return GBRadioAddonData.SettingsDB.char.VoiceType;

end

function GBR_ConfigService.GetDeviceName()

    return GBRadioAddonData.SettingsDB.char.DeviceName;

end

function GBR_ConfigService:GetDefaultNamePreference()

    return GBR_ENameType.Character;

end

function GBR_ConfigService:IsEmoteOnEmergencyEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonData.SettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.EmoteOnEmergency;

end

function GBR_ConfigService:IsSendMessageSpeechEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonData.SettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.SpeakOnSend;

end

function GBR_ConfigService:IsSendMessageEmoteEnabled()    

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonData.SettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.EmoteOnSend;

end

function GBR_ConfigService:IsReceiveMessageEmoteEnabledForFrequency(frequency)    

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.EmoteOnReceive;

end

function GBR_ConfigService:IsSendMessageAudioEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonData.SettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.AudioOnSend;

end

function GBR_ConfigService:IsReceiveMessageAudioEnabledForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.AudioOnReceive;

end

function GBR_ConfigService:IsReceiveEmergencyMessageAudioEnabledForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.AudioOnEmergencyReceive;

end

function GBR_ConfigService:IsSendEmergencyMessageAudioEnabled()

    local settingsForFrequency = self:GetSettingsForFrequency(GBRadioAddonData.SettingsDB.char.PrimaryFrequency);
    return settingsForFrequency.InteractionSettings.AudioOnEmergencySend;

end

function GBR_ConfigService:GetChannelEmoteCooldownPeriodForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.ChannelEmoteCooldown;

end

function GBR_ConfigService:GetChannelAudioCooldownPeriodForFrequency(frequency)

    local settingsForFrequency = self:GetSettingsForFrequency(frequency);
    return settingsForFrequency.InteractionSettings.ChannelAudioCooldown;

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
        [GBR_ENameType.MrpWithCallsign] = function()
            local playerName = self._mrpService:GetPlayerName();
            
            if playerName == nil then
                playerName = UnitName(GBR_Constants.ID_PLAYER)
            end

            if settingsForFrequency.IdentitySettings.ChannelCallsign ~= nil and settingsForFrequency.IdentitySettings.ChannelCallsign:len() > 1 then
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
    return GBRadioAddonData.SettingsDB.char.RadioMessageDelay;
end

function GBR_ConfigService:GetChatFrameForChannel(frequency)

    local settings = self:GetSettingsForFrequency(frequency);    
    return settings.ChannelSettings.ChannelChatFrame;

end

function GBR_ConfigService:GetSettingsForFrequency(frequency)

    for k,v in pairs(GBRadioAddonData.SettingsDB.char.Channels) do
        if v.ChannelSettings.ChannelFrequency == frequency then
            return v;
        end
    end

end