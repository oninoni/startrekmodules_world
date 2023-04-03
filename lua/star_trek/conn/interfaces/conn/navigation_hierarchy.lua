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

-- Create the navigation util window in hierarchy mode.
--
-- @param Vector pos
-- @param Angle ang
-- @param Number scale
-- @param Number width
-- @param Number height
-- @return Boolean success
-- @return String|Table error|navigationUtilWindow
function SELF:CreateNavigationHierachyUtilWindow(pos, ang, scale, width, height)
	local navigationWindow = self.NavigationWindow
	if not istable(navigationWindow) then return false, "No navigation window found" end

	local success, navigationUtilWindow = Star_Trek.LCARS:CreateWindow("button_list",
		pos, ang, scale, width, height,
		function(windowData, interfaceData, ply, buttonId)
			local buttonData = windowData.Buttons[buttonId]
			if not istable(buttonData) then return end

			windowData:SetSelected({[buttonData.Name] = true})
			windowData.SelectedListButton = buttonData

			navigationWindow.ShowSatellitesButton.Disabled = false
			local starSystem = self.NavigationStarSystem
			if istable(starSystem) then
				local planetId = buttonData.Data

				local targetPos = WorldVector(0, 0, 0, starSystem.X, starSystem.Y, 0)
				local planet = Star_Trek.World:GetEntity(planetId)
				if istable(planet) then
					targetPos = planet.Pos
				end

				self:SetNavigationCourseDisplay(targetPos)
			else
				starSystem = buttonData.Data

				local targetPos = WorldVector(0, 0, 0, starSystem.X, starSystem.Y, 0)

				self:SetNavigationCourseDisplay(targetPos)
			end

			navigationWindow.CurrentDistanceButton.Disabled = false
			navigationWindow.CurrentDistanceButton.Name = navigationWindow.CurrentCourseButton.Distance

			navigationWindow.CurrentTargetButton.Disabled = false
			navigationWindow.CurrentTargetButton.Name = buttonData.Name

			navigationWindow.LockCourseButton = false

			navigationWindow:Update()
		end, {}, "Control", "NAV", WINDOW_BORDER_RIGHT, false, 35, height - 50)
	if not success then
		return false, navigationUtilWindow
	end

	return success, navigationUtilWindow
end

-- Select and set the content of the hierarchy navigation window list.
--
-- @param Table starSystem
-- @param Number planetId
function SELF:SelectNavigationHierachyContent(starSystem, planetId)
	local navigationUtilWindow = self.NavigationUtilWindow
	if not istable(navigationUtilWindow) then return end

	local buttons = {}

	if not istable(starSystem) then
		self.NavigationStarSystem = nil
		self.NavigationPlanetId = nil

		for _, starSys in pairs(Star_Trek.World.StarSystems) do
			local button = {
				Name = starSys.Data.Name,
				Data = starSys,
			}

			table.insert(buttons, button)
		end
	else
		self.NavigationStarSystem = starSystem

		if not isnumber(planetId) then
			self.NavigationPlanetId = nil

			for _, planet in pairs(starSystem.Data.Entities) do
				if isnumber(planet.ParentId) then continue end

				local button = {
					Name = planet.Name,
					Data = planet.Id,
				}

				table.insert(buttons, button)
			end
		else
			self.NavigationPlanetId = planetId

			for _, planet in pairs(starSystem.Data.Entities) do
				if not isnumber(planet.ParentId) then continue end
				if planet.ParentId ~= planetId then continue end

				local button = {
					Name = planet.Name,
					Data = planet.Id,
				}

				table.insert(buttons, button)
			end
		end
	end

	if table.Count(buttons) == 0 then
		table.insert(buttons, {
			Name = "No Objects Found.",
			Disabled = true,
		})
	end

	navigationUtilWindow:SetButtons(buttons)
end

