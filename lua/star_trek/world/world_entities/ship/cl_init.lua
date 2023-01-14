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

function SELF:Init(clientData)
	SELF.Base.Init(self, clientData)
end

function SELF:Think(deltaT)
	SELF.Base.Think(self, deltaT)

	-- Think hook for executing maneuvers.
	local maneuverData = self.ActiveManeuver
	if maneuverData then
		self:ManeuverThink(maneuverData)
	end
end

function SELF:FixManeuverData(activeManeuver)
	if activeManeuver.Type == "WARP" then
		WorldVectorFromTable(activeManeuver.StartPos)
		WorldVectorFromTable(activeManeuver.EndPos)
		WorldVectorFromTable(activeManeuver.AccelPos)
		WorldVectorFromTable(activeManeuver.DeccelPos)
	elseif activeManeuver.Type == "ALIGN" then
		return
	end
end

function SELF:SetDynData(clientData)
	SELF.Base.SetDynData(self, clientData)

	local activeManeuver = clientData.ActiveManeuver
	self.ManeuverStart = clientData.ManeuverStart

	if istable(activeManeuver) then
		self:FixManeuverData(activeManeuver)
	end

	self.ActiveManeuver = activeManeuver
end