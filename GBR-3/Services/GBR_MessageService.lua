GBR_MessageService = GBR_Object:New();

function GBR_MessageService:New(obj)

    self._communicationLib = LibStub(GBR_Constants.LIB_ACE_COMM);

    self._serialiserService = GBR_Singletons:FetchService(GBR_Constants.SRV_SERIALISER_SERVICE);
    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._historyService = GBR_Singletons:FetchService(GBR_Constants.SRV_HISTORY_SERVICE);
    self._playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);
    self._locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
    self._notificationService = GBR_Singletons:FetchService(GBR_Constants.SRV_NOTIFICATION_SERVICE);
    self._hyperlinkService = GBR_Singletons:FetchService(GBR_Constants.SRV_HYPERLINK_SERVICE);
    self._roleService = GBR_Singletons:FetchService(GBR_Constants.SRV_ROLE_SERVICE);

    self.ReceivedAudioCooldowns = {};
    self.ReceivedEmoteCooldowns = {};
    
    self.MessageQueue = {};

    return self:RegisterNew(obj);

end

function GBR_MessageService:SendMessage(messageModel)

    local primaryFrequency = self._configService:GetPrimaryFrequency();
    self:SendMessageForFrequency(messageModel, primaryFrequency);

end

function GBR_MessageService:SendMessageForFrequency(messageModel, frequency)

    local channelSettings = self._configService:GetSettingsForFrequency(frequency);

    local channelColour = GBR_ARGB:New(channelSettings.ChannelSettings.ChannelChatMessageColour);

    if not channelSettings.ChannelSettings.ChannelIsEnabled then

        local message = string.format(
            GBR_Constants.MSG_RADIO_RADIO_OFF_ERROR,
            channelColour:ToEscapedHexString(),
            frequency);

        self:SendToSelectedChatFrames(channelSettings.ChannelSettings.ChannelChatFrames, message);

    end

    if channelSettings.TransmitterSettings.UseTransmitters then

        local interferenceType = self:AddMessageInterference(messageModel, channelSettings);

        if interferenceType == GBR_EMessageInterferenceType.OutOfRange then
            local message = string.format(
                GBR_Constants.MSG_RADIO_TRANSMITTER_RANGE_ERROR,
                channelColour:ToEscapedHexString(),
                frequency);
            
            self:SendToSelectedChatFrames(channelSettings.ChannelSettings.ChannelChatFrames, message);

            self:PlayNoSignalAudio();
        end            
    end

    messageModel.MessageData.Frequency = frequency;    
    messageModel.MessageData.CharacterModel = self._playerService:GetCurrentCharacterModel();
    messageModel.MessageData.CharacterModel.CharacterDisplayName = self._configService:GetCharacterDisplayNameForFrequency(frequency);
    messageModel.MessageData.CharacterModel.CharacterRoles = self._configService:GetCharacterRolesForFrequency(frequency);

    local dispatchMethod = {
        [GBR_EMessageType.Speech] = self.SendSpeechMessage,
        [GBR_EMessageType.SilentSpeech] = self.SendSilentSpeechMessage,
        [GBR_EMessageType.Emergency] = self.SendEmergencyMessage,
        [GBR_EMessageType.WhoIsListening] = self.SendWhoIsListeningMessage,
        [GBR_EMessageType.Notification] = self.SendNotificationMessage,
    };

    dispatchMethod[messageModel.MessageData.MessageType](self, messageModel);
end

function GBR_MessageService.StaticReceiveMessage(prefix, data, method, senderName)

    local messageService = GBR_SingletonService:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
    messageService:ReceiveMessage(data);

end

