LEASuite_CommandService = LEASuite_Object:New();

function LEASuite_CommandService:New(obj)

    self._commandParser = LibStub(LEASuite_Constants.LIB_ACE_CONSOLE);

    self:RegisterMethods();

    return self:RegisterNew(obj);

end

function LEASuite_CommandService:RegisterMethods()

    self:RegisterCommand(LEASuite_Constants.CMD_MAIN, self.CommandHandler);

end

function LEASuite_CommandService.CommandHandler(input)

    local recorderService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_RECORDER_SERVICE);
    local reportService = LEASuite_Singletons:FetchService(LEASuite_Constants.SRV_REPORT_SERVICE);

    if input == "record" then
        recorderService:ShowRecorderWindow();
    else        
        reportService:ShowLeaSuiteWindow();
    end
    
end

function LEASuite_CommandService:RegisterCommand(command, method)

    self._commandParser:RegisterChatCommand(command, method, true);

end

-- #EndRegion Commands
