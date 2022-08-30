GBR_CharacterModel = GBR_Object:New();

function GBR_CharacterModel:New(obj)

    self.CharacterName = nil;
    self.CharacterDisplayName = nil;
    self.CharacterRoles = {};
    self.CharacterColour = nil;
    self.CharacterGender = nil;
    self.CharacterVoiceType = nil;
    self.Location = GBR_LocationModel:New();

    return self:RegisterNew(obj);

end
