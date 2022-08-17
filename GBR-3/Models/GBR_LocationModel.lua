GBR_LocationModel = GBR_Object:New();

function GBR_LocationModel:New(obj)

    self.Name = "";
    self.ZonePosition = GBR_Vector3:New();
    self.WorldPosition = GBR_Vector3:New();
    self.Zone = "";
    self.SubZone = "";
    self.MapId = "";
    self.LocationType = GBR_ELocationType.Undefined;

    return self:RegisterNew(obj);

end