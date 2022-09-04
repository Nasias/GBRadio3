GBR_RoleModel = GBR_Object:New();

function GBR_RoleModel:New(obj)

    self.Name = nil;
    self.Abbreviation = nil;
    self.Icon = nil;

    return self:RegisterNew(obj);

end