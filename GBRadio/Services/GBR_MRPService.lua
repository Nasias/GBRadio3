GBR_MRPService = GBR_Object:New();

function GBR_MRPService:GetPlayerName()
    
    if not self:IsInstalled() then
        return nil;
    end

    return TRP3_API.r.name(GBR_Constants.ID_PLAYER);

end

function GBR_MRPService:GetPlayerColour()

    if not self:IsInstalled() then
        return nil;
    end

    if TRP3_API.profile.getPlayerCurrentProfile().player.characteristics.CH == nil then
        return nil;
    end    

    return "ff"..TRP3_API.profile.getPlayerCurrentProfile().player.characteristics.CH; -- TRP3 doesn't return alpha

end

function GBR_MRPService:IsInstalled()

    if TRP3_API == nil then 
        return false;
    else 
        return true;
    end

end