-- Select the hierarchy navigation mode.
function SELF:SelectNavigationHierachyMode()
	local navigationWindow = self.NavigationWindow
	if not istable(navigationWindow) then return end

	self:SelectNavigationHierachyContent()

	local hierarchyControl = navigationWindow:CreateMainButtonRow(32)
	navigationWindow.GoBackButton = navigationWindow:AddButtonToRow(hierarchyControl, "Go Back", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		local navigationUtilWindow = self.NavigationUtilWindow
		if not istable(navigationUtilWindow) then return end

		local starSystem = self.NavigationStarSystem
		if not istable(starSystem) then return end

		local planetId = self.NavigationPlanetId
		if not isnumber(planetId) then
			self:SelectNavigationHierachyContent()

			navigationUtilWindow:Update()

			navigationWindow.GoBackButton.Disabled = true
			navigationWindow.ShowSatellitesButton.Disabled = true

			return
		end

		local planet
		for _, pl in pairs(starSystem.Data.Entities) do
			if pl.Id ~= planetId then continue end
			planet = pl
			break
		end
		if not istable(planet) then return end

		local parentId = planet.ParentId
		if isnumber(parentId) then
			self:SelectNavigationHierachyContent(starSystem, parentId)
		else
			self:SelectNavigationHierachyContent(starSystem)
		end

		navigationUtilWindow:Update()

		navigationWindow.GoBackButton.Disabled = false
		navigationWindow.ShowSatellitesButton.Disabled = true
	end)
	navigationWindow.ShowSatellitesButton = navigationWindow:AddButtonToRow(hierarchyControl, "Show Satellites", nil, Star_Trek.LCARS.ColorOrange, nil, true, false, function(ply, buttonData)
		local navigationUtilWindow = self.NavigationUtilWindow
		if not istable(navigationUtilWindow) then return end

		local selectedListButton = navigationUtilWindow.SelectedListButton
		if not istable(selectedListButton) then return end

		local starSystem = self.NavigationStarSystem
		if istable(starSystem) then
			local planetId = selectedListButton.Data

			self:SelectNavigationHierachyContent(starSystem, planetId)
		else
			starSystem = selectedListButton.Data

			self:SelectNavigationHierachyContent(starSystem)
		end

		navigationUtilWindow:Update()

		navigationWindow.GoBackButton.Disabled = false
		navigationWindow.ShowSatellitesButton.Disabled = true
	end)

	navigationWindow:CreateMainButtonRow(32)

	local targetRow = navigationWindow:CreateMainButtonRow(32)
	navigationWindow:AddButtonToRow(targetRow, "Current Target:", nil, Star_Trek.LCARS.ColorBlue, nil, true, false)
	navigationWindow.CurrentTargetButton = navigationWindow:AddButtonToRow(targetRow, "---", nil, Star_Trek.LCARS.ColorLightBlue, nil, true, false)

	local distanceRow = navigationWindow:CreateMainButtonRow(32)
	navigationWindow:AddButtonToRow(distanceRow, "Target Distance:", nil, Star_Trek.LCARS.ColorBlue, nil, true, false)
	navigationWindow.CurrentDistanceButton = navigationWindow:AddButtonToRow(distanceRow, "---", nil, Star_Trek.LCARS.ColorLightBlue, nil, true, false)

	navigationWindow:CreateMainButtonRow(32 * 2)

	local lockCourse = navigationWindow:CreateMainButtonRow(32)
	navigationWindow.LockCourseButton = navigationWindow:AddButtonToRow(lockCourse, "Lock Course", nil, Star_Trek.LCARS.ColorOrange, nil, false, true, function(ply, buttonData)
		local navigationUtilWindow = self.NavigationUtilWindow
		if not istable(navigationUtilWindow) then
			self.Ent:EmitSound("star_trek.lcars_error")

			return true
		end

		local selectedListButton = navigationUtilWindow.SelectedListButton
		if not istable(selectedListButton) then
			self.Ent:EmitSound("star_trek.lcars_error")

			return true
		end

		local starSystem = self.NavigationStarSystem
		local planetId
		if istable(starSystem) then
			planetId = self.NavigationPlanetId
			if not isnumber(planetId) then
				planetId = selectedListButton.Data
			end
		else
			starSystem = selectedListButton.Data
		end

		-- TODO: Determine target position.

		self.Ent:EmitSound("star_trek.lcars_close")

		buttonData.Disabled = true
		timer.Simple(5, function()
			buttonData.Disabled = false
			navigationWindow:Update()

			self:SetEngineTarget() -- TODO
		end)

		return true
	end)
end