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

local DEFAULT_WARP_SPEED = 5
local MINIMUM_WARP_TRAVEL_TIME = 30

function SELF:SelectEngineModeWarp()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	local speedSelectorRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddSelectorToRow(speedSelectorRow, "Warp Speed", {
		{Name =     "Warp 1", Data = 1, Color = Star_Trek.LCARS.ColorBlue},
		{Name =     "Warp 2", Data = 2, Color = Star_Trek.LCARS.ColorBlue},
		{Name =     "Warp 3", Data = 3, Color = Star_Trek.LCARS.ColorBlue},
		{Name =     "Warp 4", Data = 4, Color = Star_Trek.LCARS.ColorBlue},
		{Name =     "Warp 5", Data = 5},
		{Name =     "Warp 6", Data = 6},
		{Name =     "Warp 7", Data = 7},
		{Name =     "Warp 8", Data = 8},
		{Name =     "Warp 9", Data = 9},
		{Name =   "Warp 9.5", Data = 9.5},
		{Name =   "Warp 9.9", Data = 9.9},
		{Name =  "Warp 9.95", Data = 9.95 , Color = Star_Trek.LCARS.ColorRed},
		{Name = "Warp 9.975", Data = 9.975, Color = Star_Trek.LCARS.ColorRed},
		{Name =  "Warp 9.99", Data = 9.99 , Color = Star_Trek.LCARS.ColorRed},
	}, 5, function(ply, buttonData, value)
		engineControlWindow.SelectedWarpSpeed = value.Data

		self:SetEngineTargetWarp()
	end)

	local distanceSelectorRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddSelectorToRow(distanceSelectorRow, "Dropout Distance", {
		{Name =       "100km", Data = 100},
		{Name =       "500km", Data = 500},
		{Name =     "1.000km", Data = 1000},
		{Name =     "5.000km", Data = 5000},
		{Name =    "10.000km", Data = 10000},
		{Name =    "50.000km", Data = 50000},
		{Name =   "100.000km", Data = 100000},
		{Name =   "500.000km", Data = 500000},
		{Name = "1.000.000km", Data = 1000000},
		{Name = "1.000.000km", Data = 5000000},
	}, 5, function()
		engineControlWindow.SelectedWarpDistance = value.Data

		self:SetEngineTargetWarp()
	end) -- TODO

	local autoDropRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Impulse", nil, nil, nil, false, false, function(ply, buttonData)
		-- TODO
	end)
	engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Warp", nil, nil, nil, false, false, function(ply, buttonData)
		-- TODO
	end)

	engineControlWindow:CreateMainButtonRow(32)

	local targetRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddButtonToRow(targetRow, "Target Distance:", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow.WarpDistanceButton = engineControlWindow:AddButtonToRow(targetRow, "---", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow:AddButtonToRow(targetRow, "Approximate Travel Time:", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow.WarpDurationButton = engineControlWindow:AddButtonToRow(targetRow, "---", nil, Star_Trek.LCARS.ColorRed, nil, true, false)

	local engageRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow.EngageWarpButton = engineControlWindow:AddButtonToRow(engageRow, "Engage Warp Drive", nil, Star_Trek.LCARS.ColorOrange, nil, true, false, function(ply, buttonData)
		local selectedSpeed = engineControlWindow.SelectedWarpSpeed or DEFAULT_WARP_SPEED
		local targetPos = self:GetEngineTargetPos() -- TODO: Radius
		if not IsWorldVector(targetPos) then
			self.Ent:EmitSound("star_trek.lcars_error")
			print("Target not set")

			return true
		end

		local ship = Star_Trek.World:GetEntity(1)
		if not istable(ship) then
			self.Ent:EmitSound("star_trek.lcars_error")
			print("Ship not found")

			return true
		end

		local course = ship:PlotCourse(targetPos)
		if not istable(course) then
			self.Ent:EmitSound("star_trek.lcars_error")
			print("Course not found")

			return true
		end

		ship:ExecuteCourse(course, W(selectedSpeed), function()
			self.EnginesActive = nil
		end)

		self.EnginesActive = true
		engineControlWindow.EngageWarpButton.Disabled = true
	end)
end

function SELF:SetEngineTargetWarp()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	local targetPos = self:GetEngineTargetPos()

	local ship = Star_Trek.World:GetEntity(1)
	if not istable(ship) then return end

	local distance = ship.Pos:Distance(targetPos)

	local selectedSpeed = engineControlWindow.SelectedWarpSpeed or DEFAULT_WARP_SPEED
	local duration = distance / W(selectedSpeed)

	engineControlWindow.WarpDistanceButton.Disabled = false
	engineControlWindow.WarpDistanceButton.Name = Star_Trek.World:MeasureDistance(distance)

	if duration < MINIMUM_WARP_TRAVEL_TIME then
		engineControlWindow.WarpDurationButton.Disabled = false
		engineControlWindow.WarpDurationButton.Name = "Select Lower Warp Factor!"
		engineControlWindow.EngageWarpButton.Disabled = true
	else
		engineControlWindow.WarpDurationButton.Disabled = false
		engineControlWindow.WarpDurationButton.Name = Star_Trek.World:MeasureTime(duration)
		engineControlWindow.EngageWarpButton.Disabled = false
	end


	engineControlWindow:Update()

	return
end