GBR_ExportableChannelSettingsModel = GBR_Object:New();

function GBR_ExportableChannelSettingsModel:New(obj)

    self.ChannelSettings = {};
    self.InteractionSettings = {};
    self.TransmitterSettings = {};

    return self:RegisterNew(obj);

end
