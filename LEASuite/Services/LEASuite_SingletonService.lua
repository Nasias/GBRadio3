LEASuite_SingletonService = LEASuite_Object:New();

function LEASuite_SingletonService:New(obj)

    self._serviceRegister =
    {
        [LEASuite_Constants.SRV_COMMAND_SERVICE] = LEASuite_CommandService,
        [LEASuite_Constants.SRV_MRP_SERVICE] = LEASuite_MRPService,
        [LEASuite_Constants.SRV_PLAYER_SERVICE] = LEASuite_PlayerService,
        [LEASuite_Constants.SRV_REPORT_SERVICE] = LEASuite_ReportService,
        [LEASuite_Constants.SRV_RECORDER_SERVICE] = LEASuite_RecorderService,
        [LEASuite_Constants.SRV_CHARACTER_DESCRIPTION_SERVICE] = LEASuite_CharacterDescriptionService,
    };

    self._instantiatedServices = {};

    return self:RegisterNew(obj);

end

function LEASuite_SingletonService:FetchService(service)

    if service == nil then
        return nil; 
    end

    if self._instantiatedServices[service] == nil then

        self:InstantiateService(service);

    end

    return self._instantiatedServices[service];

end

function LEASuite_SingletonService:InstantiateService(service)

    self._instantiatedServices[service] = self._serviceRegister[service]:New();
    return self._instantiatedServices[service];

end

function LEASuite_SingletonService:RegisterManualService(service, serviceReference)

    if self._instantiatedServices[service] == nil then
    
        self._instantiatedServices[service] = serviceReference;
        return self._instantiatedServices[service];
    
    end
    
    return nil;

end