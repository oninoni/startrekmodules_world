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
SELF.COMBAT = 1
SELF.IMPULSE = 2
SELF.WARP = 3
SELF.SLIPSTREAM = 4

include("engines_impulse.lua")
include("engines_warp.lua")
include("engines_slipstream.lua")

function SELF:AddEngineSelectionButtons()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	local directDriveTypeRow = engineControlWindow:CreateSecondaryButtonRow(32)
	engineControlWindow:AddButtonToRow(directDriveTypeRow, "Docking Thrusters", nil, Star_Trek.LCARS.ColorBlue, nil, not Star_Trek.Navigation.EnableDocking, false, function(ply, buttonData)
		self:SelectEngineMode(self.DOCKING)
	end)
	engineControlWindow:AddButtonToRow(directDriveTypeRow, "Combat Thrusters", nil, Star_Trek.LCARS.ColorLightBlue, nil, not Star_Trek.Navigation.EnableManeuver, false, function(ply, buttonData)
		self:SelectEngineMode(self.COMBAT)
	end)

	local plottedDriveTypeRow = engineControlWindow:CreateSecondaryButtonRow(32)
	engineControlWindow:AddButtonToRow(plottedDriveTypeRow, "Impulse Engine", nil, Star_Trek.LCARS.ColorBlue, nil, true, false, function(ply, buttonData)
		self:SelectEngineMode(self.IMPULSE)
	end)
	engineControlWindow:AddButtonToRow(plottedDriveTypeRow, "Warp Drive", nil, Star_Trek.LCARS.ColorLightBlue, nil, false, false, function(ply, buttonData)
		self:SelectEngineMode(self.WARP)
	end)
	engineControlWindow:AddButtonToRow(plottedDriveTypeRow, "Slipstream", nil, Star_Trek.LCARS.ColorBlue, nil, not Star_Trek.Navigation.EnableSlipstream, false, function(ply, buttonData)
		self:SelectEngineMode(self.SLIPSTREAM)
	end)

	local stopRow = engineControlWindow:CreateSecondaryButtonRow(32)
	engineControlWindow:AddButtonToRow(stopRow, "Emergency Stop", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function(ply, buttonData)
		-- TODO
	end)
end

function SELF:SelectEngineMode(mode)
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	self.EngineControlMode = mode

	for i = 1, 5 do
		local buttonData = engineControlWindow.Buttons[i]
		buttonData.Selected = (i == mode + 1)
	end

	engineControlWindow:ClearMainButtons()
	if mode == self.DOCKING then
		self:SelectEngineModeDocking()
	elseif mode == self.COMBAT then
		self:SelectEngineModeCombat()
	elseif mode == self.IMPULSE then
		self:SelectEngineModeImpulse()
	elseif mode == self.WARP then
		self:SelectEngineModeWarp()
	elseif mode == self.SLIPSTREAM then
		self:SelectEngineModeSlipstream()
	end
end

function SELF:SetEngineTarget()

end

-- TODO: Hook that recalcs course when a star system is loaded for each mode. IMPORTANT: Should also work, if console is inactive! (Maybe just move to actual ship entity?)