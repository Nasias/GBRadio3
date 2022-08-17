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

    t[messageModel.MessageType](self, messageModel);

end

function GBR_MessageService.StaticReceiveMessage(prefix, data, method, senderName)

    local messageService = GBR_SingletonService:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
    messageService:ReceiveMessage(data);

end

function GBR_MessageService:ReceiveMessage(serializedMessageData)

    local serializedMessageModel = GBR_SerializableMessageModel:New(self._serialiserService:Deserialize(serializedMessageData));
    local messageModel = serializedMessageModel:ToMessageModel();

    self:PlayReceiveMessageAudio(messageModel.MessageData.CharacterModel.CharacterGender);

    print("Received message:");
    print(messageModel.MessageData.Message);
    print(messageModel.MessageData.Timestamp);
    print(messageModel.MessageData.MessageType);
    print(messageModel.MessageData.CharacterModel.CharacterName);
    print(messageModel.MessageData.CharacterModel.MSPName);    
    print(messageModel.MessageData.CharacterModel.CharacterCallsign);
    print(messageModel.MessageData.CharacterModel.CharacterColour:ToHexString());
    print(messageModel.MessageData.CharacterModel.CharacterGender);
    print(messageModel.MessageData.CharacterModel.Location.ZonePosition.X, messageModel.MessageData.CharacterModel.Location.ZonePosition.Y, messageModel.MessageData.CharacterModel.Location.ZonePosition.Z);
    print(messageModel.MessageData.CharacterModel.Location.WorldPosition.X, messageModel.MessageData.CharacterModel.Location.WorldPosition.Y, messageModel.MessageData.CharacterModel.Location.WorldPosition.Z);
    print(messageModel.MessageData.CharacterModel.Location.Zone);
    print(messageModel.MessageData.CharacterModel.Location.SubZone);
    print(messageModel.MessageData.CharacterModel.Location.MapId);
    print(messageModel.MessageData.CharacterModel.Location.LocationType);

end

function GBR_MessageService:SendSpeechMessage(messageModel)
    
    messageModel.MessageData.CharacterModel = self._playerService:GetCurrentCharacterModel();

    local serializedMessageData = self._serialiserService:Serialize(messageModel:ToSerializeableMessageModel());

    GBRadioAddonData:SendCommMessage(self._configService.GetAddonChannelPrefix(), serializedMessageData, self._configService.GetCommChannelTarget(), GetChannelName(self._configService.GetCommChannelName()), "ALERT");

    self:PlaySendMessageAudio(messageModel.MessageData.CharacterModel.CharacterGender);

    print("Sent message:");
    print(messageModel.MessageData.Message);
    print(messageModel.MessageData.Timestamp);
    print(messageModel.MessageData.MessageType);
    print(messageModel.MessageData.CharacterModel.CharacterName);
    print(messageModel.MessageData.CharacterModel.MSPName);    
    print(messageModel.MessageData.CharacterModel.CharacterCallsign);
    print(messageModel.MessageData.CharacterModel.CharacterColour:ToHexString());
    print(messageModel.MessageData.CharacterModel.CharacterGender);
    print(messageModel.MessageData.CharacterModel.Location.ZonePosition.X, messageModel.MessageData.CharacterModel.Location.ZonePosition.Y, messageModel.MessageData.CharacterModel.Location.ZonePosition.Z);
    print(messageModel.MessageData.CharacterModel.Location.WorldPosition.X, messageModel.MessageData.CharacterModel.Location.WorldPosition.Y, messageModel.MessageData.CharacterModel.Location.WorldPosition.Z);
    print(messageModel.MessageData.CharacterModel.Location.Zone);
    print(messageModel.MessageData.CharacterModel.Location.SubZone);
    print(messageModel.MessageData.CharacterModel.Location.MapId);
    print(messageModel.MessageData.CharacterModel.Location.LocationType);

end

function GBR_MessageService:SendSilentSpeechMessage(messageModel)
    
    messageModel.MessageData.CharacterModel = self._playerService:GetCurrentCharacterModel();

    local serializedMessageData = self._serialiserService:Serialize(messageModel:ToSerializeableMessageModel());

    self._communicationLib:SendCommMessage(self._configService.GetAddonChannelPrefix(), serializedMessageData, self._configService.GetCommChannelTarget(), GetChannelName(self._configService.GetCommChannelName()), "ALERT");

    self:PlaySendMessageAudio(messageModel.MessageData.CharacterModel.CharacterGender);

end

function GBR_MessageService:SendEmergencyMessage()

    messageModel.MessageData.CharacterModel = self._playerService:GetCurrentCharacterModel();

    local characterData = messageModel.MessageData.CharacterModel;
    local characterName = characterData.MSPName ~= nil and characterData.MSPName or characterData.CharacterName;

    local message = string.format("A state-zero panic button has been activated by %s in %s -- The last known co-ordinates are %.3f, %.3f", messageModal.MessageData.CharacterModel.CharacterName);
    

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
    Emergency = {
        "Interface\\AddOns\\GBR-3\\Audio\\emergency.ogg"
    }
};