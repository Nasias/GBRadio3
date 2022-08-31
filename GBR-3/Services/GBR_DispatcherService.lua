GBR_DispatcherService = GBR_Object:New();

function GBR_DispatcherService:New(obj)

    self._aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
    self._roleService = GBR_Singletons:FetchService(GBR_Constants.SRV_ROLE_SERVICE);
    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);
    self._notificationService = GBR_Singletons:FetchService(GBR_Constants.SRV_NOTIFICATION_SERVICE);

    self.Cache =
    {
        NotificationDispatchData = {
            Title = nil,
            Grade = nil,
            MainLocation = nil,
            CoordinateX = nil,
            CoordinateY = nil,
            SenderName = nil,
            SenderFrequency = nil,
            IncidentDetails = nil,
            UnitsRequired = {},
        },
    };

    return self:RegisterNew(obj);

end

function GBR_DispatcherService:_presetNotificationInputs()

    local currentCharacter = self._playerService:GetCurrentCharacterModel();
    local primaryFrequency = self._configService:GetPrimaryFrequency();

    self.Cache.NotificationDispatchData =
    {
        Title = "INCIDENT ALERT",
        Grade = 1,
        MainLocation = currentCharacter.Location.Zone,
        CoordinateX = string.format("%.2f", currentCharacter.Location.ZonePosition.X * 100),
        CoordinateY = string.format("%.2f", currentCharacter.Location.ZonePosition.Y * 100),
        SenderName = self._configService:GetCharacterDisplayNameForFrequency(primaryFrequency),
        SenderFrequency = primaryFrequency,
        UnitsRequired = {},
    };

end

function GBR_DispatcherService:_selectNavigationItem(container, event, group)
    container:ReleaseChildren();
    if group == 1 then
        self:_drawSendNotificationPage(container);
    elseif group == 2 then
        self:_drawNotificationHistoryPage(container);
    end
end

function GBR_DispatcherService:_drawSendNotificationPage(container)

    self:_presetNotificationInputs();
    local notificationDetailsGroup = self:_buildNotificationDetailsGroup();

    local txtTitle = self._aceGUI:Create("EditBox");
    txtTitle:SetLabel("Title");
    txtTitle:SetRelativeWidth(1);
    txtTitle:SetCallback("OnEnterPressed", function(info, event, value) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.Title = value 
    end);
    txtTitle:SetText(self.Cache.NotificationDispatchData.Title);
    notificationDetailsGroup:AddChild(txtTitle);

    local ddlGrade = self._aceGUI:Create("Dropdown");
    ddlGrade:SetLabel("Grade");
    ddlGrade:SetRelativeWidth(1);
    ddlGrade:SetList({
        [GBR_ENotificationGradeType.Grade1] = "Grade 1", 
        [GBR_ENotificationGradeType.Grade2] = "Grade 2", 
        [GBR_ENotificationGradeType.Grade3] = "Grade 3"
    });
    ddlGrade:SetCallback("OnValueChanged", function(key, checked)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.Grade = key:GetValue();
    end);
    ddlGrade:SetValue(self.Cache.NotificationDispatchData.Grade);
    notificationDetailsGroup:AddChild(ddlGrade);

    local txtMainLocation = self._aceGUI:Create("EditBox");
    txtMainLocation:SetLabel("Main location");
    txtMainLocation:SetRelativeWidth(0.5);
    txtMainLocation:SetCallback("OnEnterPressed", function(info, event, value) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.MainLocation = value;
    end);
    txtMainLocation:SetText(self.Cache.NotificationDispatchData.MainLocation);
    notificationDetailsGroup:AddChild(txtMainLocation);

    local txtLocationCoordX = self._aceGUI:Create("EditBox");
    txtLocationCoordX:SetLabel("Coordinate X");
    txtLocationCoordX:SetRelativeWidth(0.25);
    txtLocationCoordX:SetCallback("OnEnterPressed", function(info, event, value) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.CoordinateX = value;
    end);
    txtLocationCoordX:SetText(self.Cache.NotificationDispatchData.CoordinateX);
    notificationDetailsGroup:AddChild(txtLocationCoordX);

    local txtLocationCoordY = self._aceGUI:Create("EditBox");
    txtLocationCoordY:SetLabel("Coordinate Y");
    txtLocationCoordY:SetRelativeWidth(0.25);
    txtLocationCoordY:SetCallback("OnEnterPressed", function(info, event, value)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.CoordinateY = value;
    end);
    txtLocationCoordY:SetText(self.Cache.NotificationDispatchData.CoordinateY);
    notificationDetailsGroup:AddChild(txtLocationCoordY);

    local txtSenderName = self._aceGUI:Create("EditBox");
    txtSenderName:SetLabel("Sender name");
    txtSenderName:SetRelativeWidth(1);
    txtSenderName:SetCallback("OnEnterPressed", function(info, event, value) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.SenderName = value;
    end);
    txtSenderName:SetText(self.Cache.NotificationDispatchData.SenderName);
    notificationDetailsGroup:AddChild(txtSenderName);

    local channels = self._configService:GetRegisteredCommunicationFrequencies();
    local channelDropdownValues = {};
    for k,v in pairs(channels) do
        channelDropdownValues[k] = GBR_ConfigService.GetChannelGroupName(v.IsEnabled, v.ChannelName, k);
    end

    local ddlChannel = self._aceGUI:Create("Dropdown");
    ddlChannel:SetLabel("Channel");
    ddlChannel:SetRelativeWidth(1);
    ddlChannel:SetList(channelDropdownValues);
    ddlChannel:SetCallback("OnValueChanged", function(info, event, value)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.SenderFrequency = value;
    end);
    ddlChannel:SetValue(self.Cache.NotificationDispatchData.SenderFrequency);
    notificationDetailsGroup:AddChild(ddlChannel);

    local ddlUnitsRequired = self._aceGUI:Create("Dropdown");
    ddlUnitsRequired:SetLabel("Units required");
    ddlUnitsRequired:SetRelativeWidth(1);
    ddlUnitsRequired:SetList(self._roleService:GetRolesAsKeyValuePairs());
    ddlUnitsRequired:SetMultiselect(true);
    ddlUnitsRequired:SetCallback("OnValueChanged", function(info, event, value, checked)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.UnitsRequired[value] = checked;
    end);
    notificationDetailsGroup:AddChild(ddlUnitsRequired);

    local txtIncidentDetails = self._aceGUI:Create("MultiLineEditBox");
    txtIncidentDetails:SetLabel("Incident details");
    txtIncidentDetails:SetRelativeWidth(1);
    txtIncidentDetails:SetNumLines(5);
    txtIncidentDetails:SetCallback("OnEnterPressed", function(info, event, value) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.IncidentDetails = value;
    end);
    notificationDetailsGroup:AddChild(txtIncidentDetails);

    local cmdDispatchNotification = self._aceGUI:Create("Button");
    cmdDispatchNotification:SetText("DISPATCH");
    cmdDispatchNotification:SetRelativeWidth(1);
    cmdDispatchNotification:SetHeight(50);
    cmdDispatchNotification:SetCallback("OnClick", function()
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);

        local notificationModel = GBR_NotificationModel:New
        { 
            Title = dispatcherService.Cache.NotificationDispatchData.Title, 
            Grade = dispatcherService.Cache.NotificationDispatchData.Grade, 
            IncidentLocation = dispatcherService.Cache.NotificationDispatchData.MainLocation, 
            LocationCoordinateX = dispatcherService.Cache.NotificationDispatchData.CoordinateX,
            LocationCoordinateY = dispatcherService.Cache.NotificationDispatchData.CoordinateY,
            IncidentReporter = dispatcherService.Cache.NotificationDispatchData.SenderName, 
            IncidentFrequency = dispatcherService.Cache.NotificationDispatchData.SenderFrequency,
            IncidentDescription = dispatcherService.Cache.NotificationDispatchData.IncidentDetails,
            UnitsRequired = "",
        };

        for k,v in pairs(dispatcherService.Cache.NotificationDispatchData.UnitsRequired) do
            if v then
                local roleDetails = self._roleService:GetRoleForType(k);
                notificationModel.UnitsRequired = notificationModel.UnitsRequired .. " " .. roleDetails.Icon .. " " .. roleDetails.Abbreviation;
            end
        end

        local frequency = dispatcherService.Cache.NotificationDispatchData.SenderFrequency;
        local messageModel = GBR_MessageModel:New
        {
            MessageData =
            {
                NotificationModel = notificationModel,
                MessageType =  GBR_EMessageType.Notification
            }
        };

        messageService:SendMessageForFrequency(messageModel, frequency);
    end);    
    notificationDetailsGroup:AddChild(cmdDispatchNotification);

    container:AddChild(notificationDetailsGroup);

