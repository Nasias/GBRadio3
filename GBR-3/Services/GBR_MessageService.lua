GBR_MessageService = GBR_Object:New();

function GBR_MessageService:New(obj)

    self._communicationLib = LibStub(GBR_Constants.LIB_ACE_COMM);

    self._serialiserService = GBR_Singletons:FetchService(GBR_Constants.SRV_SERIALISER_SERVICE);
    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._historyService = GBR_Singletons:FetchService(GBR_Constants.SRV_HISTORY_SERVICE);
    self._playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);
    self._locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
    
    self.MessageQueue = {};

    return self:RegisterNew(obj);

end

function GBR_MessageService:SendMessage(messageModel)

    local t = {
        [GBR_EMessageType.Speech] = self.SendSpeechMessage,
        [GBR_EMessageType.SilentSpeech] = self.SendSilentSpeechMessage,
        [GBR_EMessageType.Emergency] = self.SendEmergencyMessage,
    };

    t[messageModel.MessageData.MessageType](self, messageModel);

end

function GBR_MessageService.StaticReceiveMessage(prefix, data, method, senderName)

    local messageService = GBR_SingletonService:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
    messageService:ReceiveMessage(data);

end

function GBR_MessageService:ReceiveMessage(serializedMessageData)

    local serializedMessageModel = GBR_SerializableMessageModel:New(self._serialiserService:Deserialize(serializedMessageData));
    local messageModel = serializedMessageModel:ToMessageModel();

    local messageProcessor =
    {
        [GBR_EMessageType.Speech] = self.ProcessReceivedSpeechMessage,
        [GBR_EMessageType.SilentSpeech] = self.ProcessReceivedSpeechMessage,
        [GBR_EMessageType.Emergency] = self.ProcessReceivedEmergencyMessage
    };

    messageProcessor[messageModel.MessageData.MessageType](self, messageModel);

end

function GBR_MessageService:SendSpeechMessage(messageModel)
    
    messageModel.MessageData.CharacterModel = self._playerService:GetCurrentCharacterModel();
    messageModel.MessageData.Frequency = GBRadioAddonData.SettingsDB.char.PrimaryFrequency;

    local serializedMessageData = self._serialiserService:Serialize(messageModel:ToSerializeableMessageModel());

    GBRadioAddonData:SendCommMessage(self._configService.GetAddonChannelPrefix(), serializedMessageData, self._configService.GetCommChannelTarget(), GetChannelName(self._configService.GetCommChannelName()), "ALERT");

end

function GBR_MessageService:SendSilentSpeechMessage(messageModel)
    
    messageModel.MessageData.CharacterModel = self._playerService:GetCurrentCharacterModel();
    messageModel.MessageData.Frequency = GBRadioAddonData.SettingsDB.char.PrimaryFrequency;

    local serializedMessageData = self._serialiserService:Serialize(messageModel:ToSerializeableMessageModel());

    self._communicationLib:SendCommMessage(self._configService.GetAddonChannelPrefix(), serializedMessageData, self._configService.GetCommChannelTarget(), GetChannelName(self._configService.GetCommChannelName()), "ALERT");

end

function GBR_MessageService:SendEmergencyMessage(messageModel)

    messageModel.MessageData.CharacterModel = self._playerService:GetCurrentCharacterModel();
    messageModel.MessageData.Frequency = GBRadioAddonData.SettingsDB.char.PrimaryFrequency;

    local serializedMessageData = self._serialiserService:Serialize(messageModel:ToSerializeableMessageModel());

    self._communicationLib:SendCommMessage(self._configService.GetAddonChannelPrefix(), serializedMessageData, self._configService.GetCommChannelTarget(), GetChannelName(self._configService.GetCommChannelName()), "ALERT");

end

function GBR_MessageService:ProcessReceivedSpeechMessage(messageModel)

    local registeredFrequencies = self._configService:GetRegisteredCommunicationFrequencies();
    print(registeredFrequencies[messageModel.MessageData.Frequency])
    if registeredFrequencies[messageModel.MessageData.Frequency] == nil then
        return;
    end

    local characterName = self._playerService:GetCharacterNameForNameType(GBR_ENameType.Character);
    local channelSettings = self._configService:GetSettingsForFrequency(messageModel.MessageData.Frequency);
    local chatFrame = _G["ChatFrame"..channelSettings.ChannelSettings.ChannelChatFrame];
    local channelColour = GBR_ARGB:New(channelSettings.ChannelSettings.ChannelChatMessageColour);

    if chatFrame then
        chatFrame:AddMessage(string.format(
            GBR_Constants.MSG_RADIO_MESSAGE, 
            channelColour:ToEscapedHexString(), 
            messageModel.MessageData.Frequency,
            messageModel.MessageData.CharacterModel.CharacterName,
            messageModel.MessageData.CharacterModel.CharacterDisplayName,
            messageModel.MessageData.Message));
    end

    if messageModel.MessageData.CharacterModel.CharacterName == characterName then
        self:PlaySendMessageAudio(messageModel.MessageData.CharacterModel.CharacterGender);
    else
        self:PlayReceiveMessageAudio(messageModel.MessageData.CharacterModel.CharacterGender);
    end

