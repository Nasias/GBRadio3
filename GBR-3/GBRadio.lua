GBRadioAddonData = LibStub("AceAddon-3.0"):NewAddon("GBRadio3", "AceComm-3.0", "AceSerializer-3.0", "AceEvent-3.0", "AceConsole-3.0");
GBRadio = {};
GBR_Singletons = nil;

function GBRadioAddonData:OnInitialize()

    GBR_Singletons = GBR_SingletonService:New();

    GBRadio
        :AddServices()
        :AddConfiguration()
        :AddCommunication()
        :AddHooks();

end

function GBRadio:AddServices()

    GBR_Singletons:RegisterManualService(GBR_Constants.SRV_ADDON_SERVICE, GBRadioAddonData);
    GBR_Singletons:InstantiateService(GBR_Constants.SRV_COMMAND_SERVICE);    


    return self;

end

function GBRadio:AddCommunication()

    local frameMA = CreateFrame("FRAME");
    frameMA:RegisterEvent("PLAYER_ENTERING_WORLD");
    
    function frameMA:OnEvent(event)
        JoinChannelByName(GBR_Constants.OPT_COMM_CHANNEL_NAME, nil);
    end
    
    frameMA:SetScript("OnEvent", frameMA.OnEvent);
    
    GBRadioAddonData:RegisterComm(GBR_Constants.OPT_ADDON_CHANNEL_PREFIX, GBR_MessageService.StaticReceiveMessage);

    return self;

end

function GBRadio:AddConfiguration()

    local defaultSettings = GBR_ConfigPresets.BuzzBox;
    
    GBRadioAddonDataSettingsDB = LibStub(GBR_Constants.LIB_ACE_DB):New(GBR_Constants.OPT_ADDON_SETTINGS_DB, defaultSettings);

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_CONFIG_SERVICE);

    return self;

end

function GBRadio:AddHooks()

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_HOOK_SERVICE)
        :RegisterHooks();


    return self;

end

NotificationTemp = {
    Title = nil,
    Grade = nil,
    MainLocation = nil,
    CoordinateX = nil,
    CoordinateY = nil,
    SenderName = nil,
    SenderCallsign = nil,
    SenderFrequency = nil,
    IncidentDetails = nil,
    UnitsRequired = {},
};

