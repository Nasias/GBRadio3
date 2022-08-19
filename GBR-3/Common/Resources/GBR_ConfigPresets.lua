GBR_ConfigPresets = {};

GBR_ConfigPresets.BuzzBox =
{
    char =
    {
        DeviceName = "buzzbox",
        Channels =
        {
            ["DEFAULT"] =
            {
                ChannelSettings =
                {
                    ChannelIsEnabled = true,
                    ChannelName = "Default Channel",
                    ChannelFrequency = "GBRADIO",
                    ChannelNotes = "This is the default GBRadio channel for demonstration purposes. Feel free to change or delete this.",
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
                    AudioOnEmergency = true,
                    ChannelEmoteCooldown = 5,
                    ChannelAudioCooldown = 5,
                }
            }
        }
    }
};