function GBR_MessageService:ReceiveMessage(serializedMessageData)

    local messageModel = GBR_MessageModel:New
    {
        MessageData = self._serialiserService:Deserialize(serializedMessageData)
    };


    local registeredFrequencies = self._configService:GetRegisteredCommunicationFrequencies();

    if registeredFrequencies[messageModel.MessageData.Frequency] == nil or not registeredFrequencies[messageModel.MessageData.Frequency].IsEnabled then
        return;
    end

    local receivingFrequencySettings = self._configService:GetSettingsForFrequency(messageModel.MessageData.Frequency);

    if receivingFrequencySettings.TransmitterSettings.UseTransmitters then

        local interferenceType = self:AddMessageInterference(messageModel, receivingFrequencySettings);

        if interferenceType == GBR_EMessageInterferenceType.OutOfRange then
            return;
        end  

    end

    local messageProcessor =
    {
        [GBR_EMessageType.Speech] = self.ProcessReceivedSpeechMessage,
        [GBR_EMessageType.SilentSpeech] = self.ProcessReceivedSpeechMessage,
        [GBR_EMessageType.Emergency] = self.ProcessReceivedEmergencyMessage,
        [GBR_EMessageType.WhoIsListening] = self.ProcessReceivedWhoIsListeningMessage,
        [GBR_EMessageType.IAmListening] = self.ProcessReceivedIAmListeningMessage,
        [GBR_EMessageType.Notification] = self.ProcessReceivedNotification,
    };

    messageProcessor[messageModel.MessageData.MessageType](self, messageModel);

end

function GBR_MessageService:SendSpeechMessage(messageModel)

    local serializedMessageData = self._serialiserService:Serialize(messageModel.MessageData);

    self:ProcessSendEmote();
    self:ProcessSendSpeech(messageModel);

    GBR_Delay:Delay(
        self._configService:GetRadioMessageDelay(),
        self._communicationLib.SendCommMessage,
        self._communicationLib,
        self._configService.GetAddonChannelPrefix(),
        serializedMessageData,
        self._configService.GetCommChannelTarget(),
        GetChannelName(self._configService.GetCommChannelName()),
        "ALERT");

end

function GBR_MessageService:SendSilentSpeechMessage(messageModel)

    local serializedMessageData = self._serialiserService:Serialize(messageModel.MessageData);

    self:ProcessSilentSendEmote();

    GBR_Delay:Delay(
        self._configService:GetRadioMessageDelay(),
        self._communicationLib.SendCommMessage,
        self._communicationLib,
        self._configService.GetAddonChannelPrefix(),
        serializedMessageData,
        self._configService.GetCommChannelTarget(),
        GetChannelName(self._configService.GetCommChannelName()),
        "ALERT");

end

function GBR_MessageService:SendEmergencyMessage(messageModel)
    
    local serializedMessageData = self._serialiserService:Serialize(messageModel.MessageData);    
    local zonePosition = messageModel.MessageData.CharacterModel.Location.ZonePosition;
    
    local notificationMessageModel = GBR_MessageModel:New
    {
        MessageData =
        {    
            Frequency = messageModel.MessageData.Frequency,
            CharacterModel = messageModel.MessageData.CharacterModel,
            MessageType = GBR_EMessageType.Notification,
            NotificationModel = GBR_NotificationModel:New
            {
                Title = "PANIC ALERT",
                Grade = GBR_ENotificationGradeType.Grade1,
                IncidentLocation = messageModel.MessageData.CharacterModel.Location.Zone,
                IncidentReporter = messageModel.MessageData.CharacterModel.CharacterDisplayName,
                IncidentFrequency = messageModel.MessageData.Frequency,
                IncidentDescription = "A panic button has been pressed by " 
                    .. messageModel.MessageData.CharacterModel.CharacterDisplayName 
                    .. " at " 
                    .. messageModel.MessageData.CharacterModel.Location.Zone .. ".\n\nAll available units are required to respond with urgency.",
                UnitsRequired = "All available units"
            }
        }
    };
    
    if zonePosition.X ~= nil and zonePosition.Y ~= nil then
        
        notificationMessageModel.MessageData.NotificationModel.LocationCoordinateX = zonePosition.X * 100;
        notificationMessageModel.MessageData.NotificationModel.LocationCoordinateY = zonePosition.Y * 100;
    end

    self:ProcessEmergencySendEmote();

    GBR_Delay:Delay(
        self._configService:GetRadioMessageDelay(),
        self._communicationLib.SendCommMessage,
        self._communicationLib,
        self._configService.GetAddonChannelPrefix(),
        serializedMessageData,
        self._configService.GetCommChannelTarget(),
        GetChannelName(self._configService.GetCommChannelName()),
        "ALERT");

    GBR_Delay:Delay(
        self._configService:GetRadioMessageDelay() + 2,        
        self.SendNotificationMessage,
        self,
        notificationMessageModel);

