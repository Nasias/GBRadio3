GBR_DispatcherService = GBR_Object:New();

function GBR_DispatcherService:New(obj)

    self._aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
    self._roleService = GBR_Singletons:FetchService(GBR_Constants.SRV_ROLE_SERVICE);
    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);
    self._notificationService = GBR_Singletons:FetchService(GBR_Constants.SRV_NOTIFICATION_SERVICE);

    self._window = nil;
    self._isShown = false;

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
        MainLocation = currentCharacter.Location.SubZone and currentCharacter.Location.SubZone:len() > 0 and currentCharacter.Location.SubZone or currentCharacter.Location.Zone,
        CoordinateX = currentCharacter.Location.ZonePosition.X and string.format("%.2f", currentCharacter.Location.ZonePosition.X * 100) or "",
        CoordinateY = currentCharacter.Location.ZonePosition.Y and string.format("%.2f", currentCharacter.Location.ZonePosition.Y * 100) or "",
        SenderName = self._configService:GetCharacterDisplayNameForFrequency(primaryFrequency),
        SenderFrequency = primaryFrequency,
        UnitsRequired = {},
    };

end

function GBR_DispatcherService:_buildSendNotification(container)

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
    txtTitle:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Title",
            "Determines the title of the notification you will send",
            "Example: INCIDENT ALERT, WANTED PERSON"
        );

    end);
    txtTitle:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    notificationDetailsGroup:AddChild(txtTitle);

    ------------------------------------------------------

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
    ddlGrade:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Grade",
            "Determines the severity of the notification",
            "Grade 1 - Emergency\nGrade 2 - Urgent\nGrade 3 - Routine"
        );

    end);
    ddlGrade:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    notificationDetailsGroup:AddChild(ddlGrade);

    ------------------------------------------------------

    local txtLocation = self._aceGUI:Create("EditBox");
    txtLocation:SetLabel("Location");
    txtLocation:SetRelativeWidth(0.5);
    txtLocation:SetCallback("OnEnterPressed", function(info, event, value) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.MainLocation = value;
    end);
    txtLocation:SetText(self.Cache.NotificationDispatchData.MainLocation);
    txtLocation:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Location",
            "Determines the local area that this notification involves",
            "Example: Mage District, Old Town, Raven Hill"
        );

    end);
    txtLocation:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    container.Location = txtLocation;
    notificationDetailsGroup:AddChild(txtLocation);

    ------------------------------------------------------

    local txtLocationCoordX = self._aceGUI:Create("EditBox");
    txtLocationCoordX:SetLabel("Coordinate X");
    txtLocationCoordX:SetRelativeWidth(0.25);
    txtLocationCoordX:SetCallback("OnEnterPressed", function(info, event, value) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.CoordinateX = value;
    end);
    txtLocationCoordX:SetText(self.Cache.NotificationDispatchData.CoordinateX);
    txtLocationCoordX:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Coordinate X",
            "Set the local X map coordinate for where this notification is concerned",
            "Example: 56.10"
        );

    end);
    txtLocationCoordX:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    container.LocationCoordX = txtLocationCoordX;
    notificationDetailsGroup:AddChild(txtLocationCoordX);

    ------------------------------------------------------

    local txtLocationCoordY = self._aceGUI:Create("EditBox");
    txtLocationCoordY:SetLabel("Coordinate Y");
    txtLocationCoordY:SetRelativeWidth(0.25);
    txtLocationCoordY:SetCallback("OnEnterPressed", function(info, event, value)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.CoordinateY = value;
    end);
    txtLocationCoordY:SetText(self.Cache.NotificationDispatchData.CoordinateY);
    txtLocationCoordY:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Coordinate Y",
            "Set the local Y map coordinate for where this notification is concerned",
            "Example: 56.10"
        );

    end);
    txtLocationCoordY:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    container.LocationCoordY = txtLocationCoordY;
    notificationDetailsGroup:AddChild(txtLocationCoordY);

    ------------------------------------------------------

    local cmdUseCurrentLocation = self._aceGUI:Create("Button");
    cmdUseCurrentLocation:SetRelativeWidth(1);
    cmdUseCurrentLocation:SetText("Update to current location");
    cmdUseCurrentLocation:SetCallback("OnClick", function(info, event)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        local locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
        local playerPosition = locationService:GetCurrentCharacterLocation();

        if dispatcherService._window then
            dispatcherService.Cache.NotificationDispatchData.CoordinateX = playerPosition.ZonePosition.X and string.format("%.2f", playerPosition.ZonePosition.X * 100) or "";
            dispatcherService.Cache.NotificationDispatchData.CoordinateY = playerPosition.ZonePosition.Y and string.format("%.2f", playerPosition.ZonePosition.Y * 100) or "";
            dispatcherService.Cache.NotificationDispatchData.MainLocation = playerPosition.SubZone and playerPosition.SubZone:len() > 0 and playerPosition.SubZone or playerPosition.Zone;

            dispatcherService._window.LocationCoordX:SetText(playerPosition.ZonePosition.X and string.format("%.2f", playerPosition.ZonePosition.X * 100) or "");
            dispatcherService._window.LocationCoordY:SetText(playerPosition.ZonePosition.Y and string.format("%.2f", playerPosition.ZonePosition.Y * 100) or "");
            dispatcherService._window.Location:SetText(playerPosition.SubZone and playerPosition.SubZone:len() > 0 and playerPosition.SubZone or playerPosition.Zone);
        end

    end);
    notificationDetailsGroup:AddChild(cmdUseCurrentLocation);

    ------------------------------------------------------

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

    ------------------------------------------------------

    local ddlChannel = self._aceGUI:Create("Dropdown");
    ddlChannel:SetLabel("Channel");
    ddlChannel:SetRelativeWidth(1);
    ddlChannel:SetList(channelDropdownValues);
    ddlChannel:SetCallback("OnValueChanged", function(info, event, value)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.SenderFrequency = value;
    end);
    ddlChannel:SetValue(self.Cache.NotificationDispatchData.SenderFrequency);
    ddlChannel:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Sender name",
            "Specify the person or entity this notification comes from",
            "Example: Your name, Stormwind Control, Dispatch"
        );

    end);
    ddlChannel:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    notificationDetailsGroup:AddChild(ddlChannel);

    ------------------------------------------------------

    local ddlUnitsRequired = self._aceGUI:Create("Dropdown");
    ddlUnitsRequired:SetLabel("Units required");
    ddlUnitsRequired:SetRelativeWidth(1);
    ddlUnitsRequired:SetList(self._roleService:GetRolesAsKeyValuePairs());
    ddlUnitsRequired:SetMultiselect(true);
    ddlUnitsRequired:SetCallback("OnValueChanged", function(info, event, value, checked)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.UnitsRequired[value] = checked;
    end);
    ddlUnitsRequired:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Units required",
            "Select from the list the kind of units this notification concerns"
        );

    end);
    ddlUnitsRequired:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    notificationDetailsGroup:AddChild(ddlUnitsRequired);

    ------------------------------------------------------

    local txtIncidentDetails = self._aceGUI:Create("MultiLineEditBox");
    txtIncidentDetails:SetLabel("Incident details");
    txtIncidentDetails:SetRelativeWidth(1);
    txtIncidentDetails:SetNumLines(5);
    txtIncidentDetails:SetMaxLetters(200);
    txtIncidentDetails:SetCallback("OnEnterPressed", function(info, event, value) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService.Cache.NotificationDispatchData.IncidentDetails = value;
    end);
    txtIncidentDetails:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Incident details",
            "Provide a summary of the details concerning this notification",
            "Example: Active shooter in Old Town. 3 LEA units are down as are 2 members of the public.\n\nRequire emergency response."
        );

    end);
    txtIncidentDetails:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    notificationDetailsGroup:AddChild(txtIncidentDetails);

    ------------------------------------------------------

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

