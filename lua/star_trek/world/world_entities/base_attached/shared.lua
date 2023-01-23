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
--       Base Attached | Shared      --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

SELF.BaseClass = "base"

SELF.Dynamic = true

function SELF:Think(sysTime, deltaT)
	local parentEnt = self.ParentEnt
	if not istable(parentEnt) then return end

	self.Pos, self.Ang = LocalToWorldBig(self.OffsetPos, self.OffsetAng, parentEnt.Pos, parentEnt.Ang)
end