GBR_Vector3 = GBR_Object:New();

function GBR_Vector3:New(obj)

    GBR_Vector3.X = 0.0;
    GBR_Vector3.Y = 0.0;
    GBR_Vector3.Z = 0.0;

    return self:RegisterNew(obj);

end

function GBR_Vector3:SetVector(x, y, z)

    self.X = x;
    self.Y = y;
    self.Z = z;

end

function GBR_Vector3:GetVector()

    return self.X, self.Y, self.Z;

end

function GBR_Vector3:GetLength()

    return math.sqrt(self.X * self.X + self.Y * self.Y + self.Z * self.Z);

end

function GBR_Vector3:GetLengthSquared()

    return self.X * self.X + self.Y * self.Y + self.Z * self.Z;

end

function GBR_Vector3:GetDistance(otherVector)

    distanceVector = GBR_Vector3:New
    {
        X = self.X - otherVector.X, 
        Y = self.Y - otherVector.Y, 
        Z = self.Z - otherVector.Z
    };

    return distanceVector:GetLength();

end

function GBR_Vector3:GetDistanceSquared(otherVector)

    return math.sqrt(self:GetDistance(otherVector));

end