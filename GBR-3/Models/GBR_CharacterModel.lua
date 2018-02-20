GBR_CharacterModel = GBR_Object:New();

function GBR_CharacterModel:New(obj)

    self.CharacterName = "";
    self.MSPName = "";
    self.CharacterCallsign = "";
    self.CharacterColour = GBR_ARGB:New();
    self.CharacterGender = 0;
    self.Location = GBR_LocationModel:New();

    return self:RegisterNew(obj);

end
