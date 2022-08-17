GBR_PlayerService = GBR_Object:New();

function GBR_PlayerService:New(obj)

    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
    self._mrpService = GBR_Singletons:FetchService(GBR_Constants.SRV_MRP_SERVICE);

    return self:RegisterNew(obj);

end

function GBR_PlayerService:GetCurrentCharacterModel()

    local preferredNamePreference = GBR_ConfigService:GetDefaultNamePreference();

    return GBR_CharacterModel:New
    {
        CharacterName = GBR_PlayerService:GetCharacterNameForNameType(preferredNamePreference),
        CharacterNameType = preferredNamePreference,
        CharacterColour = GBR_ARGB:New(),
        CharacterGender = self._configService:GetCharacterGender(),
        Location = self._locationService:GetCurrentCharacterLocation(),
    };

end

function GBR_PlayerService:GetCharacterNameForNameType(nameType)

    local t =
    {
        [GBR_ENameType.Character] = UnitName(GBR_Constants.ID_PLAYER),
        [GBR_ENameType.Mrp] = self._mrpService:GetPlayerName(),
        [GBR_ENameType.Callsign] = "CALLSIGN",
    };

    return t[nameType];

end