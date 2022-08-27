GBR_NotificationModel = GBR_Object:New();

function GBR_NotificationModel:New(obj)

    self.Title = nil;
    self.Grade = nil;
    self.IncidentLocation = nil;
    self.LocationCoordinateX = nil;
    self.LocationCoordinateY = nil;
    self.IncidentReporter = nil;
    self.IncidentFrequency = nil;
    self.IncidentDescription = nil;
    self.UnitsRequired = nil;

    return self:RegisterNew(obj);

end
