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

SELF.DOCKING = 0
SELF.MANEUVERING = 1
SELF.IMPULSE = 2
SELF.WARP = 3
SELF.SLIPSTREAM = 4

function SELF:AddEngineSelectionButtons()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	local directDriveTypeRow = engineControlWindow:CreateSecondaryButtonRow(32)
	engineControlWindow:AddButtonToRow(directDriveTypeRow, "Docking Thrusters", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
		self:SelectEngineMode(self.DOCKING)
	end)
	engineControlWindow:AddButtonToRow(directDriveTypeRow, "Maneuvering Thrusters", nil, Star_Trek.LCARS.ColorLightBlue, nil, true, false, function(ply, buttonData)
		self:SelectEngineMode(self.MANEUVERING)
	end)

	local plottedDriveTypeRow = engineControlWindow:CreateSecondaryButtonRow(32)
	engineControlWindow:AddButtonToRow(plottedDriveTypeRow, "Impulse Engine", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
		self:SelectEngineMode(self.IMPULSE)
	end)
	engineControlWindow:AddButtonToRow(plottedDriveTypeRow, "Warp Drive", nil, Star_Trek.LCARS.ColorLightBlue, nil, false, false, function(ply, buttonData)
		self:SelectEngineMode(self.WARP)
	end)
	engineControlWindow:AddButtonToRow(plottedDriveTypeRow, "Slipstream", nil, Star_Trek.LCARS.ColorBlue, nil, false, false, function(ply, buttonData)
		self:SelectEngineMode(self.SLIPSTREAM)
	end)
end

function SELF:SelectEngineMode(mode)
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	for i = 1, 5 do
		local buttonData = engineControlWindow.Buttons[i]
		buttonData.Selected = (i == mode + 1)
	end

	engineControlWindow:ClearMainButtons()
	if mode == self.DOCKING then
		return
	elseif mode == self.MANEUVERING then
		return
	elseif mode == self.IMPULSE then
		local speedSelectorRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddSelectorToRow(speedSelectorRow, "Impulse Speed", {
			{Name = "1/4 Impulse", Data = 1},
			{Name = "1/2 Impulse", Data = 2},
			{Name = "3/4 Impulse", Data = 3},
			{Name = "Full Impulse", Data = 4},
		}, 2, callback)

		local distanceSelectorRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddSelectorToRow(distanceSelectorRow, "Dropout Distance", {
			{Name =    "100m", Data = 100},
			{Name =    "500m", Data = 200},
			{Name =     "1km", Data = 1000},
			{Name =     "5km", Data = 5000},
			{Name =    "10km", Data = 10000},
			{Name =    "50km", Data = 50000},
			{Name =   "100km", Data = 100000},
			{Name =   "500km", Data = 500000},
			{Name = "1.000km", Data = 1000000},
			{Name = "5.000km", Data = 5000000},
		}, 2, callback)

		local autoDropRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Impulse", nil, nil, nil, false, false, function(ply, buttonData)
		end)
		engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Warp", nil, nil, nil, false, false, function(ply, buttonData)
		end)

		engineControlWindow:CreateMainButtonRow(32 * 1)

		local targetRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(targetRow, "Current Navigation Target: ---", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		end)
		engineControlWindow:AddButtonToRow(targetRow, "Predicted Travel Time: ---", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		end)

		local engageRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(engageRow, "Engage Impulse Engine", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function(ply, buttonData)
		end)
	elseif mode == self.WARP then
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
		}, 5, callback)

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
		}, 5, callback)

		local autoDropRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Impulse", nil, nil, nil, false, false, function(ply, buttonData)
		end)
		engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Warp", nil, nil, nil, false, false, function(ply, buttonData)
		end)

		engineControlWindow:CreateMainButtonRow(32)

		local targetRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(targetRow, "Current Navigation Target: ---", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		end)
		engineControlWindow:AddButtonToRow(targetRow, "Predicted Travel Time: ---", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		end)

		local engageRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(engageRow, "Engage Warp Drive", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function(ply, buttonData)
		end)
	elseif mode == self.SLIPSTREAM then
		engineControlWindow:CreateMainButtonRow(32 * 1)

		local distanceSelectorRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddSelectorToRow(distanceSelectorRow, "Dropout Distance", {
			{Name =      "1AU", Data = 1},
			{Name =      "5AU", Data = 5},
			{Name =     "10AU", Data = 10},
			{Name =     "50AU", Data = 50},
			{Name =    "100AU", Data = 100},
			{Name =    "500AU", Data = 500},
			{Name =  "1.000AU", Data = 1000},
			{Name =  "5.000AU", Data = 5000},
			{Name = "10.000AU", Data = 10000},
			{Name = "50.000AU", Data = 50000},
		}, 5, callback)

		local autoDropRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Impulse", nil, nil, nil, false, false, function(ply, buttonData)
		end)
		engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Warp", nil, nil, nil, false, false, function(ply, buttonData)
		end)

		engineControlWindow:CreateMainButtonRow(32 * 1)

		local targetRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(targetRow, "Current Navigation Target: ---", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		end)
		engineControlWindow:AddButtonToRow(targetRow, "Predicted Travel Time: ---", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		end)

		local engageRow = engineControlWindow:CreateMainButtonRow(32)
		engineControlWindow:AddButtonToRow(engageRow, "Engage Slipstream", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function(ply, buttonData)
		end)
	end
end