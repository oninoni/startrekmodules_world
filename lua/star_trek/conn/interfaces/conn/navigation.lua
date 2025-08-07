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

SELF.NAVIGATION_MODE_HIERARCHY = 0
SELF.NAVIGATION_MODE_DIRECT = 1

include("navigation_hierarchy.lua")
include("navigation_direct.lua")

-- Creates the Navigation Screen and the Navigation Util Screen.
--
-- @param Vector navigationPos
-- @param Vector utilOffset
-- @param Angle navigationAng
-- @param Number scale
-- @param Number screenW
-- @param Number screenH
-- @return Boolean success
-- @return String|Table error|navigationWindow
-- @return String|Table error|navigationUtilWindow
function SELF:CreateNavigationScreen(navigationPos, utilOffset, navigationAng, scale, screenW, screenH)
	local success, navigationWindow = Star_Trek.LCARS:CreateWindow("button_matrix",
		navigationPos - utilOffset, navigationAng, scale, screenW, screenH,
		nil, "Navigation", "NAV", WINDOW_BORDER_LEFT)
	if not success then
		return false, navigationWindow
	end
	self.NavigationWindow = navigationWindow
	self:AddNavigationWindowButtons()

	local successUtil, navigationUtilWindow = self:CreateNavigationUtilWindow(
		navigationPos + utilOffset, navigationAng, scale, screenW, screenH,
		self.NAVIGATION_MODE_HIERARCHY)
	if not successUtil then
		return false, navigationUtilWindow
	end
	self.NavigationUtilWindow = navigationUtilWindow
	self:SelectNavigationMode(self.NAVIGATION_MODE_HIERARCHY)

	return true, navigationWindow, navigationUtilWindow
end

-- Adds the general Navigation Window Buttons to the Navigation Window.
function SELF:AddNavigationWindowButtons()
	local navigationWindow = self.NavigationWindow
	if not istable(navigationWindow) then return end

	local modeSelectRow = navigationWindow:CreateSecondaryButtonRow(32)
	navigationWindow:AddButtonToRow(modeSelectRow, "System List", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
		if buttonData.Selected then return end

		self:ChangeNavigationUtilWindow(self.NAVIGATION_MODE_HIERARCHY)
	end)
	navigationWindow:AddButtonToRow(modeSelectRow, "Direct Course", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData) -- TODO: Disable Disabling of Direct Mode when Impulse works.
		if buttonData.Selected then return end

		self:ChangeNavigationUtilWindow(self.NAVIGATION_MODE_DIRECT)
	end)

	local currentCourseRow = navigationWindow:CreateSecondaryButtonRow(32)
	navigationWindow:AddButtonToRow(currentCourseRow, "Current Course:", nil, Star_Trek.LCARS.ColorLightBlue, nil, true, false)
	navigationWindow.CurrentCourseButton = navigationWindow:AddButtonToRow(currentCourseRow, "---", nil, Star_Trek.LCARS.ColorLightBlue, nil, true, false)
end

-- Creates the Navigation Util Window.
--
-- @param Vector pos
-- @param Angle ang
-- @param Number scale
-- @param Number width
-- @param Number height
-- @param Number mode
-- @return Boolean success
-- @return String|Table error|navigationUtilWindow
function SELF:CreateNavigationUtilWindow(pos, ang, scale, width, height, mode)
	local navigationWindow = self.NavigationWindow
	if not istable(navigationWindow) then return false, "No Navigation Window found." end

	if mode == self.NAVIGATION_MODE_HIERARCHY then
		return self:CreateNavigationHierachyUtilWindow(pos, ang, scale, width, height)
	elseif mode == self.NAVIGATION_MODE_DIRECT then
		return self:CreateNavigationDirectUtilWindow(pos, ang, scale, width, height)
	end

	return false, "Invalid Mode"
end

-- Change the Navigation Util Window to a different mode.
-- This will change the type of the window by recreating it.
--
-- @param Table mode
-- @return Boolean success
-- @return String|Table error|newUtilWindow
function SELF:ChangeNavigationUtilWindow(mode)
	local navigationUtilWindow = self.NavigationUtilWindow
	if not istable(navigationUtilWindow) then return false, "No Navigation Util Window to change found." end

	local pos = navigationUtilWindow.WindowPos
	local ang = navigationUtilWindow.WindowAngles
	local scale = navigationUtilWindow.WindowScale
	local width = navigationUtilWindow.WindowWidth
	local height = navigationUtilWindow.WindowHeight
	if not isvector(pos) or not isangle(ang) or not isnumber(scale) or not isnumber(width) or not isnumber(height) then
		return false, "Invalid Navigation Util Window Data"
	end

	local success, newUtilWindow = self:CreateNavigationUtilWindow(pos, ang, scale, width, height, mode)
	if not success then
		return false, newUtilWindow
	end

	newUtilWindow.AppliedOffset = true
	Star_Trek.LCARS:ApplyWindow(navigationUtilWindow.Interface, navigationUtilWindow.Id, newUtilWindow)
	self.NavigationUtilWindow = newUtilWindow

	self:SelectNavigationMode(mode)

	newUtilWindow:Update()

	return true, newUtilWindow
end

-- Selects the Navigation mode and updates the Navigation Windows.
--
-- @param Number mode
function SELF:SelectNavigationMode(mode)
	local navigationWindow = self.NavigationWindow
	local navigationUtilWindow = self.NavigationUtilWindow
	if not istable(navigationWindow) or not istable(navigationUtilWindow) then return end

	self.NavigationMode = mode
	for i = 1, 2 do
		local buttonData = navigationWindow.Buttons[i]
		buttonData.Selected = (i == mode + 1)
	end

	self:SetNavigationCourseDisplay()

	navigationWindow:ClearMainButtons()
	if mode == self.NAVIGATION_MODE_HIERARCHY then
		self:SelectNavigationHierachyMode()
	elseif mode == self.NAVIGATION_MODE_DIRECT then
		self:SelectNavigationDirectMode()
	end
end

-- Sets the Navigation Course to the given target and display it on the top.
--
-- @param Vector targetPos
function SELF:SetNavigationCourseDisplay(targetPos)
	local navigationWindow = self.NavigationWindow
	if not istable(navigationWindow) then return end

	local currentCourseButton = navigationWindow.CurrentCourseButton
	if not istable(currentCourseButton) then return end

	if targetPos == nil then
		currentCourseButton.Disabled = true
		currentCourseButton.Name = "---"

		return
	end

	local ship = Star_Trek.World.MapShip
	local shipPos = ship.Pos
	local shipAng = ship.Ang

	local dir = targetPos - shipPos
	local dirNorm = dir:GetNormalized()
	local dirAng = dirNorm:Angle()
	local diff = shipAng - dirAng
	diff:Normalize()

	-- TODO: Add Course Calculation
	local yaw = math.Round(diff.y, 2)
	if yaw < 0 then yaw = yaw + 360 end

	local pit = math.Round(diff.p, 2)
	if pit < 0 then pit = pit + 360 end

	local buttonText = string.format("%06.2f.%05.2f.", yaw, pit)

	local course = targetPos - shipPos
	local distance = course:Length()
	currentCourseButton.Distance = Star_Trek.World:MeasureDistance(distance)

	buttonText = buttonText .. currentCourseButton.Distance

	currentCourseButton.Disabled = false
	currentCourseButton.Name = buttonText
end