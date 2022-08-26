GBRadioAddonData = LibStub("AceAddon-3.0"):NewAddon("GBRadio3", "AceComm-3.0", "AceSerializer-3.0", "AceEvent-3.0", "AceConsole-3.0");
GBRadio = {};
GBR_Singletons = nil;

function GBRadioAddonData:OnInitialize()

    -- # Begin Globals
    GBR_Singletons = GBR_SingletonService:New();
    GBRadio:ConfigureServices();
    GBRadio:ConfigureCommunication();
    -- # End Globals    

end

function GBRadio:ConfigureServices()

    GBR_Singletons:RegisterManualService(GBR_Constants.SRV_ADDON_SERVICE, GBRadioAddonData);
    GBR_Singletons:InstantiateService(GBR_Constants.SRV_COMMAND_SERVICE);    

    local defaultSettings = GBR_ConfigPresets.BuzzBox;
    
    GBRadioAddonDataSettingsDB = LibStub(GBR_Constants.LIB_ACE_DB):New(GBR_Constants.OPT_ADDON_SETTINGS_DB, defaultSettings);

    GBR_Singletons:InstantiateService(GBR_Constants.SRV_CONFIG_SERVICE);

end

function GBRadio:ConfigureCommunication()

    local frameMA = CreateFrame("FRAME");
    frameMA:RegisterEvent("PLAYER_ENTERING_WORLD");
    
    function frameMA:OnEvent(event)
        JoinChannelByName(GBR_Constants.OPT_COMM_CHANNEL_NAME, nil);
    end
    
    frameMA:SetScript("OnEvent", frameMA.OnEvent);

    GBRadioAddonData:RegisterComm(GBR_Constants.OPT_ADDON_CHANNEL_PREFIX, GBR_MessageService.StaticReceiveMessage);

end

NotificationFrames = NotificationFrames or {};

function GBRadio:NotificationTest()

    local BACKDROP_NOTIFICATION = {
        bgFile = [[Interface\Addons\GBR-3\Media\Textures\Notification-BG.tga]],
        tile = true,
        tileEdge = true,
        tileSize = 8,
        edgeSize = 12,
        --insets = { left = 5, right = 5, top = 5, bottom = 5 },
    };

    local BACKDROP_NOTIFICATION_TITLE = {
        bgFile = [[Interface\Addons\GBR-3\Media\Textures\Notification-BG.tga]],
        tile = true,
        tileEdge = true,
        tileSize = 8,
        --insets = { left = 6, right = 6, top = 6, bottom = 0 },
    };

    -- Notification Block
    notification = CreateFrame("Button", nil, UIParent, "BackdropTemplate");
    notification:SetFrameStrata("DIALOG");
    notification:SetSize(500, 175);
    notification:SetPoint("TOP", UIParent, "TOP", 0, -10);
    notification:SetBackdrop(BACKDROP_NOTIFICATION);
    notification:SetBackdropColor(0.7890625, 0.24609375, 0.1953125, 1);
    notification:SetBackdropBorderColor(0.7890625, 0.24609375, 0.1953125, 1);

        titleBackdrop = CreateFrame("Frame", nil, notification, "BackdropTemplate");
        titleBackdrop:SetPoint("TOPLEFT", notification, "TOPLEFT", 0, 0);
        titleBackdrop:SetPoint("BOTTOMRIGHT", notification, "TOPRIGHT", 0, -50);
        titleBackdrop:SetBackdrop(BACKDROP_NOTIFICATION_TITLE);
        titleBackdrop:SetBackdropColor(0, 0, 0, 0.4);

            titleBackdropIcon = titleBackdrop:CreateTexture(nil, "BORDER");
            titleBackdropIcon:SetSize(16, 16);
            titleBackdropIcon:SetPoint("LEFT", titleBackdrop, "LEFT", 15, 0)
            titleBackdropIcon:SetTexture([[Interface\Addons\GBR-3\Media\Textures\Triangle-Exclamation-Solid]]);

            titleText = titleBackdrop:CreateFontString(titleBackdrop, "BORDER", "GBRAlert_Title")
            titleText:SetJustifyH("LEFT")
            titleText:SetJustifyV("MIDDLE")
            titleText:SetWordWrap(true)
            titleText:SetPoint("TOPLEFT", titleBackdrop, "TOPLEFT", 43, 0)
            titleText:SetPoint("BOTTOMRIGHT", titleBackdrop, "BOTTOMRIGHT", 0, -4)
            titleText:SetText("INCIDENT ALERT");
