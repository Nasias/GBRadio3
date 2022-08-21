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