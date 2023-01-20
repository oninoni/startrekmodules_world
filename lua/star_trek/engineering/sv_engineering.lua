local engineeringchair = nil
local chairClampRight = nil
local chairClampLeft = nil

hook.Add("InitPostEntity", "Star_Trek.Engineering.SetupChair", function()
    for i, ent in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
        if ent:GetPos() == Star_Trek.Engineering.ChairPos then
            engineeringchair = ent
            chairClampRight = ent:GetAngles() - Angle(0, 90, 0)
            chairClampLeft = ent:GetAngles() + Angle(0, 90, 0)
        end
    end

end)

hook.Add("PostCleanupMap", "Star_Trek.Engineering.SetupChair", function()
    for i, ent in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
        if ent:GetPos() == Star_Trek.Engineering.ChairPos and IsValid(ent) then
            engineeringchair = ent
            chairClampRight = ent:GetAngles() - Angle(0, 90, 0)
            chairClampLeft = ent:GetAngles() + Angle(0, 90, 0)
        end
    end
end)


hook.Add("Think", "Star_Trek.Engineering.ChairThink", function()
    if not IsValid(engineeringchair) or not IsValid(engineeringchair:GetPassenger(1)) or engineeringchair:GetPassenger(1) == NULL then return end
    local ply = engineeringchair:GetPassenger(1)
    if ply:KeyDown(IN_MOVELEFT) then
        local newAngle = engineeringchair:GetAngles() + Angle(0, 1, 0)
        if newAngle.yaw >= chairClampLeft.yaw then return end
        engineeringchair:SetAngles(newAngle)
    elseif ply:KeyDown(IN_MOVERIGHT) then
        local newAngle = engineeringchair:GetAngles() - Angle(0, 1, 0)
        if newAngle.yaw <= chairClampRight.yaw then return end
        engineeringchair:SetAngles(newAngle)
    end

end)


concommand.Add("scanent", function(ply)

    ent = ply:GetEyeTrace().Entity
    print("Name: ",  ent:GetName())
    print("Class: ",  ent:GetClass())
    print("Position: ", ent:GetPos())
    print("Angle: ",  ent:GetAngles())
    for k,v in pairs(ent:GetTable()) do
        print(k, v)
    end

end)