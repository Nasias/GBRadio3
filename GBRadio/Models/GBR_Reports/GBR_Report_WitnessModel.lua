GBR_Report_WitnessModel = GBR_Object:New();

function GBR_Report_WitnessModel:New(obj)

    self.FullName = nil;
    self.OocName = nil;
    self.PersonalDescription = nil;
    self.Statement = nil;

    return self:RegisterNew(obj);

end
