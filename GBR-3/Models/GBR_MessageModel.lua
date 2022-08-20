GBR_MessageModel = GBR_Object:New();

function GBR_MessageModel:New(obj)

    self.MessageData = 
    {
        CharacterModel = GBR_CharacterModel:New(),
        Message = nil,
        Timestamp = nil,
        MessageType = nil,
        Frequency = nil,
    };
    
    return self:RegisterNew(obj);

end

function GBR_MessageModel:ToSerializeableMessageModel()

    return GBR_SerializableMessageModel:New
    {        
        CharacterName = self.MessageData.CharacterModel.CharacterName,
        CharacterDisplayName = self.MessageData.CharacterModel.CharacterDisplayName,
        CharacterNameType = self.MessageData.CharacterModel.CharacterNameType,
        CharacterColourHex = self.MessageData.CharacterModel.CharacterColour:ToHexString(),
        CharacterGender = self.MessageData.CharacterModel.CharacterGender,
        CharacterLocationName = self.MessageData.CharacterModel.Location.Name,
        CharacterLocationZPosX = self.MessageData.CharacterModel.Location.ZonePosition.X,
        CharacterLocationZPosY = self.MessageData.CharacterModel.Location.ZonePosition.Y,
        CharacterLocationZPosZ = self.MessageData.CharacterModel.Location.ZonePosition.Z,
        CharacterLocationWPosX = self.MessageData.CharacterModel.Location.WorldPosition.X,
        CharacterLocationWPosY = self.MessageData.CharacterModel.Location.WorldPosition.Y,
        CharacterLocationWPosZ = self.MessageData.CharacterModel.Location.WorldPosition.Z,
        CharacterLocationZone = self.MessageData.CharacterModel.Location.Zone,
        CharacterLocationSubZone = self.MessageData.CharacterModel.Location.SubZone,
        CharacterLocationMapId = self.MessageData.CharacterModel.Location.MapId,
        CharacterLocationLocationType = self.MessageData.CharacterModel.Location.LocationType,
        Message = self.MessageData.Message,
        Timestamp = self.MessageData.TimeStamp,
        MessageType = self.MessageData.MessageType,
        Frequency = self.MessageData.Frequency,
    };

end