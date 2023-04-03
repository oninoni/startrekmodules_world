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
	engineControlWindow:AddSelectorToRow(distanceSelectorRow, "Orbit Radius", {
		{Name = "Standard Orbit", Data = nil},
		{Name =          "100km", Data = 100},
		{Name =          "500km", Data = 500},
		{Name =        "1.000km", Data = 1000},
		{Name =        "5.000km", Data = 5000},
		{Name =       "10.000km", Data = 10000},
		{Name =       "50.000km", Data = 50000},
		{Name =      "100.000km", Data = 100000},
		{Name =      "500.000km", Data = 500000},
		{Name =    "1.000.000km", Data = 1000000},
		{Name =    "1.000.000km", Data = 5000000},
	}, 1, function(ply, buttonData, value)
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
	engineControlWindow:AddButtonToRow(targetRow, "Travel Distance:", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow.WarpDistanceButton = engineControlWindow:AddButtonToRow(targetRow, "---", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow:AddButtonToRow(targetRow, "Travel Duration:", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow.WarpDurationButton = engineControlWindow:AddButtonToRow(targetRow, "---", nil, Star_Trek.LCARS.ColorRed, nil, true, false)

	local engageRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow.EngageWarpButton = engineControlWindow:AddButtonToRow(engageRow, "Engage Warp Drive", nil, Star_Trek.LCARS.ColorOrange, nil, true, false, function(ply, buttonData)
		local selectedSpeed = engineControlWindow.SelectedWarpSpeed or DEFAULT_WARP_SPEED
		local targetPos, targetError = self:GetEngineTargetPos(engineControlWindow.SelectedWarpDistance) -- TODO: Radius
		if not targetPos then
			self.Ent:EmitSound("star_trek.lcars_error")
			print(targetError)

			return true
		end

		local ship = Star_Trek.World:GetEntity(1)
		if not istable(ship) then
			self.Ent:EmitSound("star_trek.lcars_error")
			print("Ship not found")

			return true
		end

		if istable(ship.ActiveManeuver) then
			self.Ent:EmitSound("star_trek.lcars_error")
			print("Ship already maneuvering")

			return true
		end

		local course = ship:PlotCourse(targetPos)
		if not istable(course) then
			self.Ent:EmitSound("star_trek.lcars_error")
			print("Course not found")

			return true
		end

		local warpCore = ents.FindByName("coremover")[1]
		if warpCore:GetPos().z < 11000 then
			self.Ent:EmitSound("star_trek.lcars_error")
			print("Warp Core Offline")

			return true
		end

		ship:ExecuteCourse(course, W(selectedSpeed), function()
			self:SetEngineTarget()
		end)

		self:SetEngineTargetWarp()
	end)
end

function SELF:SetEngineTargetWarp()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	local targetPos, targetError = self:GetEngineTargetPos(engineControlWindow.SelectedWarpDistance)
	if not targetPos then
		--self.Ent:EmitSound("star_trek.lcars_error")
		print(targetError)

		return true
	end

	local ship = Star_Trek.World:GetEntity(1)
	if not istable(ship) then return end

	self.EngineWarpCourse = ship:PlotCourse(targetPos)
	if not istable(self.EngineWarpCourse) then return end

	local selectedSpeed = engineControlWindow.SelectedWarpSpeed or DEFAULT_WARP_SPEED

	local maneuvers = {}
	for i = 1, #self.EngineWarpCourse - 1 do
		local startPos = self.EngineWarpCourse[i]
		local endPos = self.EngineWarpCourse[i + 1]

		table.insert(maneuvers, ship:CreateWarpManeuver(startPos, endPos, W(selectedSpeed)))
	end

	local distance = 0
	local duration = 0
	for _, maneuverData in ipairs(maneuvers) do
		distance = distance + maneuverData.Distance
		duration = duration + maneuverData.Duration
	end

	engineControlWindow.WarpDistanceButton.Disabled = false
	engineControlWindow.WarpDistanceButton.Name = Star_Trek.World:MeasureDistance(distance)
	engineControlWindow.WarpDurationButton.Disabled = false
	engineControlWindow.WarpDurationButton.Name = Star_Trek.World:MeasureTime(duration)

	local warpCore = ents.FindByName("coremover")[1]
	if warpCore:GetPos().z < 11000 then
		engineControlWindow.EngageWarpButton.Disabled = true
		engineControlWindow.EngageWarpButton.Name = "Warp Core Offline"
	else
		if istable(ship.ActiveManeuver) then
			engineControlWindow.EngageWarpButton.Disabled = true
			engineControlWindow.EngageWarpButton.Name = "Warp Drive Active"
		else
			if duration < MINIMUM_WARP_TRAVEL_TIME then
				engineControlWindow.EngageWarpButton.Disabled = true
				engineControlWindow.EngageWarpButton.Name = "Select Lower Warp Factor!"
			else
				engineControlWindow.EngageWarpButton.Disabled = false
				engineControlWindow.EngageWarpButton.Name = "Engage Warp Drive"
			end
		end
	end


	engineControlWindow:Update()

	return
end