end

function GBR_DispatcherService:_drawNotificationHistoryPage(container)

    local notificationDetailsGroup = self._aceGUI:Create("InlineGroup");
    notificationDetailsGroup:SetTitle("Notification history");
    notificationDetailsGroup:SetLayout("Flow");
    notificationDetailsGroup:SetFullWidth(true);
    notificationDetailsGroup:SetFullHeight(true);
    container:AddChild(notificationDetailsGroup);

end

function GBR_DispatcherService:_buildMainFrame()

    local notificationConfigFrame = self._aceGUI:Create("Window");
    notificationConfigFrame:SetTitle("GBRadio Notification Dispatcher Panel");
    notificationConfigFrame:SetCallback("OnClose", function(widget) 
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);
    notificationConfigFrame:SetWidth(350);
    notificationConfigFrame:SetHeight(600);
    notificationConfigFrame:SetLayout("Fill");
    notificationConfigFrame:EnableResize(false);
    
    local notificationNavigation = self._aceGUI:Create("TabGroup");
    notificationNavigation:SetTabs({{value = 1, text = "Send notification"}});
    notificationNavigation:SetCallback("OnGroupSelected", function(container, event, group)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService:_selectNavigationItem(container, event, group);
    end);
    notificationNavigation:SetCallback("OnClose", function(widget) 
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);
    notificationNavigation:SelectTab(1);
    notificationNavigation:SetLayout("Fill");

    notificationConfigFrame:AddChild(notificationNavigation);
    notificationConfigFrame.NavigationPanel = notificationNavigation;

    return notificationConfigFrame;

end

function GBR_DispatcherService:_buildNotificationDetailsGroup()

    local notificationDetailsGroup = self._aceGUI:Create("InlineGroup");
    notificationDetailsGroup:SetTitle("Notification details");
    notificationDetailsGroup:SetLayout("Flow");
    notificationDetailsGroup:SetFullWidth(true);
    notificationDetailsGroup:SetFullHeight(true);
    notificationDetailsGroup:SetCallback("OnClose", function(widget) 
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);
    
    return notificationDetailsGroup;
end

function GBR_DispatcherService:DisplayDispatcher()

    local notificationDispatchFrame = self:_buildMainFrame();

end