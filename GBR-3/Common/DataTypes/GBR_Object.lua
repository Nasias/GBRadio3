--[[
    This is the ultimate parent object that's inherited by all other objects.
 ]]

GBR_Object = {};

--[[ Summary: Creates a new instance of an object ]]
function GBR_Object:New(obj)

    return self:RegisterNew(obj);

end

function GBR_Object:RegisterNew(obj)

    obj = obj or {};
    setmetatable(obj, self);
    self.__index = self;

    return obj;
    
end

--[[ Summary: Returns a reference to a copy of this object ]]
function GBR_Object:Clone(seen)

    if type(self) ~= "table" then return self end;
    if seen and seen[self] then return seen[self] end;

    local s = seen or {};
    local res = setmetatable({}, getmetatable(self));

    s[self] = res;

    for k, v in pairs(self) do 
        res[GBR_Object.Clone(k, s)] = GBR_Object.Clone(v, s);
    end

    return res;
  
end