GBRadio = {};
GBR_Singletons = nil;

-- Manually execute this method for now
function GBRadio:Initialized()

    -- # Begin Globals
    GBR_Singletons = GBR_SingletonService:New();
    -- # End Globals
    
    local commandService = GBR_Singletons:FetchService(GBR_Constants.SINGLETON_SERVICE);

end