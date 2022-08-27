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

	local shieldSelectionWindowPos = Vector(0, -1.5, 3.3)
	local shieldSelectionWindowAng = Angle(0, 0, 11)

	local success2, shieldWindow = Star_Trek.LCARS:CreateWindow("button_matrix", shieldSelectionWindowPos, shieldSelectionWindowAng, nil, 380, 320,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Interactivity here yet.
	end, "Shield Control", "PHASER", not self.Flipped)
	if not success2 then
		return false, mapWindow
	end

	local shieldChargeRow = shieldWindow:CreateSecondaryButtonRow(32)
	shieldWindow:AddButtonToRow(shieldChargeRow, "Enable Shields", nil, Star_Trek.LCARS.ColorOrange, Star_Trek.LCARS.ColorRed, false, true, function(buttonData)
		if buttonData.Selected then
			buttonData.Name = "Disable Shields"
		else
			buttonData.Name = "Enable Shields"
		end

		-- TODO: Hook
	end)

	local shieldFreqRow = shieldWindow:CreateSecondaryButtonRow(32)
	shieldWindow:AddSelectorToRow(shieldFreqRow, "Frequency", {
		{Name = "1 GHz", Data = 1},
		{Name = "5 GHz", Data = 2},
		{Name = "10 GHz", Data = 3},
		{Name = "50 GHz", Data = 4},
		{Name = "100 GHz", Data = 5},
	}, 3)

	table.insert(windows, shieldWindow)

	local weaponSelectionWindowPos = Vector(-26, -1, 3.5)
	local weaponSelectionWindowAng = Angle(0, 0, 11)

	local success3, weaponWindow = Star_Trek.LCARS:CreateWindow("button_matrix", weaponSelectionWindowPos, weaponSelectionWindowAng, nil, 360, 350,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Interactivity here yet.
	end, "Weapons Control", "WEAPON", self.Flipped)
	if not success3 then
		return false, mapWindow
	end

	-- Phaser Control
	local phaserChargeRow = weaponWindow:CreateSecondaryButtonRow(32)
	weaponWindow:AddButtonToRow(phaserChargeRow, "Charge Phasers", nil, Star_Trek.LCARS.ColorOrange, Star_Trek.LCARS.ColorRed, false, true, function(buttonData)
		if buttonData.Selected then
			buttonData.Name = "Disable Phasers"

			self.FirePhaser.Disabled = false
			self.FirePhaserBurst.Disabled = false
		else
			buttonData.Name = "Charge Phasers"

			self.FirePhaser.Disabled = true
			self.FirePhaserBurst.Disabled = true
		end

		-- TODO: Hook
	end)

	local pasherPowerRow = weaponWindow:CreateSecondaryButtonRow(32)
	weaponWindow:AddSelectorToRow(pasherPowerRow, "Yield", {
		{Name = "1 %", Data = 1},
		{Name = "5 %", Data = 2},
		{Name = "10 %", Data = 3},
		{Name = "50 %", Data = 4},
		{Name = "100 %", Data = 5},
	}, 3)

	local phaserFreqRow = weaponWindow:CreateSecondaryButtonRow(32)
	weaponWindow:AddSelectorToRow(phaserFreqRow, "Frequency", {
		{Name = "1 GHz", Data = 1},
		{Name = "5 GHz", Data = 2},
		{Name = "10 GHz", Data = 3},
		{Name = "50 GHz", Data = 4},
		{Name = "100 GHz", Data = 5},
	}, 3)

	local phaserFireRow = weaponWindow:CreateSecondaryButtonRow(32)
	self.FirePhaser = weaponWindow:AddButtonToRow(phaserFireRow, "Fire"  , nil, Star_Trek.LCARS.ColorOrange, nil, true, false, function()
		-- TODO: Hook
	end)
	self.FirePhaserBurst = weaponWindow:AddButtonToRow(phaserFireRow, "Fire Burst", nil, Star_Trek.LCARS.ColorRed, nil, true, false, function()
		-- TODO: Hook
	end)

	-- Torpedo Control
	local torpedoChargeRow = weaponWindow:CreateMainButtonRow(32)
	weaponWindow:AddButtonToRow(torpedoChargeRow, "Prime Torpedos", nil, Star_Trek.LCARS.ColorOrange, Star_Trek.LCARS.ColorRed, false, true, function(buttonData)
		if buttonData.Selected then
			buttonData.Name = "Defuse Torpedos"

			self.FireTorpedo.Disabled = false
			self.FireTorpedoBurst.Disabled = false
		else
			buttonData.Name = "Prime Torpedos"

			self.FireTorpedo.Disabled = true
			self.FireTorpedoBurst.Disabled = true
		end

		-- TODO: Hook
	end)

	local torpedoPowerRow = weaponWindow:CreateMainButtonRow(32)
	weaponWindow:AddSelectorToRow(torpedoPowerRow, "Yield", {
		{Name = "1 %", Data = 1},
		{Name = "5 %", Data = 2},
		{Name = "10 %", Data = 3},
		{Name = "50 %", Data = 4},
		{Name = "100 %", Data = 5},
	}, 3)

	local torpedoTypeRow = weaponWindow:CreateMainButtonRow(32)
	weaponWindow:AddSelectorToRow(torpedoTypeRow, "Type", {
		{Name = "Photon", Data = 1},
		{Name = "Quantum", Data = 2},
		{Name = "Tricobalt", Data = 3},
	}, 1)

	local torpedoFireRow = weaponWindow:CreateMainButtonRow(32)
	self.FireTorpedo = weaponWindow:AddButtonToRow(torpedoFireRow, "Fire", nil, Star_Trek.LCARS.ColorOrange, nil, true, false, function()
		-- TODO: Hook
	end)
	self.FireTorpedoBurst = weaponWindow:AddButtonToRow(torpedoFireRow, "Fire Burst" , nil, Star_Trek.LCARS.ColorRed, nil, true, false, function()
		-- TODO: Hook
	end)

	table.insert(windows, weaponWindow)

	return success, windows, offsetPos, offsetAngle
end