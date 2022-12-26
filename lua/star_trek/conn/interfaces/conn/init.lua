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
--      CONN Interface | Server      --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

SELF.BaseInterface = "bridge_targeting_base"

include("engines.lua")

-- Opening general purpose menus.
function SELF:Open(ent)
	local scale = 30

	local engineControlPos = Vector(-16.1, -0.1, -0.3)
	local engineControlAng = Angle(0, 8.3, 28)
	local middleScreensW = 900
	local middleScreensH = 420

	local viewScreenPos = Vector(-44.25, -7.4, -0.3)
	local viewScreenAng = Angle(0, 22.4, 28)
	local viewScreenW = 610
	local viewScreenH = 420

	local logScreenPos = Vector(-64, -18, -0.3)
	local logScreenAng = Angle(0, 33.5, 28)
	local sideScreensW = 500
	local sideScreensH = 420

	local navigationPos = Vector(engineControlPos)
	local navigationAng = Angle(engineControlAng)
	navigationPos.x = -navigationPos.x
	navigationAng.y = -navigationAng.y

	local mapScreenPos = Vector(43.45, -9.25, 3)
	local mapScreenAng = Angle(0, -22.5, 77)
	local mapScreenW = 680
	local mapScreenH = 400

	local mapControlPos = Vector(logScreenPos)
	local mapControlAng = Angle(logScreenAng)
	mapControlPos.x = -mapControlPos.x
	mapControlAng.y = -mapControlAng.y

	local success1, logWindow = Star_Trek.LCARS:CreateWindow("log_entry", logScreenPos, logScreenAng, scale, sideScreensW, sideScreensH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, false, nil, WINDOW_BORDER_BOTH)
	if not success1 then
		return false, logWindow
	end

	local success2, screenWindow = Star_Trek.LCARS:CreateWindow("button_matrix", viewScreenPos, viewScreenAng, scale, viewScreenW, viewScreenH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Viewscreen", "CAM", WINDOW_BORDER_BOTH)
	if not success2 then
		return false, screenWindow
	end

	local success3, engineControlWindow = Star_Trek.LCARS:CreateWindow("button_matrix", engineControlPos, engineControlAng, scale, middleScreensW, middleScreensH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Engine Control", "ENG", WINDOW_BORDER_BOTH)
	if not success3 then
		return false, engineControlWindow
	end
	self.EngineControlWindow = engineControlWindow

	self:AddEngineSelectionButtons()
	self:SelectEngineMode(self.IMPULSE)

	local stopRow = engineControlWindow:CreateSecondaryButtonRow(32)
	engineControlWindow:AddButtonToRow(stopRow, "Emergency Stop", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function(ply, buttonData)
	end)

	local success4, navigationWindow = Star_Trek.LCARS:CreateWindow("button_matrix", navigationPos, navigationAng, scale, middleScreensW, middleScreensH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Navigation", "NAV", WINDOW_BORDER_BOTH)
	if not success4 then
		return false, navigationWindow
	end

	local success5, mapWindow = Star_Trek.LCARS:CreateWindow("text_entry", mapScreenPos, mapScreenAng, scale, mapScreenW, mapScreenH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, nil, "Map", nil, WINDOW_BORDER_BOTH, {})
	if not success5 then
		return false, mapWindow
	end

	local success6, mapControlWindow = Star_Trek.LCARS:CreateWindow("button_matrix", mapControlPos, mapControlAng, scale, sideScreensW, sideScreensH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Map Control", nil, WINDOW_BORDER_BOTH)
	if not success6 then
		return false, mapControlWindow
	end

	return true, {logWindow, screenWindow, engineControlWindow, navigationWindow, mapWindow, mapControlWindow}, Vector(), Angle(0, 90, 0)
end