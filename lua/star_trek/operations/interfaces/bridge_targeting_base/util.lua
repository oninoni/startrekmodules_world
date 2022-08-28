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
--    LCARS Targeting Int. | Util    --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

function SELF:CreateLogsWindow()
	if self.ShowLogs then
		local success, logWindow = Star_Trek.LCARS:CreateWindow("log_entry", self.MapWindowPos, self.MapWindowAng, 15, 600, 600,
		function(windowData, interfaceData, ply, categoryId, buttonId)
			-- No Additional Interactivity here.
		end, false, nil, not self.Flipped)
		if not success then
			return false, logWindow
		end

		local sessionData = Star_Trek.Logs:GetSession(self.Ent)
		logWindow:SetSessionData(sessionData)

		return true, logWindow
	else
		local success, mapWindow = Star_Trek.LCARS:CreateWindow("system_map", self.MapWindowPos, self.MapWindowAng, 15, 600, 600,
		function(windowData, interfaceData, ply, buttonId)
			-- No Additional Interactivity here.
		end, nil, not self.Flipped)
		if not success then
			return false, mapWindow
		end

		return true, mapWindow
	end
end