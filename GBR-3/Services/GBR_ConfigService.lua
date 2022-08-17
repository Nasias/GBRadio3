GBR_ConfigService = GBR_Object:New();

function GBR_ConfigService:New(obj)

    self.Initialize();

    return self:RegisterNew(obj);


end

function GBR_ConfigService:GetCommunicationFrequencies()



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

function GBR_ConfigService:GetCharacterGender()

    return UnitSex(GBR_Constants.ID_PLAYER);

end

function GBR_ConfigService:GetDefaultNamePreference()

    return GBR_ENameType.Mrp;

end

function GBR_ConfigService:IsSendMessageAudioEnabled()

    return true;

end

function GBR_ConfigService:IsReceiveMessageAudioEnabled()

    return true;

end

function GBR_ConfigService:Initialize()

    local addon = GBR_SingletonService:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
    
    addon.OptionsTable = {
        type = "group",
        name = "GBRadio " .. GBR_Constants.OPT_ADDON_VERSION,
        childGroups = "tree",
        handler = addon,        
        args = {
            deviceConfigPage = {
                type = "group",
                name = "Device Config",
                cmdHidden = true,
                order = 0,
                args = {
                    name = {
                        name = "Comms Device Name",
                        desc = "The name of your comms device\n\nNote: This is used in emotes to describe the type of device you have, as well as in messages.",
                        type = "input",
                        --set = function(info, value) GBRadioSettingsDb.db.char["Name"] = val; end,
                        --get = function(info, value) GBRadioSettingsDb.db.char["Name"]; end,
                        width = "full",
                        cmdHidden = true,
                        order = 0
                    }
                }
            },
            channelConfig = {
                type = "group",
                name = "Channels",
                cmdHidden = true,
                order = 1,
                args = {             
                    addNewChannelPage = {
                        name = "New Channel",
                        desc = "Channel name",
                        type = "input",
                        cmdHidden = true,
                        set = function(info, value) GBR_ConfigService.AddChannel(addon.OptionsTable.args.channelConfig.args, value) end,
                    },
                    ["Channel 1"] = {
                        type = "group",
                        name = "Channel 1",
                        childGroups = "tab",
                        args = {
                            channelSettingsDesc = {
                                order = 0,
                                type = "description",
                                name = "Channel 1",
                                fontSize = "large",
                                image = "Interface\\Icons\\inv_gizmo_goblingtonkcontroller",
                                imageWidth = 40,
                                imageHeight = 40
                            },
                            channelSettingsConfigurationPage = {
                                type = "group",
                                name = "Channel",
                                args = {
                                    channelSettingsHeader = {
                                        order = 0,
                                        type = "group",
                                        name = "Channel settings",
                                        guiInline = true,
                                        args = {
                                            channelName = {
                                                order = 0,
                                                name = "Channel name",
                                                desc = "Enter a name for your channel.\n\nOnly use letters and numbers for this and please don't use spaces.",
                                                type = "input",
                                                cmdHidden = true,
                                                set = function(info, value) GBR_ConfigService.AddChannel(value) end,
                                                width = "full"
                                            }
                                        }
                                    },
                                    channelChatFrameGroup = {
                                        order = 1,
                                        name = "Chat frame settings",
                                        type = "group",
                                        guiInline = true,
                                        args = {
                                            channelChatMessageColour = {
                                                order = 0,
                                                name = "Message colour",
                                                type = "color",
                                                hasAlpha = false,
                                                width = "full"
                                            },
                                            channelChatFrame = {
                                                order = 1,
                                                name = "Output chat frame",
                                                type = "range",
                                                min = 1,
                                                max = 10,
                                                softMin = 1,
                                                softMax = 10,
                                                step = 1,
                                                width = "full"
                                            },
                                            channelChatFrameIdentify = {
                                                order = 2,
                                                name = "Identify chat frames",
                                                type = "execute",
                                                width = "full"
                                            },
                                        }
                                    },
                                    channelCooldownGroup = {
                                        order = 3,
                                        name = "Cooldown settings",
                                        type = "group",
                                        guiInline = true,
                                        args = {
                                            channelEmoteCooldown = {
                                                order = 0,
                                                name = "Emote cooldown (seconds)",
                                                type = "range",
                                                min = 0,
                                                max = 30,
                                                softMin = 0,
                                                softMax = 30,
                                                step = 1,
                                                width = "full"
                                            },
                                            channelAudioCooldown = {
                                                order = 1,
                                                name = "Audio cooldown (seconds)",
                                                type = "range",
                                                min = 0,
                                                max = 30,
                                                softMin = 0,
                                                softMax = 30,
                                                step = 1,
                                                width = "full"
                                            },
                                        }
                                    },
                                    channelDeleteHeader = {
                                        order = 4,
                                        type = "group",
                                        name = "Delete channel",
                                        guiInline = true,
                                        args = {
                                            channelDeleteDesc = {
                                                order = 0,
                                                type = "description",
                                                name = "|cFFFF0000If you no longer need this channel then you can delete it here.\nNote that this action is irreversible!"
                                            },
                                            channelDeleteButton = {
                                                order = 1,
                                                type = "execute",
                                                name = "DELETE CHANNEL",
                                                width = "full",
                                                confirm = function() return "|cFFFF0000Are you sure that you want to delete this channel?\n\nNote that this action is irreversible!" end
                                            }
                                        }
                                    }
                                }
                            },
                            identitySettingsConfigurationPage = {
                                type = "group",
                                name = "Identity",
                                args = {
                                    identityGroup = {
                                        order = 0,
                                        type = "group",
                                        name = "Identity settings",
                                        guiInline = true,
                                        args = {
                                            identifyOnChannelAs = {
                                                order = 0,
                                                type = "select",
                                                name = "Identify using",
                                                values = {[GBR_ENameType.Character] = "Character name", [GBR_ENameType.Mrp] = "TRP3 Full Name", [GBR_ENameType.Callsign] = "Channel Callsign"},
                                                style = "dropdown",
                                                width = "full"
                                            },
                                            channelCallsign = {
                                                order = 1,
                                                type = "input",
                                                name = "Channel callsign",
                                                width = "full"
                                            }
                                        }
                                    }
                                }
                            },
                            interactionSettingsConfigurationPage = {
                                type = "group",
                                name = "Interaction",
                                args = {
                                    interactionGroup = {
                                        order = 0,
                                        type = "group",
                                        name = "Interaction settings",
                                        guiInline = true,
                                        args = {
                                            speakOnSend = {
                                                order = 0,
                                                type = "toggle",
                                                name = "Speak on send",
                                            },
                                            emoteOnSend = {
                                                order = 1,
                                                type = "toggle",
                                                name = "Emote on send",
                                            },
                                            emoteOnReceive = {
                                                order = 2,
                                                type = "toggle",
                                                name = "Emote on receive",
                                            },
                                            emoteOnEmergency = {
                                                order = 3,
                                                type = "toggle",
                                                name = "Emote on emergency",
                                            },
                                        }
                                    }
                                }
                            },
                            transmitterSettingsConfigurationPage = {
                                type = "group",
                                name = "Transmitter",
                                args = {
                                    channelName = {
                                        name = "Channel Name",
                                        desc = "Enter the channel name",
                                        type = "input",
                                        cmdHidden = true,
                                        set = function(info, value) GBR_ConfigService.AddChannel(value) end,
                                    },
                                    deleteChannel = {
                                        name = "Delete Channel",
                                        desc = "Delete this channel",
                                        type = "execute"
                                    }
                                },
                                disabled = true
                            }
                        }
                    }
                }
            }
        }
    };
    
    addon.db = LibStub:GetLibrary("AceDB-3.0"):New("GBRadio3DB", {});
    addon.ConfigRegistry = LibStub("AceConfig-3.0"):RegisterOptionsTable("GBRadio3", addon.OptionsTable);
    addon.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GBRadio3", "GBRadio3");

end

function GBR_ConfigService.AddChannel(target, name)

    target[name] = {
        type = "group",
        name = name,
        args = {
            channelName = {
                name = "Channel Name",
                desc = "Enter the channel name",
                type = "input",
                cmdHidden = true,
                set = function(info, value) GBR_ConfigService.AddChannel(value) end,
            },
            deleteChannel = {
                name = "Delete Channel",
                desc = "Delete this channel",
                type = "execute"
            }
        }
    };

end