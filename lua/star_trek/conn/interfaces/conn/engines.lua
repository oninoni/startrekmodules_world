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
		if buttonData.Confirm then
			buttonData.Confirm = nil
			buttonData.Name = "Emergency Stop"

			local ship = Star_Trek.World:GetEntity(1)
			if not istable(ship) then
				self.Ent:EmitSound("star_trek.lcars_error")
				print("Ship not found")

				return true
			end

			local aborted = ship:AbortCourse()
			if aborted then
				util.ScreenShake(Vector(), 5, 3, 3, 0)

				self.Ent:EmitSound("star_trek.lcars_error") -- TODO: Sounds
				print("Emergency Stop executed!")

				Star_Trek.Alert:Enable("red")

				return true
			end

			self.Ent:EmitSound("star_trek.lcars_error")
			print("Ship not moving!")

			return true
		end

		self.Ent:EmitSound("star_trek.lcars_error") -- TODO: Sounds

		buttonData.Confirm = true
		buttonData.Name = "Confirm Emergency Stop"

		return true
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

-- Set the target position for the engines.
-- 
-- @param Vector targetPos
-- @param? Number entityId
function SELF:SetEngineTarget(targetPos, entityId)
	self.EngineTargetPos = targetPos
	self.EngineTargetEntityId = entityId

	local mode = self.EngineControlMode
	if mode == self.DOCKING then
		return self:SetEngineTargetDocking()
	elseif mode == self.COMBAT then
		return self:SetEngineTargetCombat()
	elseif mode == self.IMPULSE then
		return self:SetEngineTargetImpulse()
	elseif mode == self.WARP then
		return self:SetEngineTargetWarp()
	elseif mode == self.SLIPSTREAM then
		return self:SetEngineTargetSlipstream()
	end
end

-- Get the target position for the engines.
--	
-- @param? Number radius
-- @returns Boolean/Vector sucess/pos
function SELF:GetEngineTargetPos(radius)
	local targetPos = self.EngineTargetPos
	if not IsWorldVector(targetPos) then return false, "Invalid Target Pos" end

	local entityId = self.EngineTargetEntityId
	if not isnumber(entityId) then return targetPos end

	local worldEntity = Star_Trek.World:GetEntity(entityId)
	if not istable(worldEntity) then return targetPos end

	local ship = Star_Trek.World:GetEntity(1)
	if not istable(ship) then return false, "Ship Position not found." end

	local dir = ship.Pos - targetPos

	if not radius then
		return worldEntity:GetStandardOrbit(dir)
	end

	return worldEntity:GetStandardOrbit(dir, radius)
end

-- TODO: Hook that recalcs course when a star system is loaded for each mode. IMPORTANT: Should also work, if console is inactive! (Maybe just move to actual ship entity?)