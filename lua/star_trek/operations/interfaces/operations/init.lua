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

		Star_Trek.Logs:AddEntry(ent, ply, "Area Scan Started.")
		ent:EmitSound("star_trek.lcars_close")
		-- TODO: Hook

		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
		timer.Create(timerName, 5, 1, function()
			Star_Trek.Logs:AddEntry(ent, ply, "Area Scan Completed.")
			ent:EmitSound("star_trek.lcars_close")
		end)

		return true
	end)

	local scanTargetRow = scannerWindow:CreateMainButtonRow(32)
	scannerWindow:AddButtonToRow(scanTargetRow, "Scan Target", nil, nil, nil, false, false, function(ply, buttonData)
		scannerWindow:EnableScanning()

		Star_Trek.Logs:AddEntry(ent, ply, "Target Scan Started.")
		ent:EmitSound("star_trek.lcars_close")
		-- TODO: Hook

		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
		timer.Create(timerName, 5, 1, function()
			Star_Trek.Logs:AddEntry(ent, ply, "Target Scan Completed.")
			ent:EmitSound("star_trek.lcars_close")
			-- TODO: Hook
		end)

		return true
	end)
	scannerWindow:AddButtonToRow(scanTargetRow, "Scan Lifeforms", nil, nil, nil, false, false, function(ply, buttonData)
		scannerWindow:EnableScanning()

		Star_Trek.Logs:AddEntry(ent, ply, "Liftform Scan Started.")
		ent:EmitSound("star_trek.lcars_close")
		-- TODO: Hook

		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
		timer.Create(timerName, 5, 1, function()
			Star_Trek.Logs:AddEntry(ent, ply, "Liftform Scan Completed.")
			ent:EmitSound("star_trek.lcars_close")
			-- TODO: Hook
		end)

		return true
	end)

	local launchProbeRow = scannerWindow:CreateMainButtonRow(32)
	scannerWindow:AddButtonToRow(launchProbeRow, "Launch Probe", nil, nil, nil, false, false, function(ply, buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Launching Probe.")
		-- TODO: Hook
	end)

	scannerWindow:CreateMainButtonRow(32)

	local tractorBeamRow = scannerWindow:CreateMainButtonRow(32)
	scannerWindow:AddButtonToRow(tractorBeamRow, "Enable Tractor Beam", nil, nil, nil, false, false, function(ply, buttonData)
		if buttonData.Selected then
			buttonData.Name = "Disable Tractor Beam"

			Star_Trek.Logs:AddEntry(ent, ply, "Tractor Beam enabled.")
			-- TODO: Hook
		else
			buttonData.Name = "Enable Tractor Beam"

			Star_Trek.Logs:AddEntry(ent, ply, "Tractor Beam disabled")
			-- TODO: Hook
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
		print("Button Pressed")

		if buttonData.Selected then
			buttonData.Name = "Close Channel"
			self.HailRespondButton.Name = "Mute Channel"

			Star_Trek.Logs:AddEntry(ent, ply, "Hailing Target...")
			-- TODO: Hook
		else
			buttonData.Name = "Hail Target"
			self.HailRespondButton.Name = "Respond to Hail"

			Star_Trek.Logs:AddEntry(ent, ply, "Channel Closed.")
			-- TODO: Hook
		end
	end)

	local repondHailRow = commsWindow:CreateSecondaryButtonRow(32)
	self.HailRespondButton = commsWindow:AddButtonToRow(repondHailRow, "Respond to Hail", nil, nil, Star_Trek.LCARS.ColorRed, false, true, function(ply, buttonData)
		if self.HailTargetButton.Selected then
			if buttonData.Selected then
				buttonData.Name = "Resume Channel"

				Star_Trek.Logs:AddEntry(ent, ply, "Channel Muted.")
				-- TODO: Hook
			else
				buttonData.Name = "Mute Channel"

				Star_Trek.Logs:AddEntry(ent, ply, "Channel Resumed.")
				-- TODO: Hook
			end
		else
			buttonData.Selected = false
			buttonData.Name = "Mute Channel"

			self.HailTargetButton.Selected = true
			self.HailTargetButton.Name = "Close Channel"

			Star_Trek.Logs:AddEntry(ent, ply, "Accepting Incoming Hail.")
			-- TODO: Hook
		end
	end)

	return success, windows, offsetPos, offsetAngle
end