---------------------------------------
---------------------------------------
--         Star Trek Modules         --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2022 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--       Engineering | Server        --
---------------------------------------

Star_Trek.Engineering.Chair = nil
local chairClampRight = nil
local chairClampLeft = nil

hook.Add("InitPostEntity", "Star_Trek.Engineering.SetupChair", function()
    for i, ent in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
        if ent:GetPos() == Star_Trek.Engineering.ChairPos then
            Star_Trek.Engineering.Chair = ent
            chairClampRight = ent:GetAngles() - Angle(0, 90, 0)
            chairClampLeft = ent:GetAngles() + Angle(0, 90, 0)
        end
    end

end)

hook.Add("PostCleanupMap", "Star_Trek.Engineering.SetupChair", function()
    for i, ent in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
        if ent:GetPos() == Star_Trek.Engineering.ChairPos and IsValid(ent) then
            Star_Trek.Engineering.Chair = ent
            chairClampRight = ent:GetAngles() - Angle(0, 90, 0)
            chairClampLeft = ent:GetAngles() + Angle(0, 90, 0)
        end
    end
end)


hook.Add("Think", "Star_Trek.Engineering.ChairThink", function()
    if not IsValid(Star_Trek.Engineering.Chair) or not IsValid(Star_Trek.Engineering.Chair:GetPassenger(1)) or Star_Trek.Engineering.Chair:GetPassenger(1) == NULL then return end
    local ply = Star_Trek.Engineering.Chair:GetPassenger(1)
    if ply:KeyDown(IN_MOVELEFT) then
        local newAngle = Star_Trek.Engineering.Chair:GetAngles() + Angle(0, 1, 0)
        if newAngle.yaw >= chairClampLeft.yaw then return end
        Star_Trek.Engineering.Chair:SetAngles(newAngle)
    elseif ply:KeyDown(IN_MOVERIGHT) then
        local newAngle = Star_Trek.Engineering.Chair:GetAngles() - Angle(0, 1, 0)
        if newAngle.yaw <= chairClampRight.yaw then return end
        Star_Trek.Engineering.Chair:SetAngles(newAngle)
    end

end)
