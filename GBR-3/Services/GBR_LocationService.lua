GBR_LocationService = GBR_Object:New();

function GBR_LocationService:New(obj)

    self._locationLib = LibStub(GBR_Constants.LIB_HBD_LOCATION);

    return self:RegisterNew(obj);

end

function GBR_LocationService:GetCurrentCharacterLocation()

    local zonePositionX, zonePositionY, zoneMapId, zoneMapType = self._locationLib:GetPlayerZonePosition();
    local worldPositionX, worldPositionY, worldInstanceId = self._locationLib:GetPlayerWorldPosition();

    local zone = GetZoneText();
    local subZone = GetSubZoneText();

    local zonePositionVector = GBR_Vector3:New
    {
        X = zonePositionX,
        Y = zonePositionY,
        Z = 0.0
    };

    local worldPositionVector = GBR_Vector3:New
    {
        X = worldPositionX,
        Y = worldPositionY,
        Z = 0.0
    };

    return GBR_LocationModel:New
    {
        ZonePosition = zonePositionVector,
        WorldPosition = worldPositionVector,
        Zone = zone,
        SubZone = subZone,
        MapId = mapId,
        LocationType = GBR_ELocationType.Character
    };

end