GBR_MRPService = GBR_Object:New();

function GBR_MRPService:GetPlayerName()

    if TPR3_API == nil then 
        return nil;
    end

    return TRP3_API.r.name(GBR_Constants.ID_PLAYER);

end