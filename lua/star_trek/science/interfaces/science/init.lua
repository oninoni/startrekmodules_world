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
--    Science  Interface | Server    --
---------------------------------------


if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

SELF.BaseInterface = "bridge_targeting_base"

SELF.LogType = "LCARS Interface"

-- This is the table of the dishes in the deflector system
-- Required Attributes:
-- startPos (Vector): Starting position of the dish
-- endPos (Vector): Ending positiong of the particle that comes out of the dish
-- width (Number): The width of the render.DrawBeam

--Optional Attributes:
-- additionalStart (Vector)
-- additionalEnd (Vector)
-- additionalWidth
-- These variables are used to draw a secondary beam as a part of the main particle beam
-- this was included as an optional parameter for the realspace beam that is required for the 
-- secondary deflector dish to properly render. It is intended to only be used in the 
-- secondary deflector dish render fix, however can be used in the future for other cases if needed.
local d = {
	Main = {
		startPos = Vector(1, 0, 15358.5),
		endPos = Vector(-1014, 0, 15358.5),
		width = 3,
	},
	Secondary = {
		startPos = Vector(-7.03124, 0, 15359.341),
		endPos = Vector(-1014, 0, 15359.341),
		width = 1,
		additionalWidth = 1024,
		additionalStart = Vector(-4000, 0, -703.5), -- these are entirely optional. They are used for the beam created in real space for the secondary deflector.
		additionalEnd = Vector(-7168, 0, -704),
	}
}

local data = {
			Dishes = d,
			ActiveDish = d[Main],
			TimerName = "Star_Trek.Science.SerenityDeflector",
		}

local deflector = Deflector:new(data)


