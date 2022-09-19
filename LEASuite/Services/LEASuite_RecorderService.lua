LEASuite_RecorderService = LEASuite_Object:New();

function LEASuite_RecorderService:New(obj)

    self._aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);
    self.ConfigRegistry = nil;
    self._playerService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_PLAYER_SERVICE);
    self.Widgets =
    {
        RecorderFrame = nil,
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

function LEASuite_RecorderService:CreateChatEventFrame()

    self.Widgets.ChatEventFrame = CreateFrame("Frame");
    self.Widgets.ChatEventFrame:Hide();
    self.Widgets.ChatEventFrame:RegisterEvent("CHAT_MSG_SAY");
    self.Widgets.ChatEventFrame:RegisterEvent("CHAT_MSG_EMOTE");
    self.Widgets.ChatEventFrame:RegisterEvent("CHAT_MSG_YELL");
    self.Widgets.ChatEventFrame:SetScript("OnEvent", function(self, event, message, sender)
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);

        if not recorderService:GetIsRecording() then
            return;
        end

        local name, realm = strsplit("-", sender);
        
        if recorderService:ActorIsActive(name) then
            recorderService:AddRecordedTextEntry(name, message);
        end

    end);
end
    
function LEASuite_RecorderService:ResetViewModel()
    LEASuite_SavedVars.Recorder = 
    {
        Actors = {},
        RecordingActors = {},
        RecordedText = "",
        IsRecording = false,
    };

    table.insert(LEASuite_SavedVars.Recorder.Actors, self._playerService:GetCharacterNameForNameType(LEASuite_ENameType.Character));
    table.insert(LEASuite_SavedVars.Recorder.RecordingActors, true);
end

function LEASuite_RecorderService:ResetUi()
    if not self.Widgets then
        return;
    end

    self.Widgets.ActorsDropdown:SetList(self:GetActors());    
    for k,v in ipairs(self:GetRecordingActors()) do
        self.Widgets.ActorsDropdown:SetItemValue(k, v);
    end

    self.Widgets.RecordedTextWidget:SetText("");
end

function LEASuite_RecorderService:ActorIsActive(actorName)

    for k,v in ipairs(self:GetActors()) do
        if v == actorName and self:ActorKeyIsActive(k) then
            return true;
        end
    end

    return false;

end

function LEASuite_RecorderService:ActorKeyIsActive(key)
    return LEASuite_SavedVars.Recorder.RecordingActors[key];
end

function LEASuite_RecorderService:SetRecordingActor(key, isRecording)

    LEASuite_SavedVars.Recorder.RecordingActors[key] = isRecording;
    self.Widgets.ActorsDropdown:SetItemValue(key, isRecording);

end

function LEASuite_RecorderService:AddRecordingActor(actorName)

    for k,v in pairs(LEASuite_SavedVars.Recorder.Actors) do
        if v == actorName then 
            return; 
        end;
    end

    table.insert(LEASuite_SavedVars.Recorder.Actors, actorName);
    table.insert(LEASuite_SavedVars.Recorder.RecordingActors, true);

    self.Widgets.ActorsDropdown:SetList(self:GetActors());
    
    for k,v in ipairs(self:GetRecordingActors()) do
        self.Widgets.ActorsDropdown:SetItemValue(k, v);
    end
end

function LEASuite_RecorderService:GetRecordingActors()
    return LEASuite_SavedVars.Recorder.RecordingActors;
end

function LEASuite_RecorderService:GetActors()
    return LEASuite_SavedVars.Recorder.Actors;
end

function LEASuite_RecorderService:SetIsRecording(isRecording)
    LEASuite_SavedVars.Recorder.IsRecording = isRecording;

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

function LEASuite_RecorderService:GetIsRecording()
    return LEASuite_SavedVars.Recorder.IsRecording;
end

function LEASuite_RecorderService:AddRecordedTextEntry(playerName, message)
    local timeH, timeM = GetGameTime();
    LEASuite_SavedVars.Recorder.RecordedText = LEASuite_SavedVars.Recorder.RecordedText .. string.format("[%02d:%02d] [%s]: %s\n", timeH, timeM, playerName, message);
    self.Widgets.RecordedTextWidget:SetText(LEASuite_SavedVars.Recorder.RecordedText);
end

function LEASuite_RecorderService:GetRecordedText()
    return LEASuite_SavedVars.Recorder.RecordedText;
end

function LEASuite_RecorderService:ShowRecorderWindow(callbackFunc)
    self:_buildRecorderFrame(callbackFunc);
end

