GBR_CommandService = GBR_Object:New();

function GBR_CommandService:New(obj)
    
    self._commandParser = LibStub(GBR_Constants.LIB_ACE_CONSOLE);
    
    self:RegisterMethods();

    return self:RegisterNew(obj);

end

function GBR_CommandService:RegisterMethods()

    self:RegisterCommand(GBR_Constants.CMD_MAIN, self.CommandHandler);
    self:RegisterCommand(GBR_Constants.CMD_DEV_TEST, self.CTesting);
    self:RegisterCommand(GBR_Constants.CMD_SEND_MESSAGE, self.CSendSpeechMessage);
    self:RegisterCommand(GBR_Constants.CMD_SEND_QUIET_MESSAGE, self.CSendSilentSpeechMessage);

end

function GBR_CommandService.CommandHandler(input)

    return nil;

end  

function GBR_CommandService:RegisterCommand(command, method)

    print("[GBR] Registering " .. command);
    self._commandParser:RegisterChatCommand(command, method, true);

end  

--#Region Commands

function GBR_CommandService.CTesting(input)
    
    print("Testing GBR3 Command Service: " .. input);

end

function GBR_CommandService.CSendSpeechMessage(message)

    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
    local playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);

    local messageModel = GBR_SpeechMessageModel:New();

    messageModel.MessageData.CharacterModel = playerService:GetCurrentCharacterModel();
    messageModel.MessageData.Message = message;

    local result = messageService:SendSpeechMessage(messageModel);

end

function GBR_CommandService.CSendSilentSpeechMessage(message)

    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
    local playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);
    
    local messageModel = GBR_SpeechMessageModel:New();

    messageModel.MessageData.CharacterModel = playerService:GetCurrentCharacterModel();
    messageModel.MessageData.Message = message;

    local result = messageService:SendSpeechMessage(messageModel);

end

--#EndRegion Commands