function SELF:Open(ent)
	local success = true
	local windows = {}
	local offsetPos = Vector(0, 0, 0)
	local offsetAngle = Angle(0, 90, 0)


	deflector.InterfaceEnt = ent
	deflector:SetDish("Main") -- Resets the selected dish everytime the interface is reopened. Is there a way to just have the interface set the selector to deflector.ActiveDish on open so they aren't mislead about the current set dish?
	deflector.Time = 10
	deflector.TimeModifier = 1

	-----------------------------
	---      Main Window      ---
	-----------------------------

	buttons = {}

	local count = 1
	for i, particle in pairs(Star_Trek.Science.Particles) do
		local color
		if count % 2 == 0 then
			color = Star_Trek.LCARS.ColorLightBlue
		else
			color = Star_Trek.LCARS.ColorBlue
		end

		buttons[count] = {Name = i, Color = color, }
		count = count + 1

	end

	-- I sat down and had to document what axis went where in order to plot it in my mind
	--x -/+: conferencerm/readyrm
	--y -/+: tactical/viewscreen void
	--z -/+: down/up
	local deflectorSelectionWindowPos = Vector(-0.8, 2.5, -1.25)
	local deflectorSelectionWindowAng = Angle(0, 63, 37)

	local success3, deflectorWindow = Star_Trek.LCARS:CreateWindow("button_list", deflectorSelectionWindowPos, deflectorSelectionWindowAng, nil, 300, 325,
	function(windowData, interfaceData, ply, buttonId, buttonData)
		self:SetSelectedParticle(buttonData)
	end, buttons,"Deflector", "DFLCTR", false, nil, nil, 225)
	if not success3 then
		return false, deflectorWindow
	end
	table.insert(windows, deflectorWindow)


	--x -/+: conferencerm/readyrm
	--y -/+: tactical/viewscreen void
	--z -/+: down/up

	local rightSidePos = Vector(deflectorSelectionWindowPos.x + 6.67, deflectorSelectionWindowPos.y + 13.266, -1.2)

	local _, deflectorWindow2 = Star_Trek.LCARS:CreateWindow("button_matrix", rightSidePos, deflectorSelectionWindowAng, nil, 300, 320,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- None
	end, "Control", "", true)
	if not success3 then
		return false, deflectorWindow2
	end

	table.insert(windows, deflectorWindow2)


	dishRow = deflectorWindow2:CreateMainButtonRow(32)
	deflectorWindow2:AddSelectorToRow(dishRow, "Deflector Dish", {
		{Name = "Main", Data = "Main"},
		{Name = "Sec.", Data = "Secondary"}
	}, 3, function(ply, buttonData, valueData)
		deflector:SetDish(valueData.Data)
		Star_Trek.Logs:AddEntry(ent, ply, "Selected deflector dish changed to " .. valueData.Name)
	end)


	typeRow = deflectorWindow2:CreateMainButtonRow(32)
	deflectorWindow2:AddButtonToRow(typeRow, "Beam", nil, Star_Trek.LCARS.ColorBlue, Star_Trek.LCARS.ColorOrange, false, false, function (ply, buttonData)
		self:ToggleActiveEmitButton(buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Deflector emission type set to " .. buttonData.Name)
	end)

	deflectorWindow2:AddButtonToRow(typeRow, "Pulse", nil, Star_Trek.LCARS.ColorLightBlue, Star_Trek.LCARS.ColorOrange, false, false, function (ply, buttonData)
		self:ToggleActiveEmitButton(buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Deflector emission type set to " .. buttonData.Name)
	end)

	deflectorWindow2:AddButtonToRow(typeRow, "Field", nil, Star_Trek.LCARS.ColorBlue, Star_Trek.LCARS.ColorOrange, false, false, function (ply, buttonData)
		self:ToggleActiveEmitButton(buttonData)
		Star_Trek.Logs:AddEntry(ent, ply, "Deflector emission type set to " .. buttonData.Name)
	end)


	buffer = deflectorWindow2:CreateMainButtonRow(32)

	frequencyRow = deflectorWindow2:CreateMainButtonRow(32)
	deflectorWindow2:AddSelectorToRow(frequencyRow, "Strength", {
		{Name = "1", Data = 100},
		{Name = "5", Data = 50},
		{Name = "10", Data = 10},
		{Name = "50", Data = 5},
		{Name = "100", Data = 1},
	}, 3, function(ply, buttonData, valueData)
		deflector.Time = valueData.Data
	end)

	unitRow = deflectorWindow2:CreateMainButtonRow(32)
	deflectorWindow2:AddSelectorToRow(unitRow, "Units", {
		{Name = "Hz", Data = 3},
		{Name = "Mhz", Data = 2},
		{Name = "Ghz", Data = 1},
	}, 3, function(ply, buttonData, valueData)
		deflector.TimeModifier = valueData.Data
	end)

	buffer2 = deflectorWindow2:CreateMainButtonRow(32)

	fireRow = deflectorWindow2:CreateMainButtonRow(32)
	deflectorWindow2:AddButtonToRow(fireRow, "Activate", nil, Star_Trek.LCARS.ColorRed, nil, false, false, function(ply)

		if Star_Trek.World.Entities[1].Course ~= nil then
			ent:EmitSound("star_trek.lcars_error")
			Star_Trek.Logs:AddEntry(ent, ply, "Attempted to activate Deflector Dish during warp.")
			return
		end

		if deflector.CurrParticle == nil or self:GetActiveEmitButton() == nil or deflector.ParticleName == nil then
			ent:EmitSound("star_trek.lcars_error")
			return
		end


		Star_Trek.Logs:AddEntry(ent, ply, "Activating " .. deflector.ParticleName .. " " .. self:GetActiveEmitButton().Name .. "!" , Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)
		deflector:Fire()
	end)

	cancelRow = deflectorWindow2:CreateMainButtonRow(32)
	deflectorWindow2:AddButtonToRow(cancelRow, "Disable", nil, Star_Trek.LCARS.ColorOrange, nil, false, false, function(ply)

		if deflector.CurrParticle == nil or deflector.FiringType == nil then
			ent:EmitSound("star_trek.lcars_error")
			return
		end

		deflector:Cease()
		self:DeselectAll()
		Star_Trek.Logs:AddEntry(ent, ply, "Deactivating  Deflector Dish!" , Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)
	end)


	--x -/+: conferencerm/readyrm
	--y -/+: tactical/viewscreen void
	--z -/+: down/up
	local logPos = deflectorSelectionWindowPos + Vector(-2.1, 9.3, 28.3)
	local logAng = deflectorSelectionWindowAng + Angle(0, .5, 58.3)

	local _, logWindow = Star_Trek.LCARS:CreateWindow(
		"log_entry",
		logPos,
		logAng,
		20,
		620,
		810,
		function(windowData, interfaceData, ply, categoryId, buttonId)
			return false
		end
	)

	table.insert(windows, logWindow)

	--Keeping persitence of the deflector
	self:SelectByName(deflector.ParticleName, windows)
	self:SelectByName(deflector.FiringType, windows)

	return success, windows, offsetPos, offsetAngle
end



	-----------------------------
	---   Utility Functions   ---
	-----------------------------

function SELF:ToggleActiveEmitButton(button)
	if button.Selected then
		button.Selected = false
		deflector.FiringType = nil
		return
	end
	window = nil
	for i, win in pairs(self.Windows) do
		--Get the window that the particles are located in
		if win.Title == "Control" then
			window = win
			break
		end
	end
	for i, btn in pairs(window.Buttons) do
		if btn.Selected then
			btn.Selected = false
		end
	end
	button.Selected = true
	deflector.FiringType = button.Name

end

function SELF:GetActiveEmitButton()
	window = nil
	for i, win in pairs(self.Windows) do
		if win.Title == "Control" then
			window = win
			break
		end
	end
	for i, btn in pairs(window.Buttons) do
		if btn.Selected then
			return btn
		end
	end
	return nil
end

function SELF:SetSelectedParticle(button)

	if button.Selected then
		button.Selected = false
		deflector.CurrParticle = nil
		deflector.ParticleName = nil
		Star_Trek.Logs:AddEntry(self.ent, ply, "Particle set to None")
		return
	end

	window = nil
	for i, win in pairs(self.Windows) do
		if win.Title == "Deflector" then
			window = win
			break
		end
	end

	for i, btn in pairs(window.Buttons) do
		if btn.Selected then
			btn.Selected = false
		end
	end

	button.Selected = true
	deflector.CurrParticle = Star_Trek.Science.Particles[button.Name]
	deflector.ParticleName = button.Name
	Star_Trek.Logs:AddEntry(self.ent, ply, "Particle set to " .. button.Name)
end

function SELF:GetActiveParticle()
	window = nil
	for i, win in pairs(self.Windows) do
		if win.Title == "Deflector" then
			window = win
			break
		end
	end

	for i, btn in pairs(window.Buttons) do
		if btn.Selected then
			return btn
		end
	end
	return nil
end

function SELF:DeselectAll()

	for _, window in pairs(self.Windows) do
		if window.Buttons == nil then continue end
		for i, btn in pairs(window.Buttons) do
			if btn.Selected then
				btn.Selected = false
				window:Update()
			end
		end
	end

end

function SELF:SelectByName(name, windows)
	if name == nil then return end
	for _, window in pairs(windows) do
		if window.Buttons == nil then continue end
		for _, btn in pairs(window.Buttons) do
			if name == btn.Name then
				btn.Selected = true
			end
		end
	end
end
