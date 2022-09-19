LEASuite_MRPService = LEASuite_Object:New();

function LEASuite_MRPService:GetPlayerName()
    
    if not self:IsInstalled() then
        return nil;
    end

    return TRP3_API.r.name(LEASuite_Constants.ID_PLAYER);

end

function LEASuite_MRPService:GetPlayerColour()

    if not self:IsInstalled() then
        return nil;
    end

    if TRP3_API.profile.getPlayerCurrentProfile().player.characteristics.CH == nil then
        return nil;
    end    

    return "ff"..TRP3_API.profile.getPlayerCurrentProfile().player.characteristics.CH; -- TRP3 doesn't return alpha

end

function LEASuite_MRPService:IsInstalled()

    if TRP3_API == nil then 
        return false;
    else 
        return true;
    end

end

function LEASuite_MRPService:GetTargetProfile()

    if not TRP3_API then return nil; end;

    if not UnitName(LEASuite_Constants.ID_TARGET) then return nil; end;

    local playerId = TRP3_API.utils.str.getUnitID(LEASuite_Constants.ID_PLAYER);
    local targetId = TRP3_API.utils.str.getUnitID(LEASuite_Constants.ID_TARGET);
    
    local targetIsCurrentPlayer = targetId == playerId;

    if not targetIsCurrentPlayer and not TRP3_API.register.isUnitIDKnown(targetId) then
        return nil; 
    end

    local characterData = not targetIsCurrentPlayer 
        and TRP3_API.register.getUnitIDProfile(targetId)
        or TRP3_API.profile.getPlayerCurrentProfile().player;

    local unitSex = UnitSex(LEASuite_Constants.ID_TARGET);
    local unitName, _ = UnitName(LEASuite_Constants.ID_TARGET);

    characterData.characteristics._CUSTOM_CN = unitName;

    if unitSex == 2 then
        characterData.characteristics._CUSTOM_SE = "Male";
    elseif unitSex == 3 then
        characterData.characteristics._CUSTOM_SE = "Female";
    else
        characterData.characteristics._CUSTOM_SE = "Unknown";
    end

    return characterData.characteristics;

end