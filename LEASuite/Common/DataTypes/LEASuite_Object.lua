--[[
    This is the ultimate parent object that's inherited by all other objects.
 ]]

 LEASuite_Object = {};

--[[ Summary: Creates a new instance of an object ]]
function LEASuite_Object:New(obj)

    return self:RegisterNew(obj);

end

function LEASuite_Object:RegisterNew(obj)

    obj = obj or {};
    setmetatable(obj, self);
    self.__index = self;

    return obj;
    
end

--[[ Summary: Returns a reference to a copy of this object ]]
function LEASuite_Object:Clone(seen)

    if type(self) ~= "table" then return self end;
    if seen and seen[self] then return seen[self] end;

    local s = seen or {};
    local res = setmetatable({}, getmetatable(self));

    s[self] = res;

    for k, v in pairs(self) do 
        res[LEASuite_Object.Clone(k, s)] = LEASuite_Object.Clone(v, s);
    end

    return res;
  
end