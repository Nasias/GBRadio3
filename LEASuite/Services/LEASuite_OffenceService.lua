LEASuite_OffenceService = LEASuite_Object:New();

function LEASuite_OffenceService:New(obj)

    self.OffenceCategories = self:_buildOffenceCategories();
    self.IncidentTypes =
    {
        "Aggression",
        "Public Order",
        "Property",
        "Magic",
        "Capital",
        "Goods and Trade",
        "Organised Crime",
        "Other"
    };

    return self:RegisterNew(obj);
end

function LEASuite_OffenceService:_buildOffenceCategories()

    local offenceCategories = {};

    for k,v in ipairs(LEASuite_Offences) do
        offenceCategories[k] = v.Title;
    end

    return offenceCategories;
end

function LEASuite_OffenceService:GetOffenceCategories()

    return self.OffenceCategories;
end

function LEASuite_OffenceService:GetOffenceCategoryName(offenceCategoryId)

    return self.OffenceCategories[offenceCategoryId];
end

function LEASuite_OffenceService:GetOffencesForCategory(offenceCategoryId)

    if not LEASuite_Offences[offenceCategoryId] then
        return {};
    end

    return LEASuite_Offences[offenceCategoryId].Offences;
end

function LEASuite_OffenceService:GetIncidentTypes()

    return self.IncidentTypes;
end

function LEASuite_OffenceService:GetIncidentTypeForId(incidentTypeId)

    return self.IncidentTypes[incidentTypeId];
end