function GBR_DispatcherService:_buildMainFrame()

    local notificationConfigFrame = self._aceGUI:Create("Window");
    notificationConfigFrame:SetTitle("GBRadio Notification Dispatcher");
    notificationConfigFrame:SetCallback("OnClose", function(widget) 
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        
        dispatcherService._isShown = false;
        aceGUI:Release(widget);
        dispatcherService._window = nil;
        dispatcherService.isShown = false;
    end);
    notificationConfigFrame:SetWidth(350);
    notificationConfigFrame:SetHeight(600);
    notificationConfigFrame:SetLayout("Fill");
    notificationConfigFrame:EnableResize(false);

    local notificationDetails = self:_buildSendNotification(notificationConfigFrame);
    notificationConfigFrame.NotificationDetails = notificationDetails;

    return notificationConfigFrame;

end

function GBR_DispatcherService:_buildNotificationDetailsGroup()

    local notificationDetailsGroup = self._aceGUI:Create("InlineGroup");
    notificationDetailsGroup:SetTitle("Notification details");
    notificationDetailsGroup:SetLayout("Flow");
    notificationDetailsGroup:SetFullWidth(true);
    notificationDetailsGroup:SetFullHeight(true);
    
    return notificationDetailsGroup;
end

function GBR_DispatcherService:DisplayDispatcher()

    if not self._isShown then
        self._window = self:_buildMainFrame();
        self._isShown = true;
    end

end