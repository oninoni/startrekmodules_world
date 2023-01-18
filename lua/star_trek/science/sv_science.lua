local sciencechair = nil
local chairClampRight = nil
local chairClampLeft = nil

Star_Trek.Science.ChairPos = Star_Trek.Science.ChairPos or Vector(-212, -236, 13328)

hook.Add("Star_Trek.LCARS.PreOpenInterface", "Star_Trek.Navigation.BlockView", function(ent, interfaceName)
    if interfaceName ~= "basic" then return end

    local name = ent:GetName()
    if string.StartWith(name, "connBut") then return true end
    if name == "bridgeViewscreenButton2" then return true end
end)


hook.Add("PlayerEnteredVehicle", "Star_Trek.Science.OppenConsole", function(ply, veh)

    local vehPos = veh:GetPos()

    if vehPos == Star_Trek.Science.ChairPos then
        Star_Trek.LCARS:OpenInterface(ply, Star_Trek.Science.Button, "science")
    end

end)

hook.Add("PlayerLeaveVehicle", "Star_Trek.Science.FixMouse", function(ply, veh)

    local vehPos = veh:GetPos()
    if vehPos == Star_Trek.Science.ChairPos then
        Star_Trek.LCARS:SetScreenClicker(ply, false, true)
    end
end)


hook.Add("InitPostEntity", "Star_Trek.Science.SetupChair", function()
    for i, ent in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
        if ent:GetPos() == Star_Trek.Science.ChairPos then
            sciencechair = ent
            chairClampRight = ent:GetAngles() - Angle(0, 90, 0)
            chairClampLeft = ent:GetAngles() + Angle(0, 90, 0)
        end
    end

end)

hook.Add("PostCleanupMap", "Star_Trek.Science.SetupChair", function()
    for i, ent in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
        if ent:GetPos() == Star_Trek.Science.ChairPos then
            sciencechair = ent
            chairClampRight = ent:GetAngles() - Angle(0, 90, 0)
            chairClampLeft = ent:GetAngles() + Angle(0, 90, 0)
        end
    end
end)

hook.Add("Think", "Star_Trek.Science.ChairThink", function()
    if sciencechair == nil or sciencechair:GetPassenger(1) == NULL then return end

    local ply = sciencechair:GetPassenger(1)
    if ply:KeyDown(IN_MOVELEFT) then
        local newAngle = sciencechair:GetAngles() + Angle(0, 1, 0)
        if newAngle.yaw >= chairClampLeft.yaw then return end
        sciencechair:SetAngles(newAngle)
    elseif ply:KeyDown(IN_MOVERIGHT) then
        local newAngle = sciencechair:GetAngles() - Angle(0, 1, 0)
        if newAngle.yaw <= chairClampRight.yaw then return end
        sciencechair:SetAngles(newAngle)
    end

end)