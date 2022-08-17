GBR_ARGB = GBR_Object:New();

function GBR_ARGB:New(obj)

    self.A = 0.0;
    self.R = 0.0;
    self.G = 0.0;
    self.B = 0.0;

    return self:RegisterNew(obj);

end

function GBR_ARGB:NewFromHex(hexString)

    local a = strsub(hexString, 1, 2);
    local r = strsub(hexString, 3, 4);
    local g = strsub(hexString, 5, 6);
    local b = strsub(hexString, 7, 8);

    self.A = tonumber(a, 16);
    self.R = tonumber(r, 16);
    self.G = tonumber(g, 16);
    self.B = tonumber(b, 16);
    
    return self:RegisterNew(obj);

end

function GBR_ARGB:ToHex()

    return  GBR_Converter.ColourToHex(self.A),
            GBR_Converter.ColourToHex(self.R),
            GBR_Converter.ColourToHex(self.G),
            GBR_Converter.ColourToHex(self.B);

end

function GBR_ARGB:ToHexString()

    return table.concat { self:ToHex() };

end

function GBR_ARGB:ToEscapedHexString()

    return GBR_Constants.UI_COLOUR_ESCAPE_STRING .. self:GetAsHexString();

end