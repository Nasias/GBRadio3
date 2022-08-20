GBR_SerializableMessageModel = GBR_Object:New();

function GBR_SerializableMessageModel:New(obj)
  
        self.CharacterName = nil;
        self.CharacterDisplayName = nil;
        self.CharacterNameType = nil;
        self.CharacterColourHex = nil;
        self.CharacterGender = nil;
        self.CharacterLocationName = nil;
        self.CharacterLocationZPosX = nil;
        self.CharacterLocationZPosY = nil;
        self.CharacterLocationZPosZ = nil;
        self.CharacterLocationWPosX = nil;
        self.CharacterLocationWPosY = nil;
        self.CharacterLocationWPosZ = nil;
        self.CharacterLocationZone = nil;
        self.CharacterLocationSubZone = nil;
        self.CharacterLocationMapId = nil;
        self.CharacterLocationLocationType = nil;
        self.Message = nil;
        self.Timestamp = nil;
        self.MessageType = nil;
        self.Frequency = nil;
    
    return self:RegisterNew(obj);

end

function GBR_SerializableMessageModel:ToMessageModel()

    return GBR_MessageModel:New
    {
        MessageData = 
        {
            CharacterModel = GBR_CharacterModel:New
            {            
                CharacterName = self.CharacterName,
                CharacterDisplayName = self.CharacterDisplayName,
                CharacterNameType = self.CharacterNameType,
                CharacterColour = GBR_ARGB:NewFromHex(self.CharacterColourHex),
                CharacterGender = self.CharacterGender,
                Location = GBR_LocationModel:New
                {
                    Name = "",
                    ZonePosition = GBR_Vector3:New
                    {
                        X = self.CharacterLocationZPosX,
                        Y = self.CharacterLocationZPosY,
                        Z = self.CharacterLocationZPosZ,
                    },
                    WorldPosition = GBR_Vector3:New
                    {
                        X = self.CharacterLocationWPosX,
                        Y = self.CharacterLocationWPosY,
                        Z = self.CharacterLocationWPosZ,
                    },
                    Zone = self.CharacterLocationZone,
                    SubZone = self.CharacterLocationSubZone,
                    MapId = self.CharacterLocationMapId,
                    LocationType = self.CharacterLocationLocationType,
                },
            },
            Message = self.Message,
            Timestamp = self.Timestamp,
            MessageType = self.MessageType,
            Frequency = self.Frequency,
        }
    };
end
