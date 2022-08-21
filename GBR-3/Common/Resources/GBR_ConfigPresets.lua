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
                    ChannelEmoteCooldown = 10,
                    ChannelAudioCooldown = 10,
                },
                TransmitterSettings =
                {
                    UseTransmitters = false,
                    TransmitterRange = 0,
                    LowIntensityInterferenceFalloff = 0,
                    HighntensityInterferenceFalloff = 0,
                    StationaryTransmitters = {
                        ["DEFAULT"] =
                        {
                            TransmitterIsEnabled = true,
                            TransmitterName = "Default",
                            TransmitterNotes = "This is the default transmitter for this channel. You can freely change or delete this transmitter's settings.",
                            PositionX = 0,
                            PositionY = 0,
                        }
                    }
                }
            }
        }
    }
};