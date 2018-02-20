GBR_SpeechMessageModel = GBR_Object:New();

function GBR_SpeechMessageModel:New(obj)

    self.MessageData = 
    {
        CharacterModel = GBR_CharacterModel:New(),
        Message = ""
    };

    self.MessageType = GBR_EMessageType.Speech;
    
    return self:RegisterNew(obj);

end
