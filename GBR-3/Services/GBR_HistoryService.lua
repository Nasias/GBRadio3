GBR_HistoryService = GBR_Object:New();

function GBR_HistoryService:New(obj)

    if GBRSavedVar_MessageHistory == nul then
        GBRSavedVar_MessageHistory = {};
    end

    return self:RegisterNew(obj);

end

function GBR_HistoryService:RecordMessage(message)

    table.insert(GBRSavedVar_MessageHistory, message);

end