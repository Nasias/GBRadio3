GBR_IAmListeningModel = GBR_Object:New();

function GBR_IAmListeningModel:New(obj)

    self.CharacterName = nil;
    self.LastSeenDateTime = nil;

    return self:RegisterNew(obj);

end
