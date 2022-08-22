GBR_LocationService = GBR_Object:New();

function GBR_LocationService:New(obj)

    self._locationLib = LibStub(GBR_Constants.LIB_HBD_LOCATION);

    return self:RegisterNew(obj);

end

function GBR_LocationService:GetCurrentCharacterLocation()

    local zonePositionX, zonePositionY = self._locationLib:GetPlayerZonePosition();
    local worldPositionX, worldPositionY, worldInstanceId = self._locationLib:GetPlayerWorldPosition();
    local zoneMapId, zoneMapType = self._locationLib:GetPlayerZone();

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
        MapId = zoneMapId,
        WorldInstanceId = worldInstanceId,
        MapTypeId = zoneMapType,
        LocationType = GBR_ELocationType.Character
    };

end