GBR_CharacterModel = GBR_Object:New();

function GBR_CharacterModel:New(obj)

    self.CharacterName = nil;
    self.CharacterDisplayName = nil;
    self.CharacterNameType = nil; -- GBR_ENameType
    self.CharacterColour = GBR_ARGB:New();
    self.CharacterGender = nil;
    self.CharacterVoiceType = nil;
    self.Location = GBR_LocationModel:New();

    return self:RegisterNew(obj);

end
