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
-- LCARS Tactical Interface | Server --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

SELF.BaseInterface = "bridge_targeting_base"

-- Opening general purpose menus.
function SELF:Open(ent)
	local success, windows, offsetPos, offsetAngle = SELF.Base.Open(self, ent, true)
	if not success then return false, windows end

	local shieldSelectionWindowPos = Vector(0, -1.5, 3.3)
	local shieldSelectionWindowAng = Angle(0, 0, 11)

	local success2, shieldWindow = Star_Trek.LCARS:CreateWindow("button_matrix", shieldSelectionWindowPos, shieldSelectionWindowAng, nil, 388, 320,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Shield Control", "SHIELD", not self.Flipped)
	if not success2 then
		return false, shieldWindow
	end
	table.insert(windows, shieldWindow)

	local shieldChargeRow = shieldWindow:CreateSecondaryButtonRow(32)
	shieldWindow:AddButtonToRow(shieldChargeRow, "Raise Shields", nil, Star_Trek.LCARS.ColorOrange, Star_Trek.LCARS.ColorRed, false, true, function(ply, buttonData)
		if buttonData.Selected then
			buttonData.Name = "Lower Shields"

			Star_Trek.Logs:AddEntry(ent, ply, "Shields raised.")

			ent:EmitSound("star_trek.world.power_up")

			hook.Run("Star_Trek.Tactical.ShieldsUp", ply)

			return true
		else
			buttonData.Name = "Raise Shields"

			Star_Trek.Logs:AddEntry(ent, ply, "Shields lowered.")

			ent:EmitSound("star_trek.world.power_down")

			hook.Run("Star_Trek.Tactical.ShieldsDown", ply)

			return true
		end
	end)

	local shieldFreqRow = shieldWindow:CreateSecondaryButtonRow(32)
	shieldWindow:AddSelectorToRow(shieldFreqRow, "Frequency", {
		{Name = "1 GHz", Data = 1},
		{Name = "5 GHz", Data = 2},
		{Name = "10 GHz", Data = 3},
		{Name = "50 GHz", Data = 4},
		{Name = "100 GHz", Data = 5},
	}, 3, function(ply, buttonData, valueData)
		Star_Trek.Logs:AddEntry(ent, ply, "Shield frequency set: " .. valueData.Name)

		hook.Run("Star_Trek.Tactical.ShieldFrequencyChanged", ply, valueData.Name)
	end)

	local weaponSelectionWindowPos = Vector(-25.9, -1, 3.5)
	local weaponSelectionWindowAng = Angle(0, 0, 11)

	local success3, weaponWindow = Star_Trek.LCARS:CreateWindow("button_matrix", weaponSelectionWindowPos, weaponSelectionWindowAng, nil, 368, 350,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Weapons Control", "WEAPON", self.Flipped)
	if not success3 then
		return false, weaponWindow
	end
	table.insert(windows, weaponWindow)

	-- Phaser Control
	local phaserChargeRow = weaponWindow:CreateSecondaryButtonRow(32)
	weaponWindow:AddButtonToRow(phaserChargeRow, "Power Phasers", nil, Star_Trek.LCARS.ColorOrange, Star_Trek.LCARS.ColorRed, false, true, function(ply, buttonData)
		if buttonData.Selected then
			buttonData.Name = "Lower Phasers"

			self.FirePhaser.Disabled = false
			self.FirePhaserBurst.Disabled = false

			Star_Trek.Logs:AddEntry(ent, ply, "Phasers powered.")

			hook.Run("Star_Trek.Tactical.PhaserUp", ply)
		else
			buttonData.Name = "Power Phasers"

			self.FirePhaser.Disabled = true
			self.FirePhaserBurst.Disabled = true

			Star_Trek.Logs:AddEntry(ent, ply, "Phasers lowered.")

			hook.Run("Star_Trek.Tactical.PhaserDown", ply)
		end
	end)

	local pasherPowerRow = weaponWindow:CreateSecondaryButtonRow(32)
	weaponWindow:AddSelectorToRow(pasherPowerRow, "Yield", {
		{Name = "1 %", Data = 1},
		{Name = "5 %", Data = 2},
		{Name = "10 %", Data = 3},
		{Name = "50 %", Data = 4},
		{Name = "100 %", Data = 5},
	}, 3, function(ply, buttonData, valueData)
		Star_Trek.Logs:AddEntry(ent, ply, "Phaser yield set: " .. valueData.Name)

		hook.Run("Star_Trek.Tactical.PhaserYieldChanged", ply, valueData.Name)
	end)

	local phaserFreqRow = weaponWindow:CreateSecondaryButtonRow(32)
	weaponWindow:AddSelectorToRow(phaserFreqRow, "Frequency", {
		{Name = "1 GHz", Data = 1},
		{Name = "5 GHz", Data = 2},
		{Name = "10 GHz", Data = 3},
		{Name = "50 GHz", Data = 4},
		{Name = "100 GHz", Data = 5},
	}, 3, function(ply, buttonData, valueData)
		Star_Trek.Logs:AddEntry(ent, ply, "Phaser frequency set: " .. valueData.Name)

		hook.Run("Star_Trek.Tactical.PhaserFrequencyChanged", ply, valueData.Name)
	end)

	local phaserFireRow = weaponWindow:CreateSecondaryButtonRow(32)
	self.FirePhaser = weaponWindow:AddButtonToRow(phaserFireRow, "Fire", nil, Star_Trek.LCARS.ColorOrange, nil, true, false, function(ply, buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Firing phaser!", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)

		ent:EmitSound("star_trek.world.voy_phaser")

		hook.Run("Star_Trek.Tactical.PhaserFire", ply)

		return true
	end)
	self.FirePhaserBurst = weaponWindow:AddButtonToRow(phaserFireRow, "Fire Burst", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Firing phaser burst!", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)

		ent:EmitSound("star_trek.world.voy_phaser")

		hook.Run("Star_Trek.Tactical.PhaserBurst", ply)

		return true
	end)

	-- Torpedo Control
	local torpedoChargeRow = weaponWindow:CreateMainButtonRow(32)
	weaponWindow:AddButtonToRow(torpedoChargeRow, "Prime Torpedos", nil, Star_Trek.LCARS.ColorOrange, Star_Trek.LCARS.ColorRed, false, true, function(ply, buttonData)
		if buttonData.Selected then
			buttonData.Name = "Defuse Torpedos"

			self.FireTorpedo.Disabled = false
			self.FireTorpedoBurst.Disabled = false

			Star_Trek.Logs:AddEntry(ent, ply, "Torpedos primed.")

			hook.Run("Star_Trek.Tactical.TorpedoUp", ply)
		else
			buttonData.Name = "Prime Torpedos"

			self.FireTorpedo.Disabled = true
			self.FireTorpedoBurst.Disabled = true

			Star_Trek.Logs:AddEntry(ent, ply, "Torpedos defused.")

			hook.Run("Star_Trek.Tactical.TorpedoDown", ply)
		end
	end)

	local torpedoPowerRow = weaponWindow:CreateMainButtonRow(32)
	weaponWindow:AddSelectorToRow(torpedoPowerRow, "Yield", {
		{Name = "1 %", Data = 1},
		{Name = "5 %", Data = 2},
		{Name = "10 %", Data = 3},
		{Name = "50 %", Data = 4},
		{Name = "100 %", Data = 5},
	}, 3, function(ply, buttonData, valueData)
		Star_Trek.Logs:AddEntry(ent, ply, "Topedo Yield Set: " .. valueData.Name)

		hook.Run("Star_Trek.Tactical.TorpedoYieldChanged", ply, valueData.Name)
	end)

	local torpedoTypeRow = weaponWindow:CreateMainButtonRow(32)
	weaponWindow:AddSelectorToRow(torpedoTypeRow, "Type", {
		{Name = "Photon", Data = 1},
		{Name = "Quantum", Data = 2},
		{Name = "Tricobalt", Data = 3},
	}, 1, function(ply, buttonData, valueData)
		Star_Trek.Logs:AddEntry(ent, ply, "Changing to " .. valueData.Name .. " torpedos.")

		hook.Run("Star_Trek.Tactical.TorpedoTypeChanged", ply, valueData.Name)
	end)

	local torpedoFireRow = weaponWindow:CreateMainButtonRow(32)
	self.FireTorpedo = weaponWindow:AddButtonToRow(torpedoFireRow, "Fire", nil, Star_Trek.LCARS.ColorOrange, nil, true, false, function(ply, buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Firing torpedo!", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)

		ent:EmitSound("star_trek.world.voy_torpedo")

		hook.Run("Star_Trek.Tactical.TorpedoFire", ply)

		return true
	end)
	self.FireTorpedoBurst = weaponWindow:AddButtonToRow(torpedoFireRow, "Fire Burst" , nil, Star_Trek.LCARS.ColorRed, nil, true, false, function(ply, buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Firing torpedo burst!", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)

		ent:EmitSound("star_trek.world.voy_torpedo")

		hook.Run("Star_Trek.Tactical.TorpedoBurst", ply)

		return true
	end)

	return true, windows, offsetPos, offsetAngle
end