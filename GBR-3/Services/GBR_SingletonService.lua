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
        [GBR_Constants.SRV_NOTIFICATION_SERVICE] = GBR_NotificationService,
        [GBR_Constants.SRV_HOOK_SERVICE] = GBR_HookService,
        [GBR_Constants.SRV_HYPERLINK_SERVICE] = GBR_HyperlinkService,
        [GBR_Constants.SRV_ROLE_SERVICE] = GBR_RoleService,
        [GBR_Constants.SRV_DISPATCHER_SERVICE] = GBR_DispatcherService,
        [GBR_Constants.SRV_MICROMENU_SERVICE] = GBR_MicroMenuService,
    };

    self._instantiatedServices = {};

    return self:RegisterNew(obj);

end

function GBR_SingletonService:FetchService(service)

    if service == nil then
        return nil; 
    end

    if self._instantiatedServices[service] == nil then

        self:InstantiateService(service);

    end

    return self._instantiatedServices[service];

end

function GBR_SingletonService:InstantiateService(service)

    self._instantiatedServices[service] = self._serviceRegister[service]:New();
    return self._instantiatedServices[service];

end

function GBR_SingletonService:RegisterManualService(service, serviceReference)

    if self._instantiatedServices[service] == nil then
    
        self._instantiatedServices[service] = serviceReference;
        return self._instantiatedServices[service];
    
    end
    
    return nil;

end