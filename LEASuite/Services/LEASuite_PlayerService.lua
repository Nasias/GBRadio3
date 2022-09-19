LEASuite_PlayerService = LEASuite_Object:New();

function LEASuite_PlayerService:New(obj)

    self._mrpService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_MRP_SERVICE);

    return self:RegisterNew(obj);

end

function LEASuite_PlayerService:GetCharacterNameForNameType(nameType)

    local t =
    {
        [LEASuite_ENameType.Character] = UnitName(LEASuite_Constants.ID_PLAYER),
        [LEASuite_ENameType.Mrp] = self._mrpService:GetPlayerName()
    };

    return t[nameType];

end

function LEASuite_PlayerService:GetPlayerColour()

    local trpColour = self._mrpService:GetPlayerColour();

    local _, unitClass = UnitClass(LEASuite_Constants.ID_PLAYER);
    local _, _, _, classColour = GetClassColor(unitClass);

    return trpColour or classColour;

end