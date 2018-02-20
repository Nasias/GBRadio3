GBR_MessageService = GBR_Object:New();

function GBR_MessageService:New(obj)

    self._communicationLib = LibStub(GBR_Constants.LIB_ACE_COMM);

    self._serialiserService = GBR_Singletons:FetchService(GBR_Constants.SRV_SERIALISER_SERVICE);
    self._configService = GBR_Singletons:FetchService(GBR_Constants.SRV_CONFIG_SERVICE);
    self._historyService = GBR_Singletons:FetchService(GBR_Constants.SRV_HISTORY_SERVICE);
    self._playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);
    self._locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);
    
    self.MessageQueue = {};

    --self.RegisterAddonChannel();

    return self:RegisterNew(obj);

end

function GBR_MessageService:RegisterAddonChannel()

    self._communicationLib:RegisterComm(self._configService:GetAddonChannelPrefix(), self.ReceiveMessage);

end

function GBR_MessageService:SendMessage(messageModel)

    --self._communicationSerice:SendCommMessage();
    if messageModel.MessageType == GBR_EMessageType.Speech then
        self:SendSpeechMessage(messageModel);
    end

end

function GBR_MessageService.ReceiveMessage(frequency, data, method, senderName)

    local serialiserService = GBR_Singletons:FetchService(GBR_Constants.SRV_SERIALISER_SERVICE);
    local historyService = GBR_Singletons:FetchService(GBR_Constants.SRV_HISTORY_SERVICE);
    local playerService = GBR_Singletons:FetchService(GBR_Constants.SRV_PLAYER_SERVICE);
    local locationService = GBR_Singletons:FetchService(GBR_Constants.SRV_LOCATION_SERVICE);

    local messageData = self._serialiserService:Deserialize(data);

end

function GBR_MessageService:SendSpeechMessage(messageModel)

    print(messageModel.MessageData.Message);
    print(messageModel.MessageData.CharacterModel.CharacterName);
    print(messageModel.MessageData.CharacterModel.CharacterGender);
    print(messageModel.MessageData.CharacterModel.Location.Zone);
    print(messageModel.MessageData.CharacterModel.Location.SubZone);
    print(messageModel.MessageData.CharacterModel.Location.Position.X);
    print(messageModel.MessageData.CharacterModel.Location.Position.Y);

end