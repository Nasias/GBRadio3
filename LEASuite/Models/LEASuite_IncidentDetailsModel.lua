GBR_Report_IncidentDetailsModel = LEASuite_Object:New();

function GBR_Report_IncidentDetailsModel:New(obj)

    self.Title = nil;
    self.IncidentType = nil;
    self.Location = nil;
    self.ReportedOnDateTime = nil;
    self.OccuredOnDateTime = nil;
    self.Description = nil;

    return self:RegisterNew(obj);

end