-- 
            userLocationFrame = CreateFrame("Frame", nil, titleBackdrop, "BackdropTemplate");
            userLocationFrame:SetPoint("TOPLEFT", titleBackdrop, "BOTTOMLEFT", 0, -1);
            userLocationFrame:SetSize(160, 40);

                userLocationIcon = userLocationFrame:CreateTexture(nil, "BORDER");
                userLocationIcon:SetSize(16, 16);
                userLocationIcon:SetPoint("LEFT", userLocationFrame, "LEFT", 15, 0)
                userLocationIcon:SetTexture([[Interface\Addons\GBR-3\Media\Textures\Compass-Solid]]);

                userLocationText = userLocationFrame:CreateFontString(userLocationFrame, "BORDER", "GBRAlert_Details")
                userLocationText:SetJustifyH("LEFT")
                userLocationText:SetJustifyV("MIDDLE")
                userLocationText:SetWordWrap(true)
                userLocationText:SetPoint("TOPLEFT", userLocationFrame, "TOPLEFT", 43, 0)
                userLocationText:SetPoint("BOTTOMRIGHT", userLocationFrame, "BOTTOMRIGHT", 0, -4)
                userLocationText:SetText("STORMWIND CITY\n(52.43, 80.79)");

            userNameFrame = CreateFrame("Frame", nil, userLocationFrame, "BackdropTemplate");
            userNameFrame:SetPoint("TOPLEFT", userLocationFrame, "BOTTOMLEFT", 0, -1);
            userNameFrame:SetSize(160, 40);

                userNameIcon = userNameFrame:CreateTexture(nil, "BORDER");
                userNameIcon:SetSize(16, 16);
                userNameIcon:SetPoint("LEFT", userNameFrame, "LEFT", 15, 0)
                userNameIcon:SetTexture([[Interface\Addons\GBR-3\Media\Textures\User-Solid]]);

                userNameText = userNameFrame:CreateFontString(userNameFrame, "BORDER", "GBRAlert_Details")
                userNameText:SetJustifyH("LEFT")
                userNameText:SetJustifyV("MIDDLE")
                userNameText:SetWordWrap(true)
                userNameText:SetPoint("TOPLEFT", userNameFrame, "TOPLEFT", 43, 0)
                userNameText:SetPoint("BOTTOMRIGHT", userNameFrame, "BOTTOMRIGHT", 0, -4)
                userNameText:SetText("ROOK TATSUYA\n(SO-159)");

            frequencyFrame = CreateFrame("Frame", nil, userNameFrame, "BackdropTemplate");
            frequencyFrame:SetPoint("TOPLEFT", userNameFrame, "BOTTOMLEFT", 0, -1);
            frequencyFrame:SetSize(160, 40);

                frequencyIcon = frequencyFrame:CreateTexture(nil, "BORDER");
                frequencyIcon:SetSize(16, 16);
                frequencyIcon:SetPoint("LEFT", frequencyFrame, "LEFT", 15, 0)
                frequencyIcon:SetTexture([[Interface\Addons\GBR-3\Media\Textures\Tower-Cell-Solid]]);

                frequencyText = frequencyFrame:CreateFontString(frequencyFrame, "BORDER", "GBRAlert_Details")
                frequencyText:SetJustifyH("LEFT")
                frequencyText:SetJustifyV("MIDDLE")
                frequencyText:SetWordWrap(true)
                frequencyText:SetPoint("TOPLEFT", frequencyFrame, "TOPLEFT", 43, 0)
                frequencyText:SetPoint("BOTTOMRIGHT", frequencyFrame, "BOTTOMRIGHT", 0, 0)
                frequencyText:SetText("EC999");

            incidentDescriptionFrame = CreateFrame("Frame", nil, userLocationFrame, "BackdropTemplate");
            incidentDescriptionFrame:SetPoint("TOPLEFT", userLocationFrame, "TOPRIGHT", 10, -12);
            incidentDescriptionFrame:SetSize(300, 80);

                incidentDescriptionIcon = incidentDescriptionFrame:CreateTexture(nil, "BORDER");
                incidentDescriptionIcon:SetSize(16, 16);
                incidentDescriptionIcon:SetPoint("TOPLEFT", incidentDescriptionFrame, "TOPLEFT", 15, 0)
                incidentDescriptionIcon:SetTexture([[Interface\Addons\GBR-3\Media\Textures\Circle-Info-Solid]]);

                incidentDescriptionText = incidentDescriptionFrame:CreateFontString(incidentDescriptionFrame, "BORDER", "GBRAlert_Details")
                incidentDescriptionText:SetJustifyH("LEFT")
                incidentDescriptionText:SetJustifyV("TOP")
                incidentDescriptionText:SetWordWrap(true)
                incidentDescriptionText:SetPoint("TOPLEFT", incidentDescriptionFrame, "TOPLEFT", 43, 0)
                incidentDescriptionText:SetPoint("BOTTOMRIGHT", incidentDescriptionFrame, "BOTTOMRIGHT", 0, 0)
                incidentDescriptionText:SetText("INCIDENT OVERVIEW\nAlpha patrol (Echo Company) reports three armed suspects at large in the Mage Quarter, Stormwind City.\n\nInjures: 4 PUB, 2 LEA.");

            unitsRequiredFrame = CreateFrame("Frame", nil, frequencyFrame, "BackdropTemplate");
            unitsRequiredFrame:SetPoint("TOPLEFT", frequencyFrame, "TOPRIGHT", 10, 0);
            unitsRequiredFrame:SetSize(300, 40);

                unitsRequiredIcon = unitsRequiredFrame:CreateTexture(nil, "BORDER");
                unitsRequiredIcon:SetSize(16, 16);
                unitsRequiredIcon:SetPoint("LEFT", unitsRequiredFrame, "LEFT", 15, 0)
                unitsRequiredIcon:SetTexture([[Interface\Addons\GBR-3\Media\Textures\Shield-Halved-Solid]]);

                unitsRequiredText = unitsRequiredFrame:CreateFontString(unitsRequiredFrame, "BORDER", "GBRAlert_Details")
                unitsRequiredText:SetJustifyH("LEFT")
                unitsRequiredText:SetJustifyV("MIDDLE")
                unitsRequiredText:SetWordWrap(true)
                unitsRequiredText:SetPoint("TOPLEFT", unitsRequiredFrame, "TOPLEFT", 43, 0)
                unitsRequiredText:SetPoint("BOTTOMRIGHT", unitsRequiredFrame, "BOTTOMRIGHT", 0, 0)
                unitsRequiredText:SetText("UNITS REQUIRED\nSilver Commander, OFC, AFO, FLP, ELS");

    titleGrade = CreateFrame("Frame", nil, titleBackdrop, "BackdropTemplate");
    titleGrade:SetPoint("TOPLEFT", titleBackdrop, "TOPRIGHT", -95, -15);
    titleGrade:SetPoint("BOTTOMRIGHT", titleBackdrop, "BOTTOMRIGHT", -15, 15);
    titleGrade:SetBackdrop(BACKDROP_NOTIFICATION_TITLE);
    titleGrade:SetBackdropColor(0.8509, 0.1215, 0.4627, 1);

    gradeText = titleGrade:CreateFontString(titleGrade, "BORDER", "GBRAlert_Grade")
    gradeText:SetJustifyH("CENTER")
    gradeText:SetJustifyV("MIDDLE")
    gradeText:SetWordWrap(true)
    gradeText:SetPoint("TOPLEFT", titleGrade, "TOPLEFT", 0, 0)
    gradeText:SetPoint("BOTTOMRIGHT", titleGrade, "BOTTOMRIGHT", 0, -3)
    gradeText:SetText("GRADE 1");

    tinsert(NotificationFrames, notification);

    notification:Show();