end

function GBR_MessageService:SendWhoIsListeningMessage(messageModel)    

    messageModel.MessageData.CharacterModel = self._playerService:GetCurrentCharacterModel();

    local serializedMessageData = self._serialiserService:Serialize(messageModel.MessageData);

    self._communicationLib:SendCommMessage(
        self._configService.GetAddonChannelPrefix(),
        serializedMessageData,
        self._configService.GetCommChannelTarget(),
        GetChannelName(self._configService.GetCommChannelName()),
        "ALERT");
end

function GBR_MessageService:SendIAmListeningMessage(responseFrequency)    

    local messageModel = GBR_MessageModel:New
    {
        MessageData =
        {
            CharacterModel = self._playerService:GetCurrentCharacterModel(),
            Frequency = responseFrequency,
            MessageType = GBR_EMessageType.IAmListening,
        }
    };

    local serializedMessageData = self._serialiserService:Serialize(messageModel.MessageData);

        self._communicationLib:SendCommMessage(
            self._configService.GetAddonChannelPrefix(),
            serializedMessageData,
            self._configService.GetCommChannelTarget(),
            GetChannelName(self._configService.GetCommChannelName()),
            "ALERT");
end

function GBR_MessageService:SendNotificationMessage(messageModel)

    local serializedMessageData  = self._serialiserService:Serialize(messageModel.MessageData);

    self._communicationLib:SendCommMessage(
        self._configService.GetAddonChannelPrefix(),
        serializedMessageData,
        self._configService.GetCommChannelTarget(),
        GetChannelName(self._configService.GetCommChannelName()),
        "ALERT");

end

function GBR_MessageService:ProcessReceivedSpeechMessage(messageModel)

    local characterName = self._playerService:GetCharacterNameForNameType(GBR_ENameType.Character);
    local channelSettings = self._configService:GetSettingsForFrequency(messageModel.MessageData.Frequency);
    local channelColour = GBR_ARGB:New(channelSettings.ChannelSettings.ChannelChatMessageColour);
    local roleIcons = channelSettings.IdentitySettings.ShowChannelRoles and self._roleService:GetRoleIconsForRoles(messageModel.MessageData.CharacterModel.CharacterRoles) or "";
    local message = string.format(
        GBR_Constants.MSG_RADIO_MESSAGE, 
        channelColour:ToEscapedHexString(), 
        messageModel.MessageData.Frequency,
        roleIcons:len() > 0 and "[".. roleIcons .."] " or "",
        messageModel.MessageData.CharacterModel.CharacterColour,
        messageModel.MessageData.CharacterModel.CharacterName,
        messageModel.MessageData.CharacterModel.CharacterDisplayName,
        messageModel.MessageData.Message);
    
    self:SendToSelectedChatFrames(channelSettings.ChannelSettings.ChannelChatFrames, message);

    if messageModel.MessageData.CharacterModel.CharacterName == characterName then
        self:PlaySendMessageAudio(messageModel.MessageData.CharacterModel.CharacterVoiceType);
    else
        self:ProcessReceiveEmote(messageModel.MessageData.Frequency);
        self:PlayReceiveMessageAudio(messageModel.MessageData.Frequency, messageModel.MessageData.CharacterModel.CharacterVoiceType);
    end

end

function GBR_MessageService:SendToSelectedChatFrames(chatFrames, message)

    for chatFrameId, isSelected in pairs(chatFrames) do
        if isSelected then
            local chatFrame = _G["ChatFrame"..chatFrameId];
            if chatFrame then                
                chatFrame:AddMessage(message);
            end
        end
    end

end

