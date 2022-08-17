GBR_SerialiserService = GBR_Object:New();

function GBR_SerialiserService:New(obj)

    self._serialiser = LibStub(GBR_Constants.LIB_ACE_SERIALISER);

    return self:RegisterNew(obj);

end

function GBR_SerialiserService:Serialize(object)

    return self._serialiser:Serialize(object);

end

function GBR_SerialiserService:Deserialize(serializedObject)

    local result, object = self._serialiser:Deserialize(serializedObject);

    return object;

end