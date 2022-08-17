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
    self:RegisterCommand(GBR_Constants.CMD_TEST_RECEIVE_MESSAGE, self.CTestRecieveMessage);

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

function GBR_CommandService.CTestRecieveMessage(message)
    
    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
    local playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);

    local messageModel = GBR_MessageModel:New{
        MessageData = {
            CharacterModel = playerService:GetCurrentCharacterModel(),
            Message = message,
            MessageType = GBR_EMessageType.Speech,
        }
    };

    messageModel.MessageData.CharacterModel.CharacterGender = 2;

    messageService:ReceiveMessage(messageModel);

end

function GBR_CommandService.CSendSpeechMessage(message)

    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);

    local messageModel = GBR_MessageModel:New();

    messageModel.MessageData.Message = message;
    messageModel.MessageType = GBR_EMessageType.Speech;

    local result = messageService:SendMessage(messageModel);

end

function GBR_CommandService.CSendSilentSpeechMessage(message)

    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
    
    local messageModel = GBR_MessageModel:New();

    messageModel.MessageData.Message = message;
    messageModel.MessageType = GBR_EMessageType.SilentSpeech;

    local result = messageService:SendMessage(messageModel);

end

function GBR_CommandService.CSendPanicButtonMessage()

    local messageService = GBR_Singletons:FetchService(GBR_Constants.SRV_MESSAGE_SERVICE);
    
    local messageModel = GBR_MessageModel:New();

    messageModel.MessageType = GBR_EMessageType.Emergency;

    local result = messageService:SendMessage(messageModel);

end

--#EndRegion Commands