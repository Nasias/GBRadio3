GBR_CommChannelModelModel = GBR_Object:New();

function GBR_CommChannelModelModel:New(obj)

    self.Name = nil;
    self.Frequency = nil;
    self.DisplayOrder = 0;
    self.OutputWindow = 0;
    self.OutputColour = GBR_ARGB:new(); -- Type:GBR_ARGB.
    self.Active = false;
    self.ShowPlayerNames = false;
    self.ShowTRP3Names = false;
    self.SaySendMessages = false; -- Automatically /say messages as the player speaks in to the comm device.
    self.SaySendEmotes = false; -- Automatically emote usage of the comm device.
    self.SayReceivedEmotes = false; -- Automatically emote the receiving of a message from the comm device.
    self.SayReceivedMessageInEmote = false; -- Add the content of a received message to the message received emote.
    
    self.SendEmotesList = {}; -- Randomly select an emote from this table.
    self.ReceiveEmotesList = {}; -- Randomly select an emote from this table.
    
    self.TransmitterLocationList = {}; -- Type:GBR_Location.
    self.TransmitterModeOn = false;
    self.TransmitterDistortionOn = false;
    self.TransmitterDistortionThreshold = 
    {
        LowDistortionDistance = 0,
        BadDistortionDistance = 0,
        VeryBadDistortionDistance = 0
    };
    self.TrustedPlayerDataSourceList = {}; -- Type:GBR_Player. From whom are we willing to download updated settings from.

    return self:RegisterNew(obj);
    
end
