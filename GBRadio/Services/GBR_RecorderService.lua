GBR_RecorderService = GBR_Object:New();

function GBR_RecorderService:New(obj)

    self._aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
    self.ConfigRegistry = nil;
    self._playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);
    self.Widgets =
    {
        RecordedTextWidget = nil,
        StartRecordingButton = nil,
        StopRecordingButton = nil,
        ActorsDropdown = nil,
        RecorderStatusText = nil,
        ChatEventFrame = nil,
    };

    --if not GBRSavedVar_Reports then
        self:ResetViewModel();
    --end

    self:CreateChatEventFrame();

    return self:RegisterNew(obj);

end

function GBR_RecorderService:CreateChatEventFrame()

    self.Widgets.ChatEventFrame = CreateFrame("Frame");
    self.Widgets.ChatEventFrame:Hide();
    self.Widgets.ChatEventFrame:RegisterEvent("CHAT_MSG_SAY");
    self.Widgets.ChatEventFrame:RegisterEvent("CHAT_MSG_EMOTE");
    self.Widgets.ChatEventFrame:RegisterEvent("CHAT_MSG_YELL");
    self.Widgets.ChatEventFrame:SetScript("OnEvent", function(self, event, message, sender)
        local recorderService = GBR_Singletons:FetchService(GBR_Constants.SRV_RECORDER_SERVICE);

        if not recorderService:GetIsRecording() then
            return;
        end

        local name, realm = strsplit("-", sender);
        
        if recorderService:ActorIsActive(name) then
            recorderService:AddRecordedTextEntry(name, message);
        end

    end);
end
    
function GBR_RecorderService:ResetViewModel()
    GBRSavedVar_Reports = 
    {
        Actors = {
            [1] = self._playerService:GetCharacterNameForNameType(GBR_ENameType.Character)
        },
        RecordingActors = {
            [1] = true,
        },
        RecordedText = "",
        IsRecording = false,
    };
end

function GBR_RecorderService:ActorIsActive(actorName)

    for k,v in ipairs(self:GetActors()) do
        if v == actorName and self:ActorKeyIsActive(k) then
            return true;
        end
    end

    return false;

end

function GBR_RecorderService:ActorKeyIsActive(key)
    return GBRSavedVar_Reports.RecordingActors[key];
end

function GBR_RecorderService:SetRecordingActor(key, isRecording)

    GBRSavedVar_Reports.RecordingActors[key] = isRecording;
    self.Widgets.ActorsDropdown:SetItemValue(key, isRecording);

end

function GBR_RecorderService:AddRecordingActor(actorName)
    table.insert(GBRSavedVar_Reports.Actors, actorName);
    table.insert(GBRSavedVar_Reports.RecordingActors, false);

    self.Widgets.ActorsDropdown:SetList(self:GetActors());
    
    for k,v in ipairs(self:GetRecordingActors()) do
        self.Widgets.ActorsDropdown:SetItemValue(k, v);
    end
end

function GBR_RecorderService:GetRecordingActors()
    return GBRSavedVar_Reports.RecordingActors;
end

function GBR_RecorderService:GetActors()
    return GBRSavedVar_Reports.Actors;
end

function GBR_RecorderService:SetIsRecording(isRecording)
    GBRSavedVar_Reports.IsRecording = isRecording;

    if isRecording then
        self.Widgets.StartRecordingButton:SetDisabled(true);
        self.Widgets.StopRecordingButton:SetDisabled(false);
        self.Widgets.RecorderStatusText:SetText("  [ Statement recorder is recording ]");
        self.Widgets.RecorderStatusText:SetColor(0, 1, 0);
    else
        self.Widgets.StartRecordingButton:SetDisabled(false);
        self.Widgets.StopRecordingButton:SetDisabled(true);
        self.Widgets.RecorderStatusText:SetText("  [ Statement recorder is stopped ]");
        self.Widgets.RecorderStatusText:SetColor(1, 0, 0);
    end
end

function GBR_RecorderService:GetIsRecording()
    return GBRSavedVar_Reports.IsRecording;
end

function GBR_RecorderService:AddRecordedTextEntry(playerName, message)
    local timeH, timeM = GetGameTime();
    GBRSavedVar_Reports.RecordedText = GBRSavedVar_Reports.RecordedText .. string.format("[%02d:%02d] [%s]: %s\n", timeH, timeM, playerName, message);
    self.Widgets.RecordedTextWidget:SetText(GBRSavedVar_Reports.RecordedText);
end

