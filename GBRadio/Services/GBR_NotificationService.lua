GBR_NotificationService = GBR_Object:New();

function GBR_NotificationService:New(obj)

    self:Initialize();

    return self:RegisterNew(obj);

end

function GBR_NotificationService:_getBackdropFormats()
    return
    {
        BACKDROP_NOTIFICATION = 
        {
            bgFile = [[Interface\Addons\GBRadio\Media\Textures\Notification-BG.tga]],
            tile = true,
            tileEdge = true,
            tileSize = 8,
            edgeSize = 12,
        },
        BACKDROP_NOTIFICATION_TITLE = 
        {
            bgFile = [[Interface\Addons\GBRadio\Media\Textures\Notification-BG.tga]],
            tile = true,
            tileEdge = true,
            tileSize = 8,
        }
    };
end

-- Builders
function GBR_NotificationService:_buildNotificaionTitle(parent)

    local titleFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate");
    titleFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0);
    titleFrame:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -50);
    titleFrame:SetBackdrop(self.BackdropFormats.BACKDROP_NOTIFICATION_TITLE);
    titleFrame:SetBackdropColor(0, 0, 0, 0.4);

    local titleIcon = titleFrame:CreateTexture(nil, "BORDER");
    titleIcon:SetSize(16, 16);
    titleIcon:SetPoint("LEFT", titleFrame, "LEFT", 15, 0);
    titleIcon:SetTexture([[Interface\Addons\GBRadio\Media\Textures\Triangle-Exclamation-Solid]]);

    local titleText = titleFrame:CreateFontString();
    titleText:SetFontObject("GBRAlert_Title");
    titleText:SetJustifyH("LEFT");
    titleText:SetJustifyV("MIDDLE");
    titleText:SetWordWrap(true);
    titleText:SetPoint("TOPLEFT", titleFrame, "TOPLEFT", 43, 0);
    titleText:SetPoint("BOTTOMRIGHT", titleFrame, "BOTTOMRIGHT", 0, -4);

    titleFrame.Icon = titleIcon;
    titleFrame.Text = titleText;

    return titleFrame;

end

function GBR_NotificationService:_buildIncidentGrade(parent)

    local incidentGradeFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate");
    incidentGradeFrame:SetPoint("TOPLEFT", parent, "TOPRIGHT", -95, -15);
    incidentGradeFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -15, 15);
    incidentGradeFrame:SetBackdrop(self.BackdropFormats.BACKDROP_NOTIFICATION_TITLE);
    incidentGradeFrame:SetBackdropColor(0.8509, 0.1215, 0.4627, 1);

    local incidentGradeText = incidentGradeFrame:CreateFontString();
    incidentGradeText:SetFontObject("GBRAlert_Grade");
    incidentGradeText:SetJustifyH("CENTER");
    incidentGradeText:SetJustifyV("MIDDLE");
    incidentGradeText:SetWordWrap(true);
    incidentGradeText:SetPoint("TOPLEFT", incidentGradeFrame, "TOPLEFT", 0, 0);
    incidentGradeText:SetPoint("BOTTOMRIGHT", incidentGradeFrame, "BOTTOMRIGHT", 0, -2);

    incidentGradeFrame.Text = incidentGradeText;

    return incidentGradeFrame;

end

function GBR_NotificationService:_buildIncidentLocation(parent)

    local incidentLocationFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate");
    incidentLocationFrame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -1);
    incidentLocationFrame:SetSize(160, 40);

    local incidentLocationIcon = incidentLocationFrame:CreateTexture(nil, "BORDER");
    incidentLocationIcon:SetSize(16, 16);
    incidentLocationIcon:SetPoint("LEFT", incidentLocationFrame, "LEFT", 15, 0);
    incidentLocationIcon:SetTexture([[Interface\Addons\GBRadio\Media\Textures\Compass-Solid]]);

    local incidentLocationText = incidentLocationFrame:CreateFontString();
    incidentLocationText:SetFontObject("GBRAlert_Details");
    incidentLocationText:SetJustifyH("LEFT");
    incidentLocationText:SetJustifyV("MIDDLE");
    incidentLocationText:SetWordWrap(true);
    incidentLocationText:SetPoint("TOPLEFT", incidentLocationFrame, "TOPLEFT", 43, 0);
    incidentLocationText:SetPoint("BOTTOMRIGHT", incidentLocationFrame, "BOTTOMRIGHT", 0, 0);

    incidentLocationFrame.Icon = incidentLocationIcon;
    incidentLocationFrame.Text = incidentLocationText;

    return incidentLocationFrame;

end

