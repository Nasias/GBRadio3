GBR_MicroMenuService = GBR_Object:New();

function GBR_MicroMenuService:New(obj)

    self._aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._tooltipWidget = self._tooltipWidget or CreateFrame("GameTooltip", "GBRadioMicroMenuTooltip", UIParent, "SharedTooltipTemplate");
    self._window = nil;
    self.isShown = false;

    return self:RegisterNew(obj);

end

function GBR_MicroMenuService:RefreshPrimaryChannel()

    if self._window == nil then
        return;
    end

    self._window.ChannelSelector:SetValue(self._configService:GetPrimaryFrequency());

end

function GBR_MicroMenuService:_buildMainFrame()

    local lastPosition = self._configService:GetMicroMenuPosition();
    local notificationConfigFrame = self._aceGUI:Create("Window");

    notificationConfigFrame:SetTitle(GetUnitName(GBR_Constants.ID_PLAYER) .. "'s " .. GBR_Converter.FirstToUpper(self._configService:GetDeviceName()));
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

    if lastPosition.X  ~= nil and lastPosition.Y ~= nil then
        notificationConfigFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", lastPosition.X, lastPosition.Y);
    end


    local channels = self._configService:GetRegisteredCommunicationFrequencies();
    local channelDropdownValues = {};
    for k,v in pairs(channels) do
        channelDropdownValues[k] = GBR_ConfigService.GetChannelGroupName(v.IsEnabled, v.ChannelName, k);
    end

    local channelSelector = self._aceGUI:Create("Dropdown");
    channelSelector:SetList(channelDropdownValues);
    channelSelector:SetValue(self._configService:GetPrimaryFrequency());
    channelSelector:SetRelativeWidth(1);
    channelSelector:SetCallback("OnValueChanged", function(info, event, key)
        local configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
        configService:SetPrimaryFrequency(key);
    end);
    channelSelector:SetCallback("OnEnter", function(info, event)
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);

        local tooltip = microMenu._tooltipWidget;
    
        tooltip:SetOwner(info.frame, "ANCHOR_TOPRIGHT");

        local name = "Channel";
        local desc = "Select the primary channel that your device will use to send messages.";
        local note = "Note: The primary channel is where all messages sent with '/bb', '/wbb' and '/pb' will be sent. You always pick up messages from other channels regardless of this setting.";
    
        tooltip:SetText(name, 1, .82, 0, true);
        tooltip:AddLine(desc, 1, 1, 1, true);
        tooltip:AddLine(note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)

    
        tooltip:Show();
    end);
    channelSelector:SetCallback("OnLeave", function(info, event)
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
        local tooltip = microMenu._tooltipWidget;     
        tooltip:Hide();
    end);
    notificationConfigFrame:AddChild(channelSelector);
    notificationConfigFrame.ChannelSelector = channelSelector;

    local btnOpenDispatcher = self._aceGUI:Create("Button");
    btnOpenDispatcher:SetText([[|TInterface\Addons\GBR-3\Media\Textures\Buttons\Dispatch.tga:15:15:0:0:128:128:0:128:0:128:255:204:9|t]]);
    btnOpenDispatcher:SetRelativeWidth(0.25);
    btnOpenDispatcher:SetHeight(35);
    btnOpenDispatcher:SetCallback("OnClick", function(info, event)
        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService:DisplayDispatcher();
    end);
    btnOpenDispatcher:SetCallback("OnEnter", function(info, event)
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);

        local tooltip = microMenu._tooltipWidget;
    
        tooltip:SetOwner(info.frame, "ANCHOR_TOPRIGHT");

        local name = "Dispatcher menu";
        local desc = "Opens the dispatcher menu, where you can send notificaitons to other channel subscribers.";
        local note = "Note: You can also type '/gbr dispatch' to open this menu.";
    
        tooltip:SetText(name, 1, .82, 0, true);
        tooltip:AddLine(desc, 1, 1, 1, true);
        tooltip:AddLine(note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)

    
        tooltip:Show();
    end);
    btnOpenDispatcher:SetCallback("OnLeave", function(info, event)
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
        local tooltip = microMenu._tooltipWidget;     
        tooltip:Hide();
    end);
    notificationConfigFrame:AddChild(btnOpenDispatcher);

    local btnPanic = self._aceGUI:Create("Button");
    btnPanic:SetText([[|TInterface\Addons\GBR-3\Media\Textures\Buttons\Panic.tga:15:15:0:0:128:128:0:128:0:128:255:255:255|t]]);
    btnPanic:SetRelativeWidth(0.25);
    btnPanic:SetHeight(35);
    btnPanic:SetCallback("OnClick", function(info, event)
        local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
        local messageModel = GBR_MessageModel:New();    
        messageModel.MessageData.MessageType = GBR_EMessageType.Emergency;    
        messageService:SendMessage(messageModel);
    end);
    btnPanic:SetCallback("OnEnter", function(info, event)
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);

        local tooltip = microMenu._tooltipWidget;
    
        tooltip:SetOwner(info.frame, "ANCHOR_TOPRIGHT");

        local name = "Panic button";
        local desc = "Hit your panic button to alert other channel subscribers that you need urgent assistance.";
        local note = "Note: You can also type '/pb' to hit your panic button.";
    
        tooltip:SetText(name, 1, .82, 0, true);
        tooltip:AddLine(desc, 1, 1, 1, true);
        tooltip:AddLine(note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
    
        tooltip:Show();
    end);
    btnPanic:SetCallback("OnLeave", function(info, event)
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
        local tooltip = microMenu._tooltipWidget;     
        tooltip:Hide();
    end);
    notificationConfigFrame:AddChild(btnPanic);

    local btnPlaceholder = self._aceGUI:Create("Button");
    btnPlaceholder:SetRelativeWidth(0.25);
    btnPlaceholder:SetHeight(35);
    btnPlaceholder:SetDisabled(true);
    notificationConfigFrame:AddChild(btnPlaceholder);

    local btnOpenConfigScreen = self._aceGUI:Create("Button");
    btnOpenConfigScreen:SetText([[|TInterface\Addons\GBR-3\Media\Textures\Buttons\Settings.tga:15:15:0:0:128:128:0:128:0:128:255:204:9|t]]);
    btnOpenConfigScreen:SetRelativeWidth(0.25);
    btnOpenConfigScreen:SetHeight(35);
    btnOpenConfigScreen:SetCallback("OnClick", function(info, event)    
        local addonService = GBR_Singletons:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
        InterfaceOptionsFrame_OpenToCategory(addonService.OptionsFrame);
        InterfaceOptionsFrame_OpenToCategory(addonService.OptionsFrame);
    end);
    btnOpenConfigScreen:SetCallback("OnEnter", function(info, event)
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);

        local tooltip = microMenu._tooltipWidget;
    
        tooltip:SetOwner(info.frame, "ANCHOR_TOPRIGHT");

        local name = "Config menu";
        local desc = "Opens the addon configuration menu, where you can change all your settings.";
        local note = "Note: You can also type '/gbr config' to open this menu.";
    
        tooltip:SetText(name, 1, .82, 0, true);
        tooltip:AddLine(desc, 1, 1, 1, true);
        tooltip:AddLine(note, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)

    
        tooltip:Show();
    end);
    btnOpenConfigScreen:SetCallback("OnLeave", function(info, event)
        local microMenu = GBR_Singletons:FetchService(GBR_Constants.SRV_MICROMENU_SERVICE);
        local tooltip = microMenu._tooltipWidget;     
        tooltip:Hide();
    end);
    notificationConfigFrame:AddChild(btnOpenConfigScreen);

    return notificationConfigFrame;