function LEASuite_RecorderService:_buildRecorderFrame(callbackFunc)

    local recorderFrame = self._aceGUI:Create("Window");
    recorderFrame.frame:Raise();

    recorderFrame:SetCallback("OnClose", function(widget)
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);
        local aceGUI = LibStub(LEASuite_Constants.LIB_ACE_GUI);

        recorderService:SetIsRecording(false);
        aceGUI:Release(widget);
    end);

    recorderFrame:SetLayout("Flow");
    recorderFrame:SetHeight(520);
    recorderFrame:SetWidth(600);
    recorderFrame:EnableResize(false);
    recorderFrame:SetTitle("Statement Recorder");
    self.Widgets.RecorderFrame = recorderFrame;

    local recorderOptionsGroup = self._aceGUI:Create("InlineGroup");
    recorderOptionsGroup:SetTitle("Recorder options");
    recorderOptionsGroup:SetLayout("Flow");
    recorderOptionsGroup:SetRelativeWidth(1);
    recorderFrame:AddChild(recorderOptionsGroup);

    local recorderFrameActors = self._aceGUI:Create("Dropdown");
    recorderFrameActors:SetLabel("Record actors")
    recorderFrameActors:SetMultiselect(true);
    recorderFrameActors:SetRelativeWidth(0.7);
    recorderFrameActors:SetList(self:GetActors());
    recorderFrameActors:SetCallback("OnValueChanged", function(el, callback, key, value)
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);
        recorderService:SetRecordingActor(key, value);
    end);
    recorderOptionsGroup:AddChild(recorderFrameActors);
    self.Widgets.ActorsDropdown = recorderFrameActors;
    for k,v in ipairs(self:GetRecordingActors()) do
        recorderFrameActors:SetItemValue(k, v);
    end

    local recorderFrameActorsAddTargetButton = self._aceGUI:Create("Button");
    recorderFrameActorsAddTargetButton:SetText("Add target to actors");
    recorderFrameActorsAddTargetButton:SetRelativeWidth(0.3);
    recorderFrameActorsAddTargetButton:SetCallback("OnClick", function()
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);
        local targetName = UnitName(LEASuite_Constants.ID_TARGET);

        if targetName and UnitIsPlayer(LEASuite_Constants.ID_TARGET) then
            recorderService:AddRecordingActor(targetName);
        end
    end);
    recorderOptionsGroup:AddChild(recorderFrameActorsAddTargetButton);

    local recorderStartRecordingButton = self._aceGUI:Create("Button");
    recorderStartRecordingButton:SetText("Start");
    recorderStartRecordingButton:SetRelativeWidth(0.333);
    recorderStartRecordingButton:SetCallback("OnClick", function()
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);
        recorderService:SetIsRecording(true);
    end);
    recorderOptionsGroup:AddChild(recorderStartRecordingButton);
    self.Widgets.StartRecordingButton = recorderStartRecordingButton;

    local recorderStopRecordingButton = self._aceGUI:Create("Button");
    recorderStopRecordingButton:SetText("Stop");
    recorderStopRecordingButton:SetRelativeWidth(0.333);
    recorderStopRecordingButton:SetDisabled(true);
    recorderStopRecordingButton:SetCallback("OnClick", function()
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);
        recorderService:SetIsRecording(false);
    end);
    recorderOptionsGroup:AddChild(recorderStopRecordingButton);
    self.Widgets.StopRecordingButton = recorderStopRecordingButton;

    local recorderResetButton = self._aceGUI:Create("Button");
    recorderResetButton:SetText("Reset");
    recorderResetButton:SetRelativeWidth(0.333);
    recorderResetButton:SetCallback("OnClick", function()
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);
        recorderService:ResetViewModel();
        recorderService:ResetUi();
    end);
    recorderOptionsGroup:AddChild(recorderResetButton);
    self.Widgets.ResetRecordingButton = recorderResetButton;

    local recorderOutputGroup = self._aceGUI:Create("InlineGroup");
    recorderOutputGroup:SetTitle("Recording");
    recorderOutputGroup:SetLayout("Flow");
    recorderOutputGroup:SetRelativeWidth(1);
    recorderFrame:AddChild(recorderOutputGroup);

    local recorderStatusText = self._aceGUI:Create("Label");
    recorderStatusText:SetRelativeWidth(0.3);
    recorderOutputGroup:AddChild(recorderStatusText);
    self.Widgets.RecorderStatusText = recorderStatusText;    

    local recorderRecordedText = self._aceGUI:Create("MultiLineEditBox");
    recorderRecordedText:SetLabel("Statement");
    recorderRecordedText:SetNumLines(15);
    recorderRecordedText:SetRelativeWidth(1);
    recorderRecordedText:DisableButton(true);
    recorderRecordedText:SetText(self:GetRecordedText());
    self:SetIsRecording(false);
    recorderOutputGroup:AddChild(recorderRecordedText);
    self.Widgets.RecordedTextWidget = recorderRecordedText;

    local recorderReminderText = self._aceGUI:Create("Label");
    recorderReminderText:SetText("NOTE: Don't forget to take a copy of your recorded statement!\nUse Ctrl + A (select all) and Ctrl + C (copy) to take a copy. Use Ctrl + P (paste) to paste it in to your destination.\n\n");
    recorderReminderText:SetColor(0, 1, 1);
    recorderReminderText:SetRelativeWidth(1);
    recorderOutputGroup:AddChild(recorderReminderText);

    local recorderCloseButton = self._aceGUI:Create("Button");
    recorderCloseButton:SetText("Cancel");
    recorderCloseButton:SetRelativeWidth(0.5);
    recorderCloseButton:SetCallback("OnClick", function()
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);

        recorderService.Widgets.RecorderFrame:Hide();
    end);
    recorderFrame:AddChild(recorderCloseButton);

    local recorderCompleteButton = self._aceGUI:Create("Button");
    recorderCompleteButton:SetText("Complete");
    recorderCompleteButton:SetRelativeWidth(0.5);
    recorderCompleteButton:SetCallback("OnClick", function()
        local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);

        callbackFunc(LEASuite_SavedVars.Recorder.RecordedText);
        recorderService.Widgets.RecorderFrame:Hide();
    end);
    recorderFrame:AddChild(recorderCompleteButton);

end