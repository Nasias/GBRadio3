GBR_LocationService = GBR_Object:New();

function GBR_LocationService:New(obj)

    self._locationLib = LibStub(GBR_Constants.LIB_HBD_LOCATION);

    return self:RegisterNew(obj);

end

function GBR_LocationService:GetCurrentCharacterLocation()

    local uiMapID = C_Map.GetBestMapForUnit("player");
    local position = C_Map.GetPlayerMapPosition(uiMapID, GBR_Constants.ID_PLAYER);
    local zone = GetZoneText();
    local subZone = GetSubZoneText();
    local map = C_Map.GetMapInfo(uiMapID).mapID;
    local positionVector = GBR_Vector3:New
    {
        X = position.x,
        Y = position.y,
        Z = 0.0
    };

    return GBR_LocationModel:New
    {
        Position = positionVector,
        Zone = zone,
        SubZone = subZone,
        Map = map,
        LocationType = GBR_ELocationType.Character
    };

end