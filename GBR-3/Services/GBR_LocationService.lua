GBR_LocationService = GBR_Object:New();

function GBR_LocationService:New(obj)

    self._locationLib = LibStub(GBR_Constants.LIB_HBD_LOCATION);

    return self:RegisterNew(obj);

end

function GBR_LocationService:GetCurrentCharacterLocation()

    -- HereBeDragons pollutes the global namespace with these functions -_-
    SetMapToCurrentZone();
    local x, y = GetPlayerMapPosition(GBR_Constants.ID_PLAYER);
    local zone = GetZoneText();
    local subZone = GetSubZoneText();
    local map = GetMapInfo();
    local positionVector = GBR_Vector3:New
    {
        X = x,
        Y = y,
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