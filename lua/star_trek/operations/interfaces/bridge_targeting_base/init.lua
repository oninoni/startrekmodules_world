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
--   LCARS Targeting Int. | Server   --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

include("util.lua")

SELF.BaseInterface = "base"

-- Opening general purpose menus.
function SELF:Open(ent, flipped)
	self.Flipped = flipped

	self.MapWindowPos = Vector(-45, -10, 30)
	self.MapWindowAng = Angle(0, 70, 90)
	self.TargetInfoWindowPos = Vector(-45.6, -20, 3.6)
	self.TargetInfoWindowAng = Angle(0, 71.5, 27)
	self.TargetSelectionWindowPos = Vector(-25.9, -1, 3.5)
	self.TargetSelectionWindowAng = Angle(0, 0, 11)
	self.ShipInfoWindowPos = Vector(-27.2, -5.25, 2.675)
	self.ShipInfoWindowAng = Angle(0, 0, 11)

	if self.Flipped then
		self.MapWindowPos.x   = -self.MapWindowPos.x
		self.MapWindowAng.yaw = -self.MapWindowAng.yaw

		self.TargetInfoWindowPos.x   = -self.TargetInfoWindowPos.x
		self.TargetInfoWindowAng.yaw = -self.TargetInfoWindowAng.yaw

		self.TargetSelectionWindowPos.x   = -self.TargetSelectionWindowPos.x
		self.TargetSelectionWindowAng.yaw = -self.TargetSelectionWindowAng.yaw

		self.ShipInfoWindowPos.x   = -self.ShipInfoWindowPos.x
		self.ShipInfoWindowAng.yaw = -self.ShipInfoWindowAng.yaw
	end

	local success, holoWindow = self:CreateLogsWindow()
	if not success then
		return false, holoWindow
	end

	local success2, targetInfoWindow = Star_Trek.LCARS:CreateWindow("target_info", self.TargetInfoWindowPos, self.TargetInfoWindowAng, nil, 420, 140,
	function(windowData, interfaceData, ply, buttonId)
		-- No Additional Interactivity here.
	end, 2, false, true, self.Flipped)
	if not success2 then
		return false, targetInfoWindow
	end

	local success3, targetSelectionWindow = Star_Trek.LCARS:CreateWindow("button_matrix", self.TargetSelectionWindowPos, self.TargetSelectionWindowAng, nil, 368, 350,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Ship Control", "ALERT", not self.Flipped)
	if not success3 then
		return false, targetSelectionWindow
	end

	local sRow1 = targetSelectionWindow:CreateSecondaryButtonRow(32)
	targetSelectionWindow:AddButtonToRow(sRow1, "Red Alert", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function(ply)
		Star_Trek.Alert:Enable("red")

		Star_Trek.Logs:AddEntry(self.Ent, ply, "")
		Star_Trek.Logs:AddEntry(self.Ent, ply, "RED ALERT!")
	end)
	targetSelectionWindow:AddButtonToRow(sRow1, "Yellow Alert", nil, Star_Trek.LCARS.ColorOrange, nil, false, false, function(ply)
		Star_Trek.Alert:Enable("yellow")

		Star_Trek.Logs:AddEntry(self.Ent, ply, "")
		Star_Trek.Logs:AddEntry(self.Ent, ply, "YELLOW ALERT!")
	end)
	local sRow2 = targetSelectionWindow:CreateSecondaryButtonRow(32)
	targetSelectionWindow:AddButtonToRow(sRow2, "Blue Alert", nil, Star_Trek.LCARS.ColorLightBlue, nil, false, false, function(ply)
		Star_Trek.Alert:Enable("blue")

		Star_Trek.Logs:AddEntry(self.Ent, ply, "")
		Star_Trek.Logs:AddEntry(self.Ent, ply, "BLUE ALERT!")
	end)
	targetSelectionWindow:AddButtonToRow(sRow2, "Disable Alert", nil, Star_Trek.LCARS.ColorOrange, nil, false, false, function(ply)
		Star_Trek.Alert:Disable()

		Star_Trek.Logs:AddEntry(self.Ent, ply, "")
		Star_Trek.Logs:AddEntry(self.Ent, ply, "Alert Disabled!")
	end)

	local scannerRangeRow = targetSelectionWindow:CreateMainButtonRow(32)
	targetSelectionWindow:AddSelectorToRow(scannerRangeRow, "Map Zoom", {
		{Name = "0.25x", Data = 1},
		{Name = "0.5x", Data = 2},
		{Name = "1x", Data = 3},
		{Name = "2x", Data = 4},
		{Name = "4x", Data = 5},
	}, 3)

	local toggleLogsRow = targetSelectionWindow:CreateMainButtonRow(32)
	targetSelectionWindow:AddButtonToRow(toggleLogsRow, "Show Logs", nil, nil, nil, false, false, function(ply, buttonData)
		self.ShowLogs = not self.ShowLogs
		if self.ShowLogs then
			buttonData.Name = "Show Map"
			scannerRangeRow:SetDisabled(true)
		else
			buttonData.Name = "Show Logs"
			scannerRangeRow:SetDisabled(false)
		end

		local success5, logsWindow = self:CreateLogsWindow()
		if not success5 then
			return false, logsWindow -- TODO: Testing
		end

		logsWindow.Id = holoWindow.Id
		logsWindow.Interface = holoWindow.Interface
		logsWindow:Update()
	end)

	targetSelectionWindow:CreateMainButtonRow(3 * 32 + 2)
	local success4, shipInfoWindow = Star_Trek.LCARS:CreateWindow("ship_info", self.ShipInfoWindowPos, self.ShipInfoWindowAng, 22, 346, 108,
	function(windowData, interfaceData, ply, buttonId)
		-- No Additional Interactivity here.
	end, self.Flipped)
	if not success4 then
		return false, targetInfoWindow
	end

	local closeMenuRow = targetSelectionWindow:CreateMainButtonRow(32)
	targetSelectionWindow:AddButtonToRow(closeMenuRow, "Close Menu", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function()
		self:Close()
	end)

	return true, {holoWindow, targetInfoWindow, targetSelectionWindow, shipInfoWindow}, Vector(), Angle(0, 90, 0)
end