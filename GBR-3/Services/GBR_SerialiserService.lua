GBR_SerialiserService = GBR_Object:New();

function GBR_SerialiserService:New(obj)

    self.Serialiser = LibStub(GBR_Constants.LIB_ACE_SERIALISER);

    return self:RegisterNew(obj);

end

function GBR_SerialiserService:Serialise(object)



end