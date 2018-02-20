GBR_ARGB = GBR_Object:New();

function GBR_ARGB:New(obj)

    self.A = 0.0;
    self.R = 0.0;
    self.G = 0.0;
    self.B = 0.0;

    return self:RegisterNew(obj);

end

function GBR_ARGB:GetAsHex()

    return  GBR_Converter.ColourToHex(A),
            GBR_Converter.ColourToHex(R),
            GBR_Converter.ColourToHex(G),
            GBR_Converter.ColourToHex(B);

end

function GBR_ARGB:GetAsHexString()

    return table.concat { self:GetAsHex() };

end

function GBR_ARGB:GetEscapedHexString()

    return GBR_Constants.UI_COLOUR_ESCAPE_STRING .. self:GetAsHexString();

end