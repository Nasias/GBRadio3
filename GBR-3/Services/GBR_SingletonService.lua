GBR_SingletonService = GBR_Object:New();

function GBR_SingletonService:New(obj)

    self._serviceRegister = 
    {
        [GBR_Constants.SRV_COMMAND_SERVICE] = GBR_CommandService,
        [GBR_Constants.SRV_CONFIG_SERVICE] = GBR_ConfigService,
        [GBR_Constants.SRV_HISTORY_SERVICE] = GBR_HistoryService,
        [GBR_Constants.SRV_LOCATION_SERVICE] = GBR_LocationService,
        [GBR_Constants.SRV_MESSAGE_SERVICE] = GBR_MessageService,
        [GBR_Constants.SRV_MRP_SERVICE] = GBR_MRPService,
        [GBR_Constants.SRV_PLAYER_SERVICE] = GBR_PlayerService,
        [GBR_Constants.SRV_SERIALISER_SERVICE] = GBR_SerialiserService,
    };

    self._instantiatedServices = {};

    return self:RegisterNew(obj);

end

function GBR_SingletonService:FetchService(service)

    if service == nil then
        return nil; 
    end

    if self._instantiatedServices[service] == nil then

        return self:InstantiateService(service);

    end

    return self._instantiatedServices[service];

end

function GBR_SingletonService:InstantiateService(service)

    if self._serviceRegister[service] ~= nil then

        self._instantiatedServices[service] = self._serviceRegister[service]:New();
        return self._instantiatedServices[service];

    end

    return nil;

end