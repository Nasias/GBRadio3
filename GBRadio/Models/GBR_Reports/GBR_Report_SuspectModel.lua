GBR_Report_SuspectModel = GBR_Object:New();

function GBR_Report_SuspectModel:New(obj)

    self.FullName = nil;
    self.OocName = nil;
    self.PersonalDescription = nil;
    self.Statement = nil;
    self.Offences = {};

    return self:RegisterNew(obj);

end

function GBR_Report_SuspectModel:SetFullname(fullName)

    self.Fullname = fullName;

end

function GBR_Report_SuspectModel:SetOocName(oocName)

    self.Fullname = fullName;

end

function GBR_Report_SuspectModel:AddOffence(offenceId)

    table.insert(self.Offences, offenceId);

end

