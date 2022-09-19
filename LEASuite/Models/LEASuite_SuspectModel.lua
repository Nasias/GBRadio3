LEASuite_SuspectModel = LEASuite_Object:New();

function LEASuite_SuspectModel:New(obj)

    self.FullName = nil;
    self.OocName = nil;
    self.PersonalDescription = nil;
    self.Statement = nil;
    self.Offences = {};

    return self:RegisterNew(obj);

end

function LEASuite_SuspectModel:SetFullname(fullName)

    self.Fullname = fullName;

end

function LEASuite_SuspectModel:SetOocName(oocName)

    self.Fullname = fullName;

end

function LEASuite_SuspectModel:AddOffence(offenceId)

    table.insert(self.Offences, offenceId);

end

