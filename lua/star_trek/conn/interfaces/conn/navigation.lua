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

SELF.HIERARCHY = 0
SELF.DIRECT = 1

function SELF:CreateUtilWindow(pos, ang, scale, width, height, mode)
	if mode == self.HIERARCHY then
		local success4b, navigationUtilWindow = Star_Trek.LCARS:CreateWindow("button_matrix", pos, ang, scale, width, height,
		function(windowData, interfaceData, ply, categoryId, buttonId)
			-- No Additional Interactivity here.
		end, "Control", "NAV", WINDOW_BORDER_RIGHT)

		return success4b, navigationUtilWindow
	elseif mode == self.DIRECT then
		local success4b, navigationUtilWindow = Star_Trek.LCARS:CreateWindow("keypad", pos, ang, scale, width, height,
		function(windowData, interfaceData, ply, categoryId, buttonId)
			-- No Additional Interactivity here.
		end, "Control", "NAV", WINDOW_BORDER_RIGHT)

		return success4b, navigationUtilWindow
	end

	return false, "Invalid Mode"
end

function SELF:AddNavigationSelectionButtons()
	local navigationWindow = self.NavigationWindow
	local navigationUtilWindow = self.NavigationUtilWindow
	if not istable(navigationWindow) or not istable(navigationUtilWindow) then return end

	local modeSelectRow = navigationWindow:CreateSecondaryButtonRow(32)
	navigationWindow:AddButtonToRow(modeSelectRow, "System List", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
		self:SelectNavigationMode(self.DOCKING)
	end)
	navigationWindow:AddButtonToRow(modeSelectRow, "Direct Course", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
		self:SelectNavigationMode(self.DIRECT)
	end)

	local hierarchyUtilRow = navigationWindow:CreateSecondaryButtonRow(32)
	navigationWindow:AddButtonToRow(hierarchyUtilRow, "Current Course: xxx.yy-zzzAU", nil, Star_Trek.LCARS.ColorLightBlue, nil, false, false, function(ply, buttonData)
	end)
end

function SELF:SelectNavigationMode(mode, skipUpdate)
	local navigationWindow = self.NavigationWindow
	local navigationUtilWindow = self.NavigationUtilWindow
	if not istable(navigationWindow) or not istable(navigationUtilWindow) then return end

	self.NavigationMode = mode

	for i = 1, 2 do
		local buttonData = navigationWindow.Buttons[i]
		buttonData.Selected = (i == mode + 1)
	end

	if not skipUpdate then
		local success, newUtilWindow = self:CreateUtilWindow(
			navigationUtilWindow.WindowPos,
			navigationUtilWindow.WindowAngles,
			navigationUtilWindow.WindowScale,
			navigationUtilWindow.WindowWidth,
			navigationUtilWindow.WindowHeight,
			mode
		)
		if not success then return end

		newUtilWindow.AppliedOffset = true
		Star_Trek.LCARS:ApplyWindow(navigationUtilWindow.Interface, navigationUtilWindow.Id, newUtilWindow)
		newUtilWindow:Update()

		navigationUtilWindow = newUtilWindow
	end

	navigationWindow:ClearMainButtons()
	if mode == self.HIERARCHY then
		local hierarchyControl = navigationWindow:CreateMainButtonRow(32)
		navigationWindow:AddButtonToRow(hierarchyControl, "Go Back", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
		end)
		navigationWindow:AddButtonToRow(hierarchyControl, "Show Members", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
		end)

		navigationWindow:CreateMainButtonRow(32)

		local targetRow = navigationWindow:CreateMainButtonRow(32)
		navigationWindow:AddButtonToRow(targetRow, "Current Target:", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
		end)
		navigationWindow:AddButtonToRow(targetRow, "---", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
		end)

		local distanceRow = navigationWindow:CreateMainButtonRow(32)
		navigationWindow:AddButtonToRow(distanceRow, "Distance:", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
		end)
		navigationWindow:AddButtonToRow(distanceRow, "---", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
		end)

		navigationWindow:CreateMainButtonRow(32 * 2)

		local lockCourse = navigationWindow:CreateMainButtonRow(32)
		navigationWindow:AddButtonToRow(lockCourse, "Lock Course", nil, Star_Trek.LCARS.ColorOrange, nil, false, false, function(ply, buttonData)
		end)
	elseif mode == self.DIRECT then
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
end