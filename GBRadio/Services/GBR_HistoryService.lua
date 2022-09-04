GBR_HistoryService = GBR_Object:New();

function GBR_HistoryService:New(obj)

    self._aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);

    if GBRSavedVar_MessageHistory == nil then
        GBRSavedVar_MessageHistory = {};
    end

    return self:RegisterNew(obj);

end

function GBR_HistoryService:RecordMessage(frequency, messageType, message)

    if GBRSavedVar_MessageHistory[frequency] == nil then GBRSavedVar_MessageHistory[frequency] = {} end;
    
    if GBRSavedVar_MessageHistory[frequency][messageType] == nil then GBRSavedVar_MessageHistory[frequency][messageType] = {} end;

    table.insert(GBRSavedVar_MessageHistory[frequency][messageType], message);

end

function GBR_HistoryService:_buildHistoryViewWindow(parent)

    local historyFrame = self._aceGUI:Create("Window");

    notificationConfigFrame:SetTitle("History for <FREQUENCY>");
    notificationConfigFrame:SetCallback("OnClose", function(widget) 

        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
        local configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);

        local x, y = widget.frame:GetCenter();
        configService:SaveMicroMenuPosition(x, y);

        aceGUI:Release(widget);
        self._window = nil;
        microMenu.isShown = false;

    end);
    notificationConfigFrame:SetWidth(250);
    notificationConfigFrame:SetHeight(115);
    notificationConfigFrame:SetLayout("Flow");
    notificationConfigFrame:EnableResize(false);

end