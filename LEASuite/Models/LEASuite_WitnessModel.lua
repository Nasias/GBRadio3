LEASuite_WitnessModel = LEASuite_Object:New();

function LEASuite_WitnessModel:New(obj)

    self.FullName = nil;
    self.OocName = nil;
    self.PersonalDescription = nil;
    self.Statement = nil;

    return self:RegisterNew(obj);

end