end

function GBR_MicroMenuService:Display()

    if self.isShown then
        return;
    end

    self._window = self:_buildMainFrame();
    self.isShown = true;

end

function GBR_MicroMenuService:_buildFirstTimeUserScreen()

    local welcomeScreen = self._aceGUI:Create("Frame");

    welcomeScreen:SetTitle("You're running GBRadio 3");
    welcomeScreen:SetCallback("OnClose", function(widget) 
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    welcomeScreen:SetWidth(500);
    welcomeScreen:SetHeight(600);
    welcomeScreen:SetLayout("Flow");
    welcomeScreen:EnableResize(false);

    local welcomeHeading = self._aceGUI:Create("Heading");
    welcomeHeading:SetText("Welcome to GBRadio 3, ".. GetUnitName(GBR_Constants.ID_PLAYER) .. "!");
    welcomeHeading:SetRelativeWidth(1);
    welcomeScreen:AddChild(welcomeHeading);

    local welcomeText = self._aceGUI:Create("Label");
    welcomeText:SetFont([[Interface\Addons\GBR-3\Media\Fonts\PT_Sans-Narrow-Regular.ttf]], 14);
    welcomeText:SetText(
        "Hi there, " .. GetUnitName(GBR_Constants.ID_PLAYER) ..". Welcome to GBRadio version 3."
        .."\n\nVersion 3 is a complete rewrite and overhaul of the previous verison, GBRadio 2, and it comes with a plethora of new features aimed at immersion, tools and quality of life improvements.");
    welcomeText:SetRelativeWidth(1);
    welcomeScreen:AddChild(welcomeText);

    local newFeaturesHeading = self._aceGUI:Create("Heading");
    newFeaturesHeading:SetText("New Features");
    newFeaturesHeading:SetRelativeWidth(1);
    welcomeScreen:AddChild(newFeaturesHeading);

    local newFeaturesText = self._aceGUI:Create("Label");
    newFeaturesText:SetFont([[Interface\Addons\GBR-3\Media\Fonts\PT_Sans-Narrow-Regular.ttf]], 14);
    newFeaturesText:SetText(
        "- Brand new sound effects for sending messages, receiving messages, panic button presses and out of range reminders."
        .."\n\n- Incident alert notifications pop up on the screen of your frequency's subscribers. Send them via the new Dispatch menu or via panic buttons, with differing appearance based on incident grades."
        .. "\n\n- Overhauled options menu, allowing you to now configure settings on a per channel basis, rather than globally as before."
        .. "\n\n- Identify yourself and your role when sending messages, with the new channel roles feature."
        .. "\n\n- Customise your characters identity via channel identity options or character config options."
        .. "\n\n- Fed up of people snooping on your frequency through ill-gotten codes? Now you can see exactly who's subscribed to a frequency via the channel admin tab."
        .. "\n\n- Join new channels and leave old ones without having to reload your UI, or turn off individual channels."
        .. "\n\n- A new micro menu that lets you switch channels easily.");
    newFeaturesText:SetRelativeWidth(1);
    welcomeScreen:AddChild(newFeaturesText);

    local needHelpHeading = self._aceGUI:Create("Heading");
    needHelpHeading:SetText("Need help?");
    needHelpHeading:SetRelativeWidth(1);
    welcomeScreen:AddChild(needHelpHeading);

    local needHelpText = self._aceGUI:Create("Label");
    needHelpText:SetFont([[Interface\Addons\GBR-3\Media\Fonts\PT_Sans-Narrow-Regular.ttf]], 14);
    needHelpText:SetText(
        "Need help with anything or have feedback for me? Check out the About page on the settings screen for contact details, or visit Help for a list of commands and links to guides.");
    needHelpText:SetRelativeWidth(1);
    welcomeScreen:AddChild(needHelpText);

end

function GBR_MicroMenuService:DisplayFirstTimeUserScreen()

    self:_buildFirstTimeUserScreen();    
    self._configService:SetIsFirstTimeUser(false);

end