function GBR_NotificationService:_buildIncidentReporter(parent)

    local reporterNameFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate");
    reporterNameFrame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -1);
    reporterNameFrame:SetSize(160, 40);

    local reporterNameIcon = reporterNameFrame:CreateTexture(nil, "BORDER");
    reporterNameIcon:SetSize(16, 16);
    reporterNameIcon:SetPoint("LEFT", reporterNameFrame, "LEFT", 15, 0);
    reporterNameIcon:SetTexture([[Interface\Addons\GBRadio\Media\Textures\User-Solid]]);

    local reporterNameText = reporterNameFrame:CreateFontString();
    reporterNameText:SetFontObject("GBRAlert_Details");
    reporterNameText:SetJustifyH("LEFT");
    reporterNameText:SetJustifyV("MIDDLE");
    reporterNameText:SetWordWrap(true);
    reporterNameText:SetPoint("TOPLEFT", reporterNameFrame, "TOPLEFT", 43, 0);
    reporterNameText:SetPoint("BOTTOMRIGHT", reporterNameFrame, "BOTTOMRIGHT", 0, 0);

    reporterNameFrame.Icon = reporterNameIcon;
    reporterNameFrame.Text = reporterNameText;

    return reporterNameFrame;

end

function GBR_NotificationService:_buildIncidentFrequency(parent)

    local incidentFrequencyFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate");
    incidentFrequencyFrame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -1);
    incidentFrequencyFrame:SetSize(160, 40);

    local incidentFrequencyIcon = incidentFrequencyFrame:CreateTexture(nil, "BORDER");
    incidentFrequencyIcon:SetSize(16, 16);
    incidentFrequencyIcon:SetPoint("LEFT", incidentFrequencyFrame, "LEFT", 15, 0)
    incidentFrequencyIcon:SetTexture([[Interface\Addons\GBRadio\Media\Textures\Tower-Cell-Solid]]);

    local incidentFrequencyText = incidentFrequencyFrame:CreateFontString();
    incidentFrequencyText:SetFontObject("GBRAlert_Details");
    incidentFrequencyText:SetJustifyH("LEFT");
    incidentFrequencyText:SetJustifyV("MIDDLE");
    incidentFrequencyText:SetWordWrap(true);
    incidentFrequencyText:SetPoint("TOPLEFT", incidentFrequencyFrame, "TOPLEFT", 43, 0);
    incidentFrequencyText:SetPoint("BOTTOMRIGHT", incidentFrequencyFrame, "BOTTOMRIGHT", 0, 0);

    incidentFrequencyFrame.Icon = incidentFrequencyIcon;
    incidentFrequencyFrame.Text = incidentFrequencyText;

    return incidentFrequencyFrame;

end

function GBR_NotificationService:_buildIncidentDescription(parent)

    local incidentDescriptionFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate");
    incidentDescriptionFrame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 10, -12);
    incidentDescriptionFrame:SetSize(300, 80);

    local incidentDescriptionIcon = incidentDescriptionFrame:CreateTexture(nil, "BORDER");
    incidentDescriptionIcon:SetSize(16, 16);
    incidentDescriptionIcon:SetPoint("TOPLEFT", incidentDescriptionFrame, "TOPLEFT", 15, 0)
    incidentDescriptionIcon:SetTexture([[Interface\Addons\GBRadio\Media\Textures\Circle-Info-Solid]]);

    local incidentDescriptionText = incidentDescriptionFrame:CreateFontString();
    incidentDescriptionText:SetFontObject("GBRAlert_Details");
    incidentDescriptionText:SetJustifyH("LEFT");
    incidentDescriptionText:SetJustifyV("TOP");
    incidentDescriptionText:SetWordWrap(true);
    incidentDescriptionText:SetPoint("TOPLEFT", incidentDescriptionFrame, "TOPLEFT", 43, 4);
    incidentDescriptionText:SetPoint("BOTTOMRIGHT", incidentDescriptionFrame, "BOTTOMRIGHT", 0, 0);

    incidentDescriptionFrame.Icon = incidentDescriptionIcon;
    incidentDescriptionFrame.Text = incidentDescriptionText;

    return incidentDescriptionFrame;

end

function GBR_NotificationService:_buildUnitsRequired(parent)

    local unitsRequiredFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate");
    unitsRequiredFrame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 10, 0);
    unitsRequiredFrame:SetSize(300, 40);

    local unitsRequiredIcon = unitsRequiredFrame:CreateTexture(nil, "BORDER");
    unitsRequiredIcon:SetSize(16, 16);
    unitsRequiredIcon:SetPoint("LEFT", unitsRequiredFrame, "LEFT", 15, 0)
    unitsRequiredIcon:SetTexture([[Interface\Addons\GBRadio\Media\Textures\Shield-Halved-Solid]]);

    local unitsRequiredText = unitsRequiredFrame:CreateFontString();
    unitsRequiredText:SetFontObject("GBRAlert_Details");
    unitsRequiredText:SetJustifyH("LEFT");
    unitsRequiredText:SetJustifyV("MIDDLE");
    unitsRequiredText:SetWordWrap(true);
    unitsRequiredText:SetPoint("TOPLEFT", unitsRequiredFrame, "TOPLEFT", 43, 0);
    unitsRequiredText:SetPoint("BOTTOMRIGHT", unitsRequiredFrame, "BOTTOMRIGHT", 0, 0);

    unitsRequiredFrame.Icon = unitsRequiredIcon;
    unitsRequiredFrame.Text = unitsRequiredText;

    return unitsRequiredFrame;

