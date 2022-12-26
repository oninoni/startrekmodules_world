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
--    LCARS OPS Interface | Server   --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

SELF.BaseInterface = "bridge_targeting_base"

-- Opening general purpose menus.
function SELF:Open(ent)
	local success, windows, offsetPos, offsetAngle = SELF.Base.Open(self, ent, false)
	if not success then return false, windows end

	local scannerSelectionWindowPos = Vector(0, -1.5, 3.3)
	local scannerSelectionWindowAng = Angle(0, 0, 11)

	local success2, scannerWindow = Star_Trek.LCARS:CreateWindow("scanner", scannerSelectionWindowPos, scannerSelectionWindowAng, nil, 388, 320,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Scanner Control", "SCANNER", not self.Flipped)
	if not success2 then
		return false, scannerWindow
	end
	table.insert(windows, scannerWindow)

	local timerName = "Star_Trek.Operations.Scanner." .. ent:EntIndex()

	local scanSystemRow = scannerWindow:CreateMainButtonRow(32)
	scannerWindow:AddButtonToRow(scanSystemRow, "Scan Area", nil, nil, nil, false, false, function(ply, buttonData)
		scannerWindow:EnableScanning()

		Star_Trek.Logs:AddEntry(ent, ply, "Area scan started.")
		ent:EmitSound("star_trek.lcars_close")

		hook.Run("Star_Trek.Operations.ScanArea", ply)

		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
		timer.Create(timerName, 5, 1, function()
			Star_Trek.Logs:AddEntry(ent, ply, "Area scan completed.")
			ent:EmitSound("star_trek.lcars_close")

			hook.Run("Star_Trek.Operations.ScanAreaFinished", ply)
		end)

		return true
	end)

	local scanTargetRow = scannerWindow:CreateMainButtonRow(32)
	scannerWindow:AddButtonToRow(scanTargetRow, "Scan Target", nil, nil, nil, false, false, function(ply, buttonData)
		scannerWindow:EnableScanning()

		Star_Trek.Logs:AddEntry(ent, ply, "Target scan started.")
		ent:EmitSound("star_trek.lcars_close")

		hook.Run("Star_Trek.Operations.ScanTarget", ply)

		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
		timer.Create(timerName, 5, 1, function()
			Star_Trek.Logs:AddEntry(ent, ply, "Target scan completed.")
			ent:EmitSound("star_trek.lcars_close")

			hook.Run("Star_Trek.Operations.ScanTargetFinished", ply)
		end)

		return true
	end)
	scannerWindow:AddButtonToRow(scanTargetRow, "Scan Lifeforms", nil, nil, nil, false, false, function(ply, buttonData)
		scannerWindow:EnableScanning()

		Star_Trek.Logs:AddEntry(ent, ply, "Lifeform scan started.")
		ent:EmitSound("star_trek.lcars_close")

		hook.Run("Star_Trek.Operations.ScanLifeforms", ply)

		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
		timer.Create(timerName, 5, 1, function()
			Star_Trek.Logs:AddEntry(ent, ply, "Lifeform scan completed.")
			ent:EmitSound("star_trek.lcars_close")

			hook.Run("Star_Trek.Operations.ScanLifeformsFinished", ply)
		end)

		return true
	end)

	local launchProbeRow = scannerWindow:CreateMainButtonRow(32)
	scannerWindow:AddButtonToRow(launchProbeRow, "Launch Probe", nil, nil, nil, false, false, function(ply, buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Launching probe.")

		ent:EmitSound("star_trek.world.voy_probe_launch")

		hook.Run("Star_Trek.Operations.LaunchProbe", ply)

		return true
	end)

	scannerWindow:CreateMainButtonRow(32)

	local tractorBeamRow = scannerWindow:CreateMainButtonRow(32)
	scannerWindow:AddButtonToRow(tractorBeamRow, "Enable Tractor Beam", nil, nil, nil, false, true, function(ply, buttonData)
		if buttonData.Selected then
			buttonData.Name = "Disable Tractor Beam"

			Star_Trek.Logs:AddEntry(ent, ply, "Tractor beam enabled.")

			tractorBeamRow.LoopId = ent:StartLoopingSound("star_trek.world.voy_tractor_loop")

			hook.Run("Star_Trek.Operations.TractorBeamEnabled", ply)
		else
			buttonData.Name = "Enable Tractor Beam"

			Star_Trek.Logs:AddEntry(ent, ply, "Tractor beam disabled")

			if isnumber(tractorBeamRow.LoopId) then
				ent:StopLoopingSound(tractorBeamRow.LoopId)
			end

			hook.Run("Star_Trek.Operations.TractorBeamDisabled", ply)
		end
	end)

	local commsSelectionWindowPos = Vector(25.9, -1, 3.5)
	local commsSelectionWindowAng = Angle(0, 0, 11)

	local success3, commsWindow = Star_Trek.LCARS:CreateWindow("button_matrix", commsSelectionWindowPos, commsSelectionWindowAng, nil, 368, 350,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Communications", "COMMS", self.Flipped)
	if not success3 then
		return false, commsWindow
	end
	table.insert(windows, commsWindow)

	local hailTargetRow = commsWindow:CreateSecondaryButtonRow(32)
	self.HailTargetButton = commsWindow:AddButtonToRow(hailTargetRow, "Hail Target", nil, nil, nil, false, true, function(ply, buttonData)
		if buttonData.Selected then
			buttonData.Name = "Close Channel"
			self.HailRespondButton.Name = "Mute Channel"

			Star_Trek.Logs:AddEntry(ent, ply, "Hailing target...")

			ent:EmitSound("star_trek.world.comms_open")

			hook.Run("Star_Trek.Operations.CommsOpen", ply)

			return true
		else
			buttonData.Name = "Hail Target"
			self.HailRespondButton.Name = "Respond to Hail"

			Star_Trek.Logs:AddEntry(ent, ply, "Channel closed.")

			ent:EmitSound("star_trek.world.comms_close")

			hook.Run("Star_Trek.Operations.CommsClose", ply)

			return true
		end
	end)

	local repondHailRow = commsWindow:CreateSecondaryButtonRow(32)
	self.HailRespondButton = commsWindow:AddButtonToRow(repondHailRow, "Respond to Hail", nil, nil, Star_Trek.LCARS.ColorRed, false, true, function(ply, buttonData)
		if self.HailTargetButton.Selected then
			if buttonData.Selected then
				buttonData.Name = "Resume Channel"

				Star_Trek.Logs:AddEntry(ent, ply, "Channel muted.")

				ent:EmitSound("star_trek.world.comms_close")

				hook.Run("Star_Trek.Operations.CommsMute", ply)

				return true
			else
				buttonData.Name = "Mute Channel"

				Star_Trek.Logs:AddEntry(ent, ply, "Channel resumed.")

				ent:EmitSound("star_trek.world.comms_open")

				hook.Run("Star_Trek.Operations.CommsResume", ply)

				return true
			end
		else
			buttonData.Selected = false
			buttonData.Name = "Mute Channel"

			self.HailTargetButton.Selected = true
			self.HailTargetButton.Name = "Close Channel"

			Star_Trek.Logs:AddEntry(ent, ply, "Accepting incoming hail.")

			ent:EmitSound("star_trek.world.comms_open")

			hook.Run("Star_Trek.Operations.CommsReply", ply)

			return true
		end
	end)

	return true, windows, offsetPos, offsetAngle
end