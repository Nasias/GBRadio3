GBR_LocationModel = GBR_Object:New();

function GBR_LocationModel:New(obj)

    self.Name = "";
    self.Position = GBR_Vector3:New();
    self.Zone = "";
    self.SubZone = "";
    self.Map = "";
    self.LocationType = GBR_ELocationType.Undefined;

    return self:RegisterNew(obj);

end