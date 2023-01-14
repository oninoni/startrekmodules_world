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
--    Copyright © 2020 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--            World Entity           --
--           Base | Shared           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

SELF.BaseClass = nil

SELF.Dynamic = false

function SELF:Think(deltaT)
end

function SELF:GetOrbit(r, d)
	d = d or math.random(0, 360)
	local dir = Angle(d, 0, 0):Forward()
	local worldDir = WorldVector(0, 0, 0, dir.x, dir.z, 0)

	return self.Pos + worldDir * r
end

function SELF:GetStandardOrbit()
	return self:GetOrbit(self.Diameter * Star_Trek.World.StandardOrbitMultiplier)
end