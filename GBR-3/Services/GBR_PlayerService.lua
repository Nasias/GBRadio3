GBR_PlayerService = GBR_Object:New();

function GBR_PlayerService:New(obj)

    self._configService = GBR_ConfigService:New();
    self._locationService = GBR_LocationService:New();
    self._mrpService = GBR_MRPService:New();

    return self:RegisterNew(obj);

end

function GBR_PlayerService:GetCurrentCharacterModel()

    return GBR_CharacterModel:New
    {
        CharacterName = UnitName(GBR_Constants.ID_PLAYER),
        MSPName = self._mrpService:GetPlayerName(),
        CharacterCallsign = nil,
        CharacterColour = nil,
        CharacterGender = self._configService:GetCharacterGender(),
        Location = self._locationService:GetCurrentCharacterLocation(),
    };

end