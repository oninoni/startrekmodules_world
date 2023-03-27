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

function SELF:SelectEngineModeImpulse()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	local speedSelectorRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddSelectorToRow(speedSelectorRow, "Impulse Speed", {
		{Name = "1/8 Impulse", Data = 1},
		{Name = "1/4 Impulse", Data = 2},
		{Name = "1/2 Impulse", Data = 3},
		{Name = "3/4 Impulse", Data = 4},
		{Name = "Full Impulse", Data = 5},
	}, 2, callback)

	local distanceSelectorRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddSelectorToRow(distanceSelectorRow, "Dropout Distance", {
		{Name =      "0m", Data = 0},
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
		-- TODO
	end)
	engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Warp", nil, nil, nil, false, false, function(ply, buttonData)
		-- TODO
	end)

	engineControlWindow:CreateMainButtonRow(32 * 1)

	local targetRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddButtonToRow(targetRow, "Current Navigation Target: ---", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
	end)
	engineControlWindow:AddButtonToRow(targetRow, "Predicted Travel Time: ---", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
	end)

	local engageRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddButtonToRow(engageRow, "Engage Impulse Engine", nil, Star_Trek.LCARS.ColorOrange, nil, false, false, function(ply, buttonData)
		-- TODO
	end)
end