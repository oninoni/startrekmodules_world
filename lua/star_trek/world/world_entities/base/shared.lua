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

SELF.Solid = true

function SELF:Think(sysTime, deltaT)
end

function SELF:GetOrbit(r, d)
	if d == nil then
		d = math.random(0, 360)
	end

	local pos = self.Pos
	if isvector(self.OrbitOffset) or IsWorldVector(self.OrbitOffset) then
		pos = LocalToWorldBig(self.OrbitOffset, Angle(), self.Pos, self.Ang)
	end

	return LocalToWorldBig(Vector(r, 0, 0), Angle(), pos, Angle(0, d, 0))
end

function SELF:GetStandardOrbit(d)
	return self:GetOrbit(self.Diameter * 0.5 * Star_Trek.World.StandardOrbitMultiplier, d)
end