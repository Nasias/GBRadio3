GBR_ClosestTransmitterModel = GBR_Object:New();

function GBR_ClosestTransmitterModel:New(obj)

    self.TransmitterModel = nil;
    self.DistanceToTransmitter = nil;
    self.MessageInterferenceType = nil;

    return self:RegisterNew(obj);

end