end

function GBR_NotificationService:_buildClickToClose(parent)
    
    local clickToCloseText = parent:CreateFontString();
    clickToCloseText:SetFontObject("GBRAlert_Details");
    clickToCloseText:SetJustifyH("CENTER");
    clickToCloseText:SetJustifyV("TOP");
    clickToCloseText:SetWordWrap(true);
    clickToCloseText:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, 20);
    clickToCloseText:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0);
    clickToCloseText:SetText("[ Click to dismiss ]");

    return clickToCloseText;

end

function GBR_NotificationService:_buildNotificationFrame()

    local notificationFrame = CreateFrame("Button", nil, UIParent, "BackdropTemplate");
    notificationFrame:SetFrameStrata("DIALOG");
    notificationFrame:Hide();

    notificationFrame:SetSize(self.Settings.FrameWidth, self.Settings.FrameHeight);
    notificationFrame:SetPoint("TOP", UIParent, "TOP", 0, -10);
    notificationFrame:SetBackdrop(self.BackdropFormats.BACKDROP_NOTIFICATION);
    notificationFrame:SetScript("OnClick", GBR_NotificationService.DismissNotification);
    
    local animateIn = notificationFrame:CreateAnimationGroup();
    notificationFrame.AnimateIn = animateIn;

    local animateOut = notificationFrame:CreateAnimationGroup();
    notificationFrame.AnimateOut = animateOut;

    local animateInAnimation = animateIn:CreateAnimation("Alpha");
    animateInAnimation:SetOrder(1);
    animateInAnimation:SetFromAlpha(0);
    animateInAnimation:SetToAlpha(1);
    animateInAnimation:SetDuration(0.2);

    local title = self:_buildNotificaionTitle(notificationFrame);
    notificationFrame.Title = title;

    local incidentGrade = self:_buildIncidentGrade(title);
    notificationFrame.IncidentGrade = incidentGrade;

    local incidentLocation = self:_buildIncidentLocation(title);
    notificationFrame.IncidentLocation = incidentLocation;

    local incidentReporter = self:_buildIncidentReporter(incidentLocation);
    notificationFrame.IncidentReporter = incidentReporter;
            
    local incidentFrequency = self:_buildIncidentFrequency(incidentReporter);
    notificationFrame.IncidentFrequency = incidentFrequency;

    local incidentDescription = self:_buildIncidentDescription(incidentLocation);
    notificationFrame.IncidentDescription = incidentDescription;

    local unitsRequired = self:_buildUnitsRequired(incidentFrequency);
    notificationFrame.UnitsRequired = unitsRequired;

    local clickToClose = self:_buildClickToClose(notificationFrame);
    notificationFrame.ClickToClose = clickToClose;

    return notificationFrame;

end

function GBR_NotificationService.DismissNotification(notificationFrame)
    local self = GBR_Singletons:FetchService(GBR_Constants.SRV_NOTIFICATION_SERVICE);

    self:_reclaimNotification(notificationFrame);
end

function GBR_NotificationService:_reclaimNotification(notificationFrame)

    notificationFrame:Hide();

    table.insert(self.NotificationPool, notificationFrame);

    for i = 1, #self.ActiveNotifications do
        if self.ActiveNotifications[i] == notificationFrame then
            table.remove(self.ActiveNotifications, i):ClearAllPoints();
        end
    end

    for i = 1, #self.ActiveNotifications do
        local activeNotification = self.ActiveNotifications[i];

        activeNotification:ClearAllPoints();
        activeNotification:SetPoint("TOP", UIParent, "TOP", 0, self:_getNewNotificationPosition(i));
    end

    local queuedNotification = table.remove(self.NotificationQueue, 1);
    if queuedNotification ~= nil then
        self:_spawnNotification(queuedNotification);
    end
end