function GBR_MessageService:ProcessReceivedEmergencyMessage(messageModel)

    local characterName = self._playerService:GetCharacterNameForNameType(GBR_ENameType.Character);
    local channelSettings = self._configService:GetSettingsForFrequency(messageModel.MessageData.Frequency);
    local channelColour = GBR_ARGB:New(channelSettings.ChannelSettings.ChannelChatMessageColour);
    local roleIcons = channelSettings.IdentitySettings.ShowChannelRoles and self._roleService:GetRoleIconsForRoles(messageModel.MessageData.CharacterModel.CharacterRoles) or "";
    local emergencyMessage = messageModel.MessageData.CharacterModel.Location.ZonePosition.X ~= nil and messageModel.MessageData.CharacterModel.Location.ZonePosition.Y ~= nil
            and string.format(
                GBR_Constants.MSG_RADIO_EMERGENCY, 
                channelColour:ToEscapedHexString(), 
                messageModel.MessageData.Frequency,
                roleIcons:len() > 0 and "[".. roleIcons .."] " or "",
                messageModel.MessageData.CharacterModel.CharacterColour,
                messageModel.MessageData.CharacterModel.CharacterName,
                messageModel.MessageData.CharacterModel.CharacterDisplayName,
                messageModel.MessageData.CharacterModel.Location.Zone,
                messageModel.MessageData.CharacterModel.Location.ZonePosition.X * 100,
                messageModel.MessageData.CharacterModel.Location.ZonePosition.Y * 100)
            or string.format(
                GBR_Constants.MSG_RADIO_EMERGENCY_NO_COORDS, 
                channelColour:ToEscapedHexString(), 
                messageModel.MessageData.Frequency,
                roleIcons:len() > 0 and "[".. roleIcons .."] " or "",
                messageModel.MessageData.CharacterModel.CharacterColour,
                messageModel.MessageData.CharacterModel.CharacterName,
                messageModel.MessageData.CharacterModel.CharacterDisplayName,
                messageModel.MessageData.CharacterModel.Location.Zone);

    self:SendToSelectedChatFrames(channelSettings.ChannelSettings.ChannelChatFrames, emergencyMessage);

    if messageModel.MessageData.CharacterModel.CharacterName == characterName then
        self:PlaySendEmergencyMessageAudio();
    else
        self:PlayReceiveEmergencyMessageAudio(messageModel.MessageData.Frequency);        
    end

end

function GBR_MessageService:ProcessReceivedWhoIsListeningMessage(messageModel)

    local characterName = self._playerService:GetCharacterNameForNameType(GBR_ENameType.Character);
    local channelSettings = self._configService:GetSettingsForFrequency(messageModel.MessageData.Frequency);

    self:SendIAmListeningMessage(messageModel.MessageData.Frequency);

end

function GBR_MessageService:ProcessReceivedIAmListeningMessage(messageModel)

    self._configService:AddFrequencyListener(messageModel.MessageData.Frequency, messageModel.MessageData.CharacterModel.CharacterName);

end

function GBR_MessageService:ProcessReceivedNotification(messageModel)

    local notificationModel = messageModel.MessageData.NotificationModel;

    self._notificationService:QueueNotification(notificationModel);
    self:PlayNotificationAudio(messageModel.MessageData.Frequency);

end

