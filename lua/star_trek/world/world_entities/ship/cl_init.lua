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
--           Ship | Client           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Update()
	SELF.Base.Update(self)

	local activeManeuver = self.ActiveManeuver
	if istable(activeManeuver) then
		self:FixManeuverData(activeManeuver)
	end
end

function SELF:FixManeuverData(activeManeuver)
	if activeManeuver.Type == "WARP" then
		WorldVectorFromTable(activeManeuver.StartPos)
		WorldVectorFromTable(activeManeuver.EndPos)
		WorldVectorFromTable(activeManeuver.AccelPos)
		WorldVectorFromTable(activeManeuver.DeccelPos)

		return
	elseif activeManeuver.Type == "ALIGN" then
		-- No Conversion Needed.

		return
	elseif maneuverType == "IMPULSE" then
		-- TODO

		return
	end
end