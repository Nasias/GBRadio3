GBR_MicroMenuService = GBR_Object:New();

function GBR_MicroMenuService:New(obj)

    self._aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._tooltipWidget = self._tooltipWidget or CreateFrame("GameTooltip", "GBRadioMicroMenuTooltip", UIParent, "SharedTooltipTemplate");
    self._window = nil;
    self.isShown = false;

    return self:RegisterNew(obj);

end

function GBR_MicroMenuService:RefreshChannels()

    if self._window == nil then
        return;
    end

    local channels = self._configService:GetRegisteredCommunicationFrequencies();
    local channelDropdownValues = {};
    for k,v in pairs(channels) do
        channelDropdownValues[k] = GBR_ConfigService.GetChannelGroupName(v.IsEnabled, v.ChannelName, k);
    end

    self._window.ChannelSelector:SetList(channelDropdownValues);
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
        configService:SetMenuIsOpen(false);

        aceGUI:Release(widget);
        microMenu._window = nil;
        microMenu.isShown = false;

    end);
    notificationConfigFrame:SetWidth(250);
    notificationConfigFrame:SetHeight(115);
    notificationConfigFrame:SetLayout("Flow");
    notificationConfigFrame:EnableResize(false);

    if lastPosition.X  ~= nil and lastPosition.Y ~= nil then
        notificationConfigFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", lastPosition.X, lastPosition.Y);
    end

    ------------------------------------------------------

    local channelSelector = self._aceGUI:Create("Dropdown");
    channelSelector:SetValue(self._configService:GetPrimaryFrequency());
    channelSelector:SetRelativeWidth(1);
    channelSelector:SetCallback("OnValueChanged", function(info, event, key)

        local configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
        configService:SetPrimaryFrequency(key);

    end);
    channelSelector:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);

        tooltipService:ShowTooltip(
            info.frame,
            "Channel",
            "Select the primary channel that your device will use to send messages.",
            "Note: The primary channel is where all messages sent with '/bb', '/wbb' and '/pb' will be sent. You always pick up messages from other channels regardless of this setting."
        );

    end);
    channelSelector:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    notificationConfigFrame:AddChild(channelSelector);
    notificationConfigFrame.ChannelSelector = channelSelector;

    ------------------------------------------------------

    local btnPanic = self._aceGUI:Create("Button");
    btnPanic:SetText([[|TInterface\Addons\GBRadio\Media\Textures\Buttons\Panic.tga:15:15:0:0:128:128:0:128:0:128:255:255:255|t]]);
    btnPanic:SetRelativeWidth(0.25);
    btnPanic:SetHeight(35);
    btnPanic:SetCallback("OnClick", function(info, event)

        local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
        local messageModel = GBR_MessageModel:New();  

        messageModel.MessageData.MessageType = GBR_EMessageType.Emergency;    
        messageService:SendMessage(messageModel);

    end);
    btnPanic:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Panic button",
            "Hit your panic button to alert other channel subscribers that you need urgent assistance.",
            "Quick command: /pb"
        );

    end);
    btnPanic:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    notificationConfigFrame:AddChild(btnPanic);

    ------------------------------------------------------

    local btnOpenDispatcher = self._aceGUI:Create("Button");
    btnOpenDispatcher:SetText([[|TInterface\Addons\GBRadio\Media\Textures\Buttons\Dispatch.tga:15:15:0:0:128:128:0:128:0:128:255:204:9|t]]);
    btnOpenDispatcher:SetRelativeWidth(0.25);
    btnOpenDispatcher:SetHeight(35);
    btnOpenDispatcher:SetCallback("OnClick", function(info, event)

        local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
        dispatcherService:DisplayDispatcher();

    end);
    btnOpenDispatcher:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:ShowTooltip(
            info.frame,
            "Dispatcher menu",
            "Opens the dispatcher menu, where you can send notificaitons to other channel subscribers.",
            "Quick command: /gbr dispatch"
        );

    end);
    btnOpenDispatcher:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

    end);
    notificationConfigFrame:AddChild(btnOpenDispatcher);

    ------------------------------------------------------

    local btnViewHistory = self._aceGUI:Create("Button");
    btnViewHistory:SetDisabled(true);
    btnViewHistory:SetRelativeWidth(0.25);
    btnViewHistory:SetHeight(35);
    notificationConfigFrame:AddChild(btnViewHistory);

    local btnOpenConfigScreen = self._aceGUI:Create("Button");
    btnOpenConfigScreen:SetText([[|TInterface\Addons\GBRadio\Media\Textures\Buttons\Settings.tga:15:15:0:0:128:128:0:128:0:128:255:204:9|t]]);
    btnOpenConfigScreen:SetRelativeWidth(0.25);
    btnOpenConfigScreen:SetHeight(35);
    btnOpenConfigScreen:SetCallback("OnClick", function(info, event) 

        local addonService = GBR_Singletons:FetchService(GBR_Constants.SRV_ADDON_SERVICE);
        Settings.OpenToCategory(addonService.OptionsFrameID);

    end);
    btnOpenConfigScreen:SetCallback("OnEnter", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        
        tooltipService:ShowTooltip(
            info.frame,
            "Config menu",
            "Opens the addon configuration menu, where you can change all your settings.",
            "Quick command: /gbr config"
        );

    end);
    btnOpenConfigScreen:SetCallback("OnLeave", function(info, event)

        local tooltipService = GBR_Singletons:FetchService(GBR_Constants.SRV_TOOLTIP_SERVICE);
        tooltipService:HideTooltip();

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
    self._configService:SetMenuIsOpen(true);
    self:RefreshChannels();

end

function GBR_MicroMenuService:_buildFirstTimeUserScreen()

    local welcomeScreen = self._aceGUI:Create("Frame");

    welcomeScreen:SetTitle("You're running GBRadio 3");
    welcomeScreen:SetCallback("OnClose", function(widget) 
        local aceGUI = LibStub(GBR_Constants.LIB_ACE_GUI);
        aceGUI:Release(widget);
    end);

    welcomeScreen:SetWidth(550);
    welcomeScreen:SetHeight(600);
    welcomeScreen:SetLayout("Flow");
    welcomeScreen:EnableResize(false);

    local welcomeHeading = self._aceGUI:Create("Heading");
    welcomeHeading:SetText("Welcome to GBRadio 3, ".. GetUnitName(GBR_Constants.ID_PLAYER) .. "!");
    welcomeHeading:SetRelativeWidth(1);
    welcomeScreen:AddChild(welcomeHeading);

    local welcomeText = self._aceGUI:Create("Label");
    welcomeText:SetFontObject(GameFontNormal);
    welcomeText:SetText(
        "Hi there, " .. GetUnitName(GBR_Constants.ID_PLAYER) ..". Welcome to GBRadio version 3."
        .."\n\nVersion 3 is a complete rewrite and overhaul of the previous verison, GBRadio 2, and it comes with a plethora of new features aimed at immersion, tools and quality of life improvements."
        .."\n\nNote that your old settings won't work here. You'll need to set up your old channel and configure your addon again. Sorry about that.");
    welcomeText:SetRelativeWidth(1);
    welcomeScreen:AddChild(welcomeText);

    local newFeaturesHeading = self._aceGUI:Create("Heading");
    newFeaturesHeading:SetText("New Features");
    newFeaturesHeading:SetRelativeWidth(1);
    welcomeScreen:AddChild(newFeaturesHeading);

    local newFeaturesText = self._aceGUI:Create("Label");
    newFeaturesText:SetFontObject(GameFontNormal);
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
    needHelpText:SetFontObject(GameFontNormal);
    needHelpText:SetText(
        "Need help with anything or have feedback for me? Check out the About page on the settings screen for contact details, or visit Help for a list of commands and links to guides or alternatively, consult the GBRadio 3 wiki for useful help topics");
    needHelpText:SetRelativeWidth(1);
    welcomeScreen:AddChild(needHelpText);

    local wikiLink = self._aceGUI:Create("EditBox");
    wikiLink:SetLabel("GBRadio 3 Wiki");
    wikiLink:SetText("https://github.com/Nasias/GBRadio3/wiki/");
    wikiLink:DisableButton(true);
    wikiLink:SetRelativeWidth(1);
    welcomeScreen:AddChild(wikiLink);


end

function GBR_MicroMenuService:DisplayFirstTimeUserScreen()

    self:_buildFirstTimeUserScreen();    
    self._configService:SetIsFirstTimeUser(false);

end