function GBR_MessageService:PlaySendMessageAudio(characterGender)

    if not self._configService:IsSendMessageAudioEnabled() then
        return;
    end

    local soundTable = characterGender == GBR_EGenderType.Male 
        and self.Sounds.Send.M 
        or self.Sounds.Send.F;

    local audioTrack = soundTable[math.random(1, #soundTable)];

    PlaySoundFile(audioTrack, "SFX");

end

function GBR_MessageService:PlayReceiveMessageAudio(frequency, characterGender)

    if not self._configService:IsReceiveMessageAudioEnabledForFrequency(frequency) 
        or not self:HasChannelAudioCooldownPassedForFrequency(frequency) then
        return;
    end

    local soundTable = characterGender == GBR_EGenderType.Male 
        and self.Sounds.Receive.M 
        or self.Sounds.Receive.F;

    local audioTrack = soundTable[math.random(1, #soundTable)];

    PlaySoundFile(audioTrack, "SFX");
    self:StartChannelAudioCooldownForFrequency(frequency);

end

function GBR_MessageService:PlaySendEmergencyMessageAudio()

    if not self._configService:IsSendEmergencyMessageAudioEnabled() then
        return;
    end

    PlaySoundFile(self.Sounds.Emergency, "SFX");

end

function GBR_MessageService:PlayNoSignalAudio()

    if not self._configService:IsNoSignalAudioEnabled() then
        return;
    end

    PlaySoundFile(self.Sounds.NoSignal, "SFX");

end

function GBR_MessageService:PlayNotificationAudio(frequency)

    if not self._configService:IsNotificationAudioEnabledForFrequency(frequency) then
        return;
    end

    PlaySoundFile(self.Sounds.Notification, "SFX");

end

function GBR_MessageService:PlayReceiveEmergencyMessageAudio(frequency)

    if not self._configService:IsReceiveEmergencyMessageAudioEnabledForFrequency(frequency) 
        or not self:HasChannelAudioCooldownPassedForFrequency(frequency) then
        return;
    end

    PlaySoundFile(self.Sounds.Emergency, "SFX");
    self:StartChannelAudioCooldownForFrequency(frequency);

end

function GBR_MessageService:ProcessSendSpeech(messageModel)

    if not self._configService:IsSendMessageSpeechEnabled() then
        return;
    end

    SendChatMessage(messageModel.MessageData.Message, "SAY", DEFAULT_CHAT_FRAME.editBox.LanguageID);

end

function GBR_MessageService:ProcessSendEmote()

    if not self._configService:IsSendMessageEmoteEnabled() then
        return;
    end

    local pronouns = self._configService:GetCharacterPronouns();
    local deviceName = self._configService:GetDeviceName();

    SendChatMessage(string.format(GBR_Constants.MSG_EMOTE_SEND_MESSAGE, pronouns.A, deviceName), "EMOTE");
end

function GBR_MessageService:ProcessSilentSendEmote()

    if not self._configService:IsSendMessageEmoteEnabled() then
        return;
    end

    local pronouns = self._configService:GetCharacterPronouns();
    local deviceName = self._configService:GetDeviceName();

    SendChatMessage(string.format(GBR_Constants.MSG_EMOTE_SILENT_SEND_MESSAGE, pronouns.A, deviceName), "EMOTE");
end

function GBR_MessageService:ProcessEmergencySendEmote()

    if not self._configService:IsSendMessageEmoteEnabled() then
        return;
    end

    local pronouns = self._configService:GetCharacterPronouns();
    local deviceName = self._configService:GetDeviceName();

    SendChatMessage(string.format(GBR_Constants.MSG_EMOTE_EMERGENCY_SEND_MESSAGE, pronouns.A, deviceName), "EMOTE");
end

function GBR_MessageService:ProcessReceiveEmote(frequency)

    if not self._configService:IsReceiveMessageEmoteEnabledForFrequency(frequency) 
        or not self:HasChannelEmoteCooldownPassedForFrequency(frequency) then
        return;
    end

    local pronouns = self._configService:GetCharacterPronouns();
    local deviceName = self._configService:GetDeviceName();
    local radioVerb = GBR_Constants.MSG_EMOTE_RECEIVE_VERBS[math.random(1, #GBR_Constants.MSG_EMOTE_RECEIVE_VERBS)];

    SendChatMessage(string.format(GBR_Constants.MSG_EMOTE_RECEIVE_MESSAGE, deviceName, radioVerb), "EMOTE");
    self:StartChannelEmoteCooldownForFrequency(frequency);
end

function GBR_MessageService:StartChannelEmoteCooldownForFrequency(frequency)

    local cooldownPeriod = self._configService:GetChannelEmoteCooldownPeriodForFrequency(frequency);
    
    self.ReceivedEmoteCooldowns[frequency] = time() + cooldownPeriod;

end

function GBR_MessageService:StartChannelAudioCooldownForFrequency(frequency)

    local cooldownPeriod = self._configService:GetChannelAudioCooldownPeriodForFrequency(frequency);
    
    self.ReceivedAudioCooldowns[frequency] = time() + cooldownPeriod;
end

function GBR_MessageService:HasChannelEmoteCooldownPassedForFrequency(frequency)

    return self.ReceivedEmoteCooldowns[frequency] == nil 
        and true
        or self.ReceivedEmoteCooldowns[frequency] <= time();

end

function GBR_MessageService:HasChannelAudioCooldownPassedForFrequency(frequency)

    return self.ReceivedAudioCooldowns[frequency] == nil 
        and true
        or self.ReceivedAudioCooldowns[frequency] <= time();

end

function GBR_MessageService:AddMessageInterference(messageModel, primaryChannelSettings)

    local interferenceType = self._configService:GetTransmitterInterferenceTypeForChannelSettings(primaryChannelSettings);
    local characterName = self._playerService:GetCharacterNameForNameType(GBR_ENameType.Character);
    local isOwnMessageReceived = messageModel.MessageData.CharacterModel.CharacterName == characterName;

    if isOwnMessageReceived or interferenceType == GBR_EMessageInterferenceType.None or interferenceType == GBR_EMessageInterferenceType.OutOfRange or messageModel.MessageData.Message == nil then
        return interferenceType;
    end

    local stringSplits;
    local letterEngulf;
    local splitInterval;
    local messageLength = messageModel.MessageData.Message:len();
    local tmp = {};
    local pivot;
    local interferenceMessage = "";
    local interferenceText = ".....";

    if interferenceType == GBR_EMessageInterferenceType.Low then
        stringSplits = math.random(0,2);
        letterEngulf = math.random(1,2);
    elseif interferenceType == GBR_EMessageInterferenceType.High then
        stringSplits = math.random(0,6);
        letterEngulf = math.random(2,6);
    end

    if stringSplits > messageLength then
        stringSplits = messageLength;
    end

    splitInterval = math.ceil(messageLength / stringSplits);

    if ((letterEngulf * 2) + 1) * stringSplits >= messageLength then
        messageModel.MessageData.Message = interferenceText;
        return interferenceType;
    end

    for i = 1, stringSplits, 1 do
            
        local startPoint = 1 + (splitInterval * ( i - 1 ) );
        local endPoint = splitInterval * i;
            
        if endPoint > messageLength then            
            endPoint = messageLength;                
        end
            
        pivot = math.random(startPoint + letterEngulf, endPoint - letterEngulf);
            
        tmp[i] = { 
            StartPoint = string.sub(messageModel.MessageData.Message, startPoint, pivot - letterEngulf),
            EndPoint = string.sub(messageModel.MessageData.Message, pivot + letterEngulf + 1, endPoint)
        }
            
    end
    
    for k, v in pairs(tmp) do
    
        interferenceMessage = interferenceMessage .. v.StartPoint .. interferenceText .. v.EndPoint;
    
    end

    messageModel.MessageData.Message = interferenceMessage:len() > 0 and interferenceMessage or interferenceText;

end

GBR_MessageService.Sounds = {
    Send = {
        M = {
            [[Interface\AddOns\GBR-3\Media\Audio\ms-1.ogg]],
            [[Interface\AddOns\GBR-3\Media\Audio\ms-2.ogg]]
        },
        F = {
            [[Interface\AddOns\GBR-3\Media\Audio\fs-1.ogg]],
            [[Interface\AddOns\GBR-3\Media\Audio\fs-2.ogg]]
        },
    },
    Receive = {
        M = {
            [[Interface\AddOns\GBR-3\Media\Audio\mr-1.ogg]],
            [[Interface\AddOns\GBR-3\Media\Audio\mr-2.ogg]]
        },
        F = {
            [[Interface\AddOns\GBR-3\Media\Audio\fr-1.ogg]],
            [[Interface\AddOns\GBR-3\Media\Audio\fr-2.ogg]]
        },
    },
    Emergency = [[Interface\AddOns\GBR-3\Media\Audio\emergency.ogg]],
    NoSignal = [[Interface\AddOns\GBR-3\Media\Audio\no-signal.ogg]],
    Notification = [[Interface\AddOns\GBR-3\Media\Audio\notification.ogg]]
};
