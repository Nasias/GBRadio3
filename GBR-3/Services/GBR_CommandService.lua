GBR_CommandService = GBR_Object:New();

function GBR_CommandService:New(obj)

    self._commandParser = LibStub(GBR_Constants.LIB_ACE_CONSOLE);

    self:RegisterMethods();

    return self:RegisterNew(obj);

end

function GBR_CommandService:RegisterMethods()

    self:RegisterCommand(GBR_Constants.CMD_MAIN, self.CommandHandler);
    self:RegisterCommand(GBR_Constants.CMD_SEND_MESSAGE, self.CSendSpeechMessage);
    self:RegisterCommand(GBR_Constants.CMD_SEND_QUIET_MESSAGE, self.CSendSilentSpeechMessage);
    self:RegisterCommand(GBR_Constants.CMD_SEND_EMERGENCY_MESSAGE, self.CSendEmergencyMessage);

end

function GBR_CommandService.CommandHandler(input)

    local dispatcherService = GBR_Singletons:FetchService(GBR_Constants.SRV_DISPATCHER_SERVICE);
    local addonService = GBR_Singletons:FetchService(GBR_Constants.SRV_ADDON_SERVICE);

    if input == "dispatch" then
        dispatcherService:DisplayDispatcher();
        return;
    end
    
    InterfaceOptionsFrame_OpenToCategory(addonService.OptionsFrame);
    InterfaceOptionsFrame_OpenToCategory(addonService.OptionsFrame);

end

function GBR_CommandService:RegisterCommand(command, method)

    self._commandParser:RegisterChatCommand(command, method, true);

end

-- #Region Commands

function GBR_CommandService.CSendSpeechMessage(message)

    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);

    local messageModel = GBR_MessageModel:New();

    messageModel.MessageData.Message = message;
    messageModel.MessageData.MessageType = GBR_EMessageType.Speech;

    local result = messageService:SendMessage(messageModel);

end

function GBR_CommandService.CSendSilentSpeechMessage(message)

    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);

    local messageModel = GBR_MessageModel:New();

    messageModel.MessageData.Message = message;
    messageModel.MessageData.MessageType = GBR_EMessageType.SilentSpeech;

    local result = messageService:SendMessage(messageModel);

end

function GBR_CommandService.CSendEmergencyMessage()

    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);

    local messageModel = GBR_MessageModel:New();

    messageModel.MessageData.MessageType = GBR_EMessageType.Emergency;

    local result = messageService:SendMessage(messageModel);

end

-- #EndRegion Commands
