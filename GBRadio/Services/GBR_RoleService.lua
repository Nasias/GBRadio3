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

    local roleString = {};

    for k,v in ipairs(roles) do
        if v then
            table.insert(roleString, GBR_RoleService.Roles[k].Icon);
        end
    end

    return table.concat(roleString, " ");

end

function GBR_RoleService:GetRoleChatIconsForRoles(roles)

    local roleString = {};

    for k,v in ipairs(roles) do
        if v then
            local role = GBR_RoleService.Roles[k];
            --table.insert(roleString, string.format("|H%s:IconIdentifier:%s|h%s|h",GBR_Constants.OPT_HOOK_HYPERLINKPREFIX, k, role.ChatIcon));
            table.insert(roleString, GBR_RoleService.Roles[k].ChatIcon);
        end
    end

    return table.concat(roleString, " ");

end

GBR_RoleService.SortedRoleKeys =
{
    GBR_ERoleType.FLP,
    GBR_ERoleType.POR,
    GBR_ERoleType.AHO,
    GBR_ERoleType.AFO,
    GBR_ERoleType.AMO,
    GBR_ERoleType.ELS,
    GBR_ERoleType.EOD,
    GBR_ERoleType.IO,
    GBR_ERoleType.JNOPGC,
    GBR_ERoleType.JNOPSC,
    GBR_ERoleType.JNOPBC,
};

GBR_RoleService.Roles =
{
    [GBR_ERoleType.FLP] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_FLP,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_FLP,
        Icon = GBR_Constants.ROLE_ICON_FLP,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_FLP,
        Order = 100,
    },
    [GBR_ERoleType.POR] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_POR,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_POR,
        Icon = GBR_Constants.ROLE_ICON_POR,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_POR,
        Order = 200,
    },
    [GBR_ERoleType.AHO] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_AHO,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_AHO,
        Icon = GBR_Constants.ROLE_ICON_AHO,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_AHO,
        Order = 300,
    },
    [GBR_ERoleType.AFO] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_AFO,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_AFO,
        Icon = GBR_Constants.ROLE_ICON_AFO,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_AFO,
        Order = 400,
    },
    [GBR_ERoleType.AMO] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_AMO,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_AMO,
        Icon = GBR_Constants.ROLE_ICON_AMO,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_AMO,
        Order = 500,
    },
    [GBR_ERoleType.ELS] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_ELS,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_ELS,
        Icon = GBR_Constants.ROLE_ICON_ELS,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_ELS,
        Order = 600,
    },
    [GBR_ERoleType.EOD] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_EOD,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_EOD,
        Icon = GBR_Constants.ROLE_ICON_EOD,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_EOD,
        Order = 700,
    },
    [GBR_ERoleType.IO] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_IO,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_IO,
        Icon = GBR_Constants.ROLE_ICON_IO,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_IO,
        Order = 800,
    },
    [GBR_ERoleType.JNOPGC] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_JNOPGC,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_JNOPGC,
        Icon = GBR_Constants.ROLE_ICON_JNOPGC,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_JNOPGC,
        Order = 900,
    }, 
    [GBR_ERoleType.JNOPSC] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_JNOPSC,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_JNOPSC,
        Icon = GBR_Constants.ROLE_ICON_JNOPSC,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_JNOPSC,
        Order = 1000,
    },
    [GBR_ERoleType.JNOPBC] = GBR_RoleModel:New
    {
        Name = GBR_Constants.ROLE_NAME_JNOPBC,
        Abbreviation = GBR_Constants.ROLE_ABBREVIATION_JNOPBC,
        Icon = GBR_Constants.ROLE_ICON_JNOPBC,
        ChatIcon = GBR_Constants.ROLE_ICON_CHAT_JNOPBC,
        Order = 1100
    },
}