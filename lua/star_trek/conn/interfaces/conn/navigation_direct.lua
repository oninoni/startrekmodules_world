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

function SELF:CreateNavigationDirectUtilWindow(pos, ang, scale, width, height)
	local navigationWindow = self.NavigationWindow
	if not istable(navigationWindow) then return false, "No navigation window found" end

	local success, navigationUtilWindow = Star_Trek.LCARS:CreateWindow("keypad",
		pos, ang, scale, width, height,
		function(windowData, interfaceData, ply, buttonId)
			-- No Additional Interactivity here.
		end, "Control", "NAV", WINDOW_BORDER_RIGHT)

	return success, navigationUtilWindow
end

-- Select the direct navigation mode.
function SELF:SelectNavigationDirectMode()
	local navigationWindow = self.NavigationWindow
	local navigationUtilWindow = self.NavigationUtilWindow
	if not istable(navigationWindow) or not istable(navigationUtilWindow) then return false, "No windows found" end

	local yawRow = navigationUtilWindow:CreateSecondaryButtonRow(32)
	navigationUtilWindow:AddButtonToRow(yawRow, "Yaw", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
	end)
	navigationUtilWindow:AddButtonToRow(yawRow, "(+/- 180°)", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
	end)
	navigationUtilWindow:AddButtonToRow(yawRow, "xxx", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
	end)

	local pitchRow = navigationUtilWindow:CreateSecondaryButtonRow(32)
	navigationUtilWindow:AddButtonToRow(pitchRow, "Pitch", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
	end)
	navigationUtilWindow:AddButtonToRow(pitchRow, "(+/- 90°)", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
	end)
	navigationUtilWindow:AddButtonToRow(pitchRow, "yy", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
	end)

	local worldLocalToggle = navigationWindow:CreateMainButtonRow(32)
	navigationWindow:AddButtonToRow(worldLocalToggle, "Local Coordinates", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
	end)
	navigationWindow:AddButtonToRow(worldLocalToggle, "Galactic Coordinates", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
	end)

	navigationWindow:CreateMainButtonRow(32)

	local courseRow = navigationWindow:CreateMainButtonRow(32)
	navigationWindow:AddButtonToRow(courseRow, "Course", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
	end)
	navigationWindow:AddButtonToRow(courseRow, "(Yaw.Pitch)", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
	end)
	navigationWindow:AddButtonToRow(courseRow, "xxx.yy", nil, Star_Trek.LCARS.ColorOrange, nil, false, false, function(ply, buttonData)
	end)

	navigationWindow:CreateMainButtonRow(32)

	local distanceSelectorRow = navigationWindow:CreateMainButtonRow(32)
	navigationWindow:AddSelectorToRow(distanceSelectorRow, "Distance", {
		{Name =       "1", Data = 1},
		{Name =       "5", Data = 5},
		{Name =      "10", Data = 10},
		{Name =      "50", Data = 50},
		{Name =     "100", Data = 100},
		{Name =     "500", Data = 500},
		{Name =   "1.000", Data = 1000},
		{Name =   "5.000", Data = 5000},
		{Name =  "10.000", Data = 10000},
		{Name =  "50.000", Data = 50000},
		{Name = "100.000", Data = 100000},
		{Name = "500.000", Data = 500000},
	}, 5, callback)

	local unitSelectorRow = navigationWindow:CreateMainButtonRow(32)
	navigationWindow:AddSelectorToRow(unitSelectorRow, "Unit", {
		{Name = "km", Data = 1},
		{Name = "AU", Data = 2},
		{Name = "LY", Data = 3},
	}, 2, callback)

	local lockCourse = navigationWindow:CreateMainButtonRow(32)
	navigationWindow:AddButtonToRow(lockCourse, "Lock Course", nil, Star_Trek.LCARS.ColorOrange, nil, false, false, function(ply, buttonData)
	end)
end