GBR_TransmitterService = GBR_Object:New();

function GBR_TransmitterService:New(obj)

    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);

    return self:RegisterNew(obj);

end

function GBR_TransmitterService:GetClosestTransmitter()

    local playerLocation = self._locationService:GetCurrentCharacterLocation();

    --[[
        
        ZonePosition = zonePositionVector,
        WorldPosition = worldPositionVector,
        Zone = zone,
        SubZone = subZone,
        MapId = zoneMapId,
        WorldInstanceId = worldInstanceId,
        MapTypeId = zoneMapType,
        LocationType = GBR_ELocationType.Character
    ]]

    

end