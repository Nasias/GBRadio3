GBR_ConfigService = GBR_Object:New();

function GBR_ConfigService:RegisterConfiguration()

    --self.Config = LibStub("AceDB-3.0"):New("GBRadioConfiguration", )

end

function GBR_ConfigService:GetCommunicationFrequencies()



end

function GBR_ConfigService:GetAddonChannelPrefix()
    
    return GBR_Constants.ADDON_CHANNEL_PREFIX;

end

function GBR_ConfigService:GetCharacterGender()

    --We want to return a user customisable gender here, but for now
    --use this method.
    return UnitSex(GBR_Constants.ID_PLAYER);

end