function GBR_RecorderService:GetRecordedText()
    return GBRSavedVar_Reports.RecordedText;
end

function GBR_RecorderService:_buildRecorderFrame()

    local recorderFrame = self._aceGUI:Create("Window");

    recorderFrame:SetCallback("OnClose", function(widget)
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    recorderFrame:SetLayout("Flow");
    recorderFrame:SetHeight(450);
    recorderFrame:SetWidth(600);
    recorderFrame:EnableResize(false);
    recorderFrame:SetTitle("Statement Recorder");

    local recorderFrameActors = self._aceGUI:Create("Dropdown");
    recorderFrameActors:SetLabel("Record actors")
    recorderFrameActors:SetList(self.RecorderActors);
    recorderFrameActors:SetMultiselect(true);
    recorderFrameActors:SetRelativeWidth(0.7);
    recorderFrameActors:SetList(self:GetActors());
    recorderFrameActors:SetCallback("OnValueChanged", function(el, callback, key, value)
        local recorderService = GBR_Singletons:FetchService(GBR_Constants.SRV_RECORDER_SERVICE);
        recorderService:SetRecordingActor(key, value);
    end);
    recorderFrame:AddChild(recorderFrameActors);
    self.Widgets.ActorsDropdown = recorderFrameActors;

    local recorderFrameActorsAddTargetButton = self._aceGUI:Create("Button");
    recorderFrameActorsAddTargetButton:SetText("Add target to actors");
    recorderFrameActorsAddTargetButton:SetRelativeWidth(0.3);
    recorderFrameActorsAddTargetButton:SetCallback("OnClick", function()
        local recorderService = GBR_Singletons:FetchService(GBR_Constants.SRV_RECORDER_SERVICE);
        local targetName = UnitName("target");

        if targetName then
            recorderService:AddRecordingActor(targetName);
        end
    end);
    recorderFrame:AddChild(recorderFrameActorsAddTargetButton);

    local recorderStartRecordingButton = self._aceGUI:Create("Button");
    recorderStartRecordingButton:SetText("Start recording");
    recorderStartRecordingButton:SetRelativeWidth(0.3);
    recorderStartRecordingButton:SetCallback("OnClick", function()
        local recorderService = GBR_Singletons:FetchService(GBR_Constants.SRV_RECORDER_SERVICE);
        recorderService:SetIsRecording(true);
    end);
    recorderFrame:AddChild(recorderStartRecordingButton);
    self.Widgets.StartRecordingButton = recorderStartRecordingButton;

    local recorderStopRecordingButton = self._aceGUI:Create("Button");
    recorderStopRecordingButton:SetText("Stop recording");
    recorderStopRecordingButton:SetRelativeWidth(0.3);
    recorderStopRecordingButton:SetDisabled(true);
    recorderStopRecordingButton:SetCallback("OnClick", function()
        local recorderService = GBR_Singletons:FetchService(GBR_Constants.SRV_RECORDER_SERVICE);
        recorderService:SetIsRecording(false);
    end);
    recorderFrame:AddChild(recorderStopRecordingButton);
    self.Widgets.StopRecordingButton = recorderStopRecordingButton;

    local recorderStatusText = self._aceGUI:Create("Label");
    recorderStatusText:SetRelativeWidth(0.3);
    recorderFrame:AddChild(recorderStatusText);
    self.Widgets.RecorderStatusText = recorderStatusText;

    local recorderRecordedText = self._aceGUI:Create("MultiLineEditBox");
    recorderRecordedText:SetLabel("Recorded statement");
    recorderRecordedText:SetNumLines(15);
    recorderRecordedText:SetRelativeWidth(1);
    recorderRecordedText:SetText(self:GetRecordedText());
    self:SetIsRecording(false);
    recorderFrame:AddChild(recorderRecordedText);
    self.Widgets.RecordedTextWidget = recorderRecordedText;

    local recorderReminderText = self._aceGUI:Create("Label");
    recorderReminderText:SetText("NOTE: Don't forget to take a copy of your recorded statement!\nUse Ctrl + A (select all) and Ctrl + C (copy) to take a copy. Use Ctrl + P (paste) to paste it in to your destination.");
    recorderReminderText:SetColor(0, 1, 1);
    recorderReminderText:SetRelativeWidth(1);
    recorderFrame:AddChild(recorderReminderText);

    local recorderClose = self._aceGUI:Create("Button");
    recorderClose:SetText("Close recorder");
    recorderClose:SetRelativeWidth(0.3);
    recorderFrame:AddChild(recorderClose);

end