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

function LEASuite_OffenceService:GetAllOffences()

    return LEASuite_Offences;
end

function LEASuite_OffenceService:GetOffenceCategoryName(offenceCategoryId)

    return self.OffenceCategories[offenceCategoryId];
end

function LEASuite_OffenceService:GetOffencesForCategory(offenceCategoryId)

    local offenceList = {};

    if not LEASuite_Offences[offenceCategoryId] then
        return offenceList;
    end

    for k,v in ipairs(LEASuite_Offences[offenceCategoryId].Offences) do
        table.insert(offenceList, v.Title);
    end

    return offenceList;
end

function LEASuite_OffenceService:GetIncidentTypes()

    return self.IncidentTypes;
end

function LEASuite_OffenceService:GetIncidentTypeForId(incidentTypeId)

    return self.IncidentTypes[incidentTypeId];
end