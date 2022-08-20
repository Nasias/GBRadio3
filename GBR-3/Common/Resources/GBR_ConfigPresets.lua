GBR_ConfigPresets = {};

GBR_ConfigPresets.BuzzBox =
{
    char =
    {
        DeviceName = "buzzbox",
        PrimaryFrequency = "GBRADIO1",
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
                    ChannelFrequency = "GBRADIO1",
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
                    ChannelEmoteCooldown = 5,
                    ChannelAudioCooldown = 5,
                }
            }
        }
    }
};