function GBR_NotificationService:_spawnNotification(notificationFrame)
    
    notificationFrame:SetPoint("TOP", UIParent, "TOP", 0, self:_getNewNotificationPosition(#self.ActiveNotifications + 1));

    table.insert(self.ActiveNotifications, notificationFrame);

    notificationFrame:Show();
    notificationFrame.AnimateIn:Play();

end

function GBR_NotificationService:_getNewNotificationPosition(positionNumber)

    return positionNumber == 1
        and self.Settings.FrameOffsetY * -1 
        or ((self.Settings.FrameHeight + (self.Settings.FrameOffsetY*2)) * (positionNumber - 1)) * -1;
    
end

function GBR_NotificationService:QueueNotification(notificationModel)

    local notification = self:_getNotificationFrame();
    local notificationProxy = GBR_NotificationProxy:New
    {
        Notification = notification,
    };
    
    notificationProxy:ApplyModel(notificationModel);    
    self:_setGradeColour(notification, notificationModel.Grade);

    if #self.ActiveNotifications >= self.Settings.MaxActiveNotifications then
        table.insert(self.NotificationQueue, notification);
    else
        self:_spawnNotification(notification);
    end
    
end

function GBR_NotificationService:_getNotificationFrame()

    return table.remove(self.NotificationPool) or self:_buildNotificationFrame();    

end

function GBR_NotificationService:_setGradeColour(notification, incidentGrade)

    local gradeColours = self.BackdropColours[incidentGrade];
    notification:SetBackdropColor(gradeColours.R, gradeColours.G, gradeColours.B, 1);
    notification:SetBackdropBorderColor(gradeColours.R, gradeColours.G, gradeColours.B, 1);

end

function GBR_NotificationService:Initialize()
    self.ActiveNotifications = {};
    self.NotificationPool = {};
    self.NotificationQueue = {};
    self.BackdropFormats = self:_getBackdropFormats();
    self.AnimationMeta = {
        CurrentIteration = 1,
        Mode = 1, -- Mode 1 fade from start to end. Mode 2 fade from end to start.
        IterationCount = 30
    };

    self.Settings = {
        MaxActiveNotifications = 2,
        FrameWidth = 500,
        FrameHeight = 200,
        FrameOffsetY = 15,
    };

    self.BackdropColours = {
        [GBR_ENotificationGradeType.Grade1] = {
            R = 0.7890,
            G = 0.2460,
            B = 0.1953,
        },
        [GBR_ENotificationGradeType.Grade2] = {
            R = 0.0781,
            G = 0.2968,
            B = 0.5976,
        },
        [GBR_ENotificationGradeType.Grade3] = {
            R = 0.3529,
            G = 0.3529,
            B = 0.3529,
        },
    };

    self.AnimatedBackdropColours = {
        [GBR_ENotificationGradeType.Grade1] = {
            Start = {
                R = 0.7890,
                G = 0.2460,
                B = 0.1953,
            },
            End = {
                R = 0.0781,
                G = 0.2968,
                B = 0.5976,
            },
            Step = {
                R = nil,
                G = nil,
                B = nil,
            }
        },
    };

    for k, v in pairs(self.AnimatedBackdropColours) do
    
        v.Step.R = (v.End.R - v.Start.R) / self.AnimationMeta.IterationCount;
        v.Step.G = (v.End.G - v.Start.G) / self.AnimationMeta.IterationCount;
        v.Step.B = (v.End.B - v.Start.B) / self.AnimationMeta.IterationCount;
        
    end

    self.AnimationTimer = C_Timer.NewTicker(0.03, function()

        local notificationService = GBR_Singletons:FetchService(GBR_Constants.SRV_NOTIFICATION_SERVICE);
    
        if #notificationService.ActiveNotifications == 0 then
            return;
        end

        local backdropColours = notificationService.AnimatedBackdropColours[1];
        local meta = notificationService.AnimationMeta;

        local red = meta.Mode == 1 
            and backdropColours.Start.R + (backdropColours.Step.R * meta.CurrentIteration)
            or backdropColours.Start.R + (backdropColours.Step.R * (meta.IterationCount - meta.CurrentIteration));

        local green = meta.Mode == 1 
            and backdropColours.Start.G + (backdropColours.Step.G * meta.CurrentIteration)
            or backdropColours.Start.G + (backdropColours.Step.G * (meta.IterationCount - meta.CurrentIteration));

        local blue = meta.Mode == 1 
            and backdropColours.Start.B + (backdropColours.Step.B * meta.CurrentIteration)
            or backdropColours.Start.B + (backdropColours.Step.B * (meta.IterationCount - meta.CurrentIteration));
    
        for k,v in ipairs(notificationService.ActiveNotifications) do
            local grade = v.GBRMetaGrade;

            if grade == GBR_ENotificationGradeType.Grade1 then             
                v:SetBackdropColor(red, green, blue, 1);
                v:SetBackdropBorderColor(red, green, blue, 1);
            end
        end
    
        if meta.CurrentIteration > meta.IterationCount then
            meta.CurrentIteration = 1;
            meta.Mode = meta.Mode == 1 and 2 or 1; -- flip mode
        end

        meta.CurrentIteration = meta.CurrentIteration + 1;
    
    end);

end