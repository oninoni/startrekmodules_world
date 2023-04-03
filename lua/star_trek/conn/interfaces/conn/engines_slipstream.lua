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

function SELF:SelectEngineModeSlipstream()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

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
		-- TODO
	end)
	engineControlWindow:AddButtonToRow(autoDropRow, "Enable Auto Drop to Warp", nil, nil, nil, false, false, function(ply, buttonData)
		-- TODO
	end)

	engineControlWindow:CreateMainButtonRow(32 * 1)

	local targetRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddButtonToRow(targetRow, "Navigation Target:", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow:AddButtonToRow(targetRow, "---", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow:AddButtonToRow(targetRow, "Approximate Travel Time:", nil, Star_Trek.LCARS.ColorRed, nil, true, false)
	engineControlWindow:AddButtonToRow(targetRow, "---", nil, Star_Trek.LCARS.ColorRed, nil, true, false)

	local engageRow = engineControlWindow:CreateMainButtonRow(32)
	engineControlWindow:AddButtonToRow(engageRow, "Engage Slipstream", nil, Star_Trek.LCARS.ColorOrange, nil, false, false, function(ply, buttonData)
		-- TODO
	end)
end

function SELF:SetEngineTargetSlipstream()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	return -- TODO
end