end

function GBR_MessageService:ProcessReceivedEmergencyMessage(messageModel)

    local registeredFrequencies = self._configService:GetRegisteredCommunicationFrequencies();

    if registeredFrequencies[messageModel.MessageData.Frequency] == nil then
        return;
    end

    local characterName = self._playerService:GetCharacterNameForNameType(GBR_ENameType.Character);
    local channelSettings = self._configService:GetSettingsForFrequency(messageModel.MessageData.Frequency);
    local chatFrame = _G["ChatFrame"..channelSettings.ChannelSettings.ChannelChatFrame];
    local channelColour = GBR_ARGB:New(channelSettings.ChannelSettings.ChannelChatMessageColour);
    
    if chatFrame then
        local emergencyMessage = messageModel.MessageData.CharacterModel.Location.ZonePosition.X ~= nil
            and string.format(
                GBR_Constants.MSG_RADIO_EMERGENCY, 
                channelColour:ToEscapedHexString(), 
                messageModel.MessageData.Frequency,
                messageModel.MessageData.CharacterModel.CharacterName,
                messageModel.MessageData.CharacterModel.CharacterDisplayName,
                messageModel.MessageData.CharacterModel.Location.Zone,
                messageModel.MessageData.CharacterModel.Location.ZonePosition.X,
                messageModel.MessageData.CharacterModel.Location.ZonePosition.Y)
            or string.format(
                GBR_Constants.MSG_RADIO_EMERGENCY_NO_COORDS, 
                channelColour:ToEscapedHexString(), 
                messageModel.MessageData.Frequency,
                messageModel.MessageData.CharacterModel.Location.CharacterName,
                messageModel.MessageData.CharacterModel.Location.CharacterDisplayName,
                messageModel.MessageData.CharacterModel.Location.Zone);

        chatFrame:AddMessage(emergencyMessage);
    end

    if messageModel.MessageData.CharacterModel.CharacterName == characterName then
        self:PlaySendEmergencyMessageAudio();
    else
        self:PlayReceiveEmergencyMessageAudio();
    end

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

function GBR_MessageService:PlayReceiveMessageAudio(characterGender)

    if not self._configService:IsReceiveMessageAudioEnabled() then
        return;
    end

    local soundTable = characterGender == GBR_EGenderType.Male 
        and self.Sounds.Receive.M 
        or self.Sounds.Receive.F;

    local audioTrack = soundTable[math.random(1, #soundTable)];

    PlaySoundFile(audioTrack, "SFX");

end

function GBR_MessageService:PlaySendEmergencyMessageAudio()

    if not self._configService:IsSendEmergencyMessageAudioEnabled() then
        return;
    end

    PlaySoundFile(self.Sounds.Emergency, "SFX");

end

function GBR_MessageService:PlayReceiveEmergencyMessageAudio()

    if not self._configService:IsReceiveEmergencyMessageAudioEnabled() then
        return;
    end

    PlaySoundFile(self.Sounds.Emergency, "SFX");

end

GBR_MessageService.Sounds = {
    Send = {
        M = {
            "Interface\\AddOns\\GBR-3\\Audio\\ms-1.ogg",
            "Interface\\AddOns\\GBR-3\\Audio\\ms-2.ogg"
        },
        F = {
            "Interface\\AddOns\\GBR-3\\Audio\\fs-1.ogg",
            "Interface\\AddOns\\GBR-3\\Audio\\fs-2.ogg"
        },
    },
    Receive = {
        M = {
            "Interface\\AddOns\\GBR-3\\Audio\\mr-1.ogg",
            "Interface\\AddOns\\GBR-3\\Audio\\mr-2.ogg"
        },
        F = {
            "Interface\\AddOns\\GBR-3\\Audio\\fr-1.ogg",
            "Interface\\AddOns\\GBR-3\\Audio\\fr-2.ogg"
        },
    },
    Emergency = "Interface\\AddOns\\GBR-3\\Audio\\emergency.ogg"
};