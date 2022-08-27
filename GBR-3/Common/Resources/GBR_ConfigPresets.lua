GBR_ConfigPresets = {};

GBR_ConfigPresets.BuzzBox =
{
    char =
    {
        DeviceName = "buzzbox",
        PrimaryFrequency = "GBRADIO",
        RadioMessageDelay = 1.5,
        Gender = nil,
        PronounA = nil,
        PronounB = nil,
        PronounC = nil,
        VoiceType = nil,
        Channels =
        {
            ["DEFAULT"] =
            {
                ChannelSettings =
                {
                    ChannelIsEnabled = true,
                    ChannelNotificationsEnabled = true,
                    ChannelName = "Default",
                    ChannelFrequency = "GBRADIO",
                    ChannelNotes = "This is the default GBRadio channel for demonstration purposes. You can freely change or delete this channel's settings.",
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
                    StationaryTransmitters = {
                        ["DEFAULT"] =
                        {
                            TransmitterIsEnabled = true,
                            TransmitterName = "Default",
                            TransmitterNotes = "This is the default transmitter for this channel. You can freely change or delete this transmitter's settings.",
                            WorldPositionX = 0,
                            WorldPositionY = 0,
                            ZonePositionX = 0,
                            ZonePositionY = 0,
                            MapId = 0,
                            WorldInstanceId = 0,
                            MapTypeId = 0,
                            Zone = "",
                            SubZone = "",
                        }
                    }
                }
            }
        }
    }
};