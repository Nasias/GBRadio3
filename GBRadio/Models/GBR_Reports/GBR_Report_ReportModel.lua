GBR_Report_ReportModel = GBR_Object:New();

function GBR_Report_ReportModel:New(obj)

    self.IncidentDetails = GBR_Report_IncidentDetailsModel:New();
    self.Witnesses = {};
    self.Suspects = {};

    return self:RegisterNew(obj);

end
