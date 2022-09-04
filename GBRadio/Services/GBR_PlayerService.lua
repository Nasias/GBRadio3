GBR_PlayerService = GBR_Object:New();

function GBR_PlayerService:New(obj)

    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
    self._mrpService = GBR_Singletons:FetchService(GBR_Constants.SRV_MRP_SERVICE);

    return self:RegisterNew(obj);

end

function GBR_PlayerService:GetCurrentCharacterModel()

    return GBR_CharacterModel:New
    {
        CharacterName = UnitName(GBR_Constants.ID_PLAYER),
        CharacterColour = self:GetPlayerColour(),
        CharacterGender = self._configService:GetCharacterGender(),
        CharacterVoiceType = self._configService.GetCharacterVoiceType(),
        Location = self._locationService:GetCurrentCharacterLocation(),
    };

end

function GBR_PlayerService:GetCharacterNameForNameType(nameType)

    local t =
    {
        [GBR_ENameType.Character] = UnitName(GBR_Constants.ID_PLAYER),
        [GBR_ENameType.Mrp] = self._mrpService:GetPlayerName()
    };

    return t[nameType];

end

function GBR_PlayerService:GetPlayerColour()

    local trpColour = self._mrpService:GetPlayerColour();

    local _, unitClass = UnitClass(GBR_Constants.ID_PLAYER);
    local _, _, _, classColour = GetClassColor(unitClass);

    return trpColour or classColour;

end