GBR_RoleService = GBR_Object:New();

function GBR_RoleService:New(obj)

    return self:RegisterNew(obj);

end

function GBR_RoleService:GetRoleForType(roleType)

    local selectedRole = GBR_RoleService.Roles[roleType];
    return selectedRole;

end

function GBR_RoleService:GetRolesAsKeyValuePairs()

    local roles = {};

    for k,v in ipairs(GBR_RoleService.Roles) do
        roles[k] = v.Icon .. " " .. v.Name;
    end

    return roles;

end

function GBR_RoleService:GetRoleIconsForRoles(roles)

    local roleString = "";

    for k,v in ipairs(roles) do
        if v then
            roleString = roleString .. GBR_RoleService.Roles[k].Icon;
        end
    end

    return roleString;

end

GBR_RoleService.Roles =
{
    [GBR_ERoleType.FLP] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_FLP,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_FLP,
        Icon = GBR_Constants.ROLE_ICON_FLP,
    },
    [GBR_ERoleType.POR] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_POR,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_POR,
        Icon = GBR_Constants.ROLE_ICON_POR,
    },
    [GBR_ERoleType.AHO] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_AHO,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_AHO,
        Icon = GBR_Constants.ROLE_ICON_AHO,
    },
    [GBR_ERoleType.AFO] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_AFO,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_AFO,
        Icon = GBR_Constants.ROLE_ICON_AFO,
    },
    [GBR_ERoleType.AMO] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_AMO,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_AMO,
        Icon = GBR_Constants.ROLE_ICON_AMO,
    },
    [GBR_ERoleType.ELS] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_ELS,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_ELS,
        Icon = GBR_Constants.ROLE_ICON_ELS,
    },
    [GBR_ERoleType.JNOPGC] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_JNOPGC,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_JNOPGC,
        Icon = GBR_Constants.ROLE_ICON_JNOPGC,
    }, 
    [GBR_ERoleType.JNOPSC] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_JNOPSC,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_JNOPSC,
        Icon = GBR_Constants.ROLE_ICON_JNOPSC,
    },
    [GBR_ERoleType.JNOPBC] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_JNOPBC,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_JNOPBC,
        Icon = GBR_Constants.ROLE_ICON_JNOPBC,
    },
}