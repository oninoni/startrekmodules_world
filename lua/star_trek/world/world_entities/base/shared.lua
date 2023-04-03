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

-- Get the position of an entity in orbit around this entity.
--
-- @param Number r
-- @param Vector dir
-- @return Vector pos
function SELF:GetOrbitPos(r, dir)
	print("---", r, dir)

	if not isvector(dir) then
		local dirAng = Angle(0 , math.random(0, 360), 0)
		dir = dirAng:Forward()
	end

	pos = self.Pos
	if isvector(self.OrbitOffset) or IsWorldVector(self.OrbitOffset) then
		pos = LocalToWorldBig(self.OrbitOffset, Angle(), self.Pos, self.Ang)
	end

	return Star_Trek.World:GetOrbitPos(pos, dir, r)
end

-- Get the position of an entity in standard orbit around this entity.
--
-- @param? Vector dir
-- @return Vector pos
function SELF:GetStandardOrbit(dir)
	return self:GetOrbitPos(self.Diameter * 0.5 * Star_Trek.World.StandardOrbitMultiplier, dir)
end