function GBRadio:Dispatcher()

    local AceGUI = LibStub("AceGUI-3.0");
    local roleService = GBR_Singletons:FetchService(GBR_Constants.SRV_ROLE_SERVICE);
    local configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    local notificationService = GBR_Singletons:FetchService(GBR_Constants.SRV_NOTIFICATION_SERVICE);

    local function DrawSendNotification(container)
        local notificationDetailsGroup = AceGUI:Create("InlineGroup");
        notificationDetailsGroup:SetTitle("Notification details");
        notificationDetailsGroup:SetLayout("Fill");
        notificationDetailsGroup:SetFullWidth(true);
        notificationDetailsGroup:SetFullHeight(true);
        container:AddChild(notificationDetailsGroup);

        local notificationDetailsGroupScroller = AceGUI:Create("ScrollFrame");
        notificationDetailsGroupScroller:SetLayout("Flow");
        notificationDetailsGroupScroller:SetFullWidth(true);
        notificationDetailsGroup:AddChild(notificationDetailsGroupScroller);
    
        local txtTitle = AceGUI:Create("EditBox");
        txtTitle:SetLabel("Title");
        txtTitle:SetRelativeWidth(0.5);
        txtTitle:SetCallback("OnEnterPressed", function(info, event, value) NotificationTemp.Title = value end);
        notificationDetailsGroupScroller:AddChild(txtTitle);
    
        local ddlGrade = AceGUI:Create("Dropdown");
        ddlGrade:SetLabel("Grade");
        ddlGrade:SetRelativeWidth(0.5);
        ddlGrade:SetList({
            [GBR_ENotificationGradeType.Grade1] = "Grade 1", 
            [GBR_ENotificationGradeType.Grade2] = "Grade 2", 
            [GBR_ENotificationGradeType.Grade3] = "Grade 3"
        });
        ddlGrade:SetCallback("OnValueChanged", function(key, checked)
            NotificationTemp.Grade = key:GetValue();
        end);
        notificationDetailsGroupScroller:AddChild(ddlGrade);
    
        local txtMainLocation = AceGUI:Create("EditBox");
        txtMainLocation:SetLabel("Main location");
        txtMainLocation:SetRelativeWidth(0.5);
        txtMainLocation:SetCallback("OnEnterPressed", function(info, event, value) NotificationTemp.MainLocation = value end);
        notificationDetailsGroupScroller:AddChild(txtMainLocation);
    
        local txtLocationCoordX = AceGUI:Create("EditBox");
        txtLocationCoordX:SetLabel("Coordinate X");
        txtLocationCoordX:SetRelativeWidth(0.25);
        txtLocationCoordX:SetCallback("OnEnterPressed", function(info, event, value) NotificationTemp.CoordinateX = value end);
        notificationDetailsGroupScroller:AddChild(txtLocationCoordX);
    
        local txtLocationCoordY = AceGUI:Create("EditBox");
        txtLocationCoordY:SetLabel("Coordinate Y");
        txtLocationCoordY:SetRelativeWidth(0.25);
        txtLocationCoordY:SetCallback("OnEnterPressed", function(info, event, value) NotificationTemp.CoordinateY = value end);
        notificationDetailsGroupScroller:AddChild(txtLocationCoordY);
    
        local txtSenderName = AceGUI:Create("EditBox");
        txtSenderName:SetLabel("Sender name");
        txtSenderName:SetRelativeWidth(0.25);
        txtSenderName:SetCallback("OnEnterPressed", function(info, event, value) NotificationTemp.SenderName = value end);
        notificationDetailsGroupScroller:AddChild(txtSenderName);
    
        local txtSenderCallsign = AceGUI:Create("EditBox");
        txtSenderCallsign:SetLabel("Sender callsign");
        txtSenderCallsign:SetRelativeWidth(0.25);
        txtSenderCallsign:SetCallback("OnEnterPressed", function(info, event, value) NotificationTemp.SenderCallsign = value end);
        notificationDetailsGroupScroller:AddChild(txtSenderCallsign);
        
        local channels = configService:GetRegisteredCommunicationFrequencies();
        local channelDropdownValues = {};

        for k,v in pairs(channels) do
            channelDropdownValues[k] = GBR_ConfigService.GetChannelGroupName(v.IsEnabled, v.ChannelName, k);
        end

        local ddlChannel = AceGUI:Create("Dropdown");
        ddlChannel:SetLabel("Channel");
        ddlChannel:SetRelativeWidth(0.5);
        ddlChannel:SetList(channelDropdownValues);
        ddlChannel:SetCallback("OnValueChanged", function(info, event, value)
            NotificationTemp.SenderFrequency = value;
        end);
        notificationDetailsGroupScroller:AddChild(ddlChannel);
    
        local txtIncidentDetails = AceGUI:Create("MultiLineEditBox");
        txtIncidentDetails:SetLabel("Incident details");
        txtIncidentDetails:SetRelativeWidth(1);
        txtIncidentDetails:SetNumLines(5);
        txtIncidentDetails:SetCallback("OnEnterPressed", function(info, event, value) NotificationTemp.IncidentDetails = value end);
        notificationDetailsGroupScroller:AddChild(txtIncidentDetails);
    
        local ddlUnitsRequired = AceGUI:Create("Dropdown");
        ddlUnitsRequired:SetLabel("Units required");
        ddlUnitsRequired:SetRelativeWidth(1);
        ddlUnitsRequired:SetList(roleService:GetRolesAsKeyValuePairs());
        ddlUnitsRequired:SetMultiselect(true);
        ddlUnitsRequired:SetCallback("OnValueChanged", function(info, event, value, checked)
            NotificationTemp.UnitsRequired[value] = checked;
        end);
        notificationDetailsGroupScroller:AddChild(ddlUnitsRequired);
    
        local cmdDispatchNotification = AceGUI:Create("Button");
        cmdDispatchNotification:SetText("Submit");
        cmdDispatchNotification:SetRelativeWidth(1);
        cmdDispatchNotification:SetCallback("OnClick", function()
            local notificationModel = GBR_NotificationModel:New
            { 
                Title = NotificationTemp.Title, 
                Grade = NotificationTemp.Grade, 
                IncidentLocation = NotificationTemp.MainLocation, 
                LocationCoordinateX = NotificationTemp.CoordinateX,
                LocationCoordinateY = NotificationTemp.CoordinateY,
                IncidentReporter = NotificationTemp.SenderName, 
                IncidentFrequency = NotificationTemp.SenderFrequency,
                IncidentDetails = NotificationTemp.IncidentDetails,
                UnitsRequired = "",
            };

            for k,v in pairs(NotificationTemp.UnitsRequired) do
                if v then
                    local roleDetails = roleService:GetRoleForType(k);
                    notificationModel.UnitsRequired = notificationModel.UnitsRequired .. " " .. roleDetails.Icon .. " " .. roleDetails.Abbreviation;
                end
            end

            local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
            local frequency = NotificationTemp.SenderFrequency;
            local messageModel = GBR_MessageModel:New
            {
                MessageData =
                {
                    MessageType = GBR_EMessageType.WhoIsListening,
                    NotificationModel = notificationModel
                }
            };
        
            messageModel.MessageData.MessageType = GBR_EMessageType.Notification;                                    
            messageService:SendMessageForFrequency(messageModel, frequency);            
        end);
        notificationDetailsGroupScroller:AddChild(cmdDispatchNotification);

    end

    local function DrawNotificationHistory(container)
        local notificationDetailsGroup = AceGUI:Create("InlineGroup");
        notificationDetailsGroup:SetTitle("Notification history");
        notificationDetailsGroup:SetLayout("Flow");
        notificationDetailsGroup:SetFullWidth(true);
        notificationDetailsGroup:SetFullHeight(true);
        container:AddChild(notificationDetailsGroup);

    end

    local function SelectGroup(container, event, group)
        container:ReleaseChildren();
        if group == 1 then
            DrawSendNotification(container);
        elseif group == 2 then
            DrawNotificationHistory(container);
        end
    end    

    local notificationConfigFrame = AceGUI:Create("Window");
    notificationConfigFrame:SetTitle("GBRadio Notification Dispatcher");
    notificationConfigFrame:SetStatusText("GBRadio Notification Dispatcher Control Panel");
    notificationConfigFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end);
    notificationConfigFrame:SetLayout("Fill");

    local notificationNavigation = AceGUI:Create("TabGroup");
    notificationNavigation:SetTabs({{value = 1, text = "Send notification"}, {value = 2, text = "Notification history"}});
    notificationNavigation:SetCallback("OnGroupSelected", SelectGroup);
    notificationNavigation:SelectTab(1);
    notificationNavigation:SetLayout("Fill");
    notificationConfigFrame:AddChild(notificationNavigation);

end