LEASuite_ReportModel = LEASuite_Object:New();

function LEASuite_ReportModel:New(obj)

    self.IncidentDetails = LEASuite_IncidentDetailsModel:New();
    self.Witnesses = {};
    self.Suspects = {};

    return self:RegisterNew(obj);

end
