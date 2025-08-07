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

include("viewscreen.lua")
include("engines.lua")
include("navigation.lua")

-- Opening general purpose menus.
function SELF:Open(ent)
	local scale = 30

	local viewScreenPos = Vector(-64, -18, -0.3)
	local viewScreenAng = Angle(0, 33.5, 28)
	local sideScreensW = 500
	local sideScreensH = 420

	-- Create View Screen Control.
	local success1, screenWindow = self:CreateViewScreenControl(viewScreenPos, viewScreenAng, scale, sideScreensW, sideScreensH)
	if not success1 then
		return false, screenWindow
	end

	local logScreenPos = Vector(-44.25, -7.4, -0.3)
	local logScreenAng = Angle(0, 22.4, 28)
	local logScreenW = 610
	local logScreenH = 420

	local success2, logWindow = Star_Trek.LCARS:CreateWindow("log_entry", logScreenPos, logScreenAng, scale, logScreenW, logScreenH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, false, nil, WINDOW_BORDER_BOTH)
	if not success2 then
		return false, logWindow
	end

	local engineControlPos = Vector(-16.1, -0.1, -0.3)
	local engineControlAng = Angle(0, 8.3, 28)
	local middleScreensW = 900
	local middleScreensH = 420

	-- Create Engine Control Screen.
	local success3, engineControlWindow = self:CreateEngineScreen(engineControlPos, engineControlAng, scale, middleScreensW, middleScreensH)
	if not success3 then
		return false, engineControlWindow
	end

	local navigationPos = Vector(engineControlPos)
	local utilOffset = Vector(7.37, -1.075, 0)
	local navigationAng = Angle(engineControlAng)
	navigationPos.x = -navigationPos.x
	navigationAng.y = -navigationAng.y

	-- Create Navigation Screen.
	local success4, navigationWindow, navigationUtilWindow = self:CreateNavigationScreen(navigationPos, utilOffset, navigationAng, scale, middleScreensW / 2, middleScreensH)
	if not success4 then
		return false, navigationWindow
	end

	local mapScreenPos = Vector(43.45, -9.25, 3)
	local mapScreenAng = Angle(0, -22.5, 77)
	local mapScreenW = 680
	local mapScreenH = 400

	local success5, mapWindow = Star_Trek.LCARS:CreateWindow("text_entry", mapScreenPos, mapScreenAng, scale, mapScreenW, mapScreenH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, nil, "Map", nil, WINDOW_BORDER_BOTH, {})
	if not success5 then
		return false, mapWindow
	end

	local mapControlPos = Vector(viewScreenPos)
	local mapControlAng = Angle(viewScreenAng)
	mapControlPos.x = -mapControlPos.x
	mapControlAng.y = -mapControlAng.y

	local success6, mapControlWindow = Star_Trek.LCARS:CreateWindow("button_matrix", mapControlPos, mapControlAng, scale, sideScreensW, sideScreensH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Map Control", nil, WINDOW_BORDER_BOTH)
	if not success6 then
		return false, mapControlWindow
	end

	return true, {logWindow, screenWindow, engineControlWindow, navigationWindow, navigationUtilWindow, mapWindow, mapControlWindow}, Vector(), Angle(0, 90, 0)
end