end

GBRFrameColours = {
    Start = {
        R = 0.7890625,
        G = 0.24609375,
        B = 0.1953125,
    },  
    End = {
        R = 0.078125,
        G = 0.296875,
        B = 0.59765625,
    },
    Current = {
        R = 0.7890625,
        G = 0.24609375,
        B = 0.1953125,
    },
    Step = {
        R = nil,
        G = nil,
        B = nil,
    },
    Mode = 0,
    Iteration = 0,
};

IterationCount = 30;

GBRFrameColours.Step.R = (GBRFrameColours.End.R - GBRFrameColours.Start.R) / IterationCount;
GBRFrameColours.Step.G = (GBRFrameColours.End.G - GBRFrameColours.Start.G) / IterationCount;
GBRFrameColours.Step.B = (GBRFrameColours.End.B - GBRFrameColours.Start.B) / IterationCount;

C_Timer.NewTicker(0.04, function()

    if #NotificationFrames == 0 then
        return;
    end

    for k,v in pairs(NotificationFrames) do
        v:SetBackdropColor(GBRFrameColours.Current.R, GBRFrameColours.Current.G, GBRFrameColours.Current.B, 1);
        v:SetBackdropBorderColor(GBRFrameColours.Current.R, GBRFrameColours.Current.G, GBRFrameColours.Current.B, 1);
    end

    if GBRFrameColours.Mode == 0 then
        GBRFrameColours.Current.R = GBRFrameColours.Current.R + GBRFrameColours.Step.R;
        GBRFrameColours.Current.G = GBRFrameColours.Current.G + GBRFrameColours.Step.G;
        GBRFrameColours.Current.B = GBRFrameColours.Current.B + GBRFrameColours.Step.B;
        GBRFrameColours.Iteration = GBRFrameColours.Iteration + 1;
    end

    if GBRFrameColours.Mode == 1 then
        GBRFrameColours.Current.R = GBRFrameColours.Current.R - GBRFrameColours.Step.R;
        GBRFrameColours.Current.G = GBRFrameColours.Current.G - GBRFrameColours.Step.G;
        GBRFrameColours.Current.B = GBRFrameColours.Current.B - GBRFrameColours.Step.B;
        GBRFrameColours.Iteration = GBRFrameColours.Iteration + 1;
    end

    if GBRFrameColours.Iteration >= IterationCount then
        GBRFrameColours.Iteration = 0;
        GBRFrameColours.Mode = 1 - GBRFrameColours.Mode; -- flip mode
    end

end);