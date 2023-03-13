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
--    Copyright © 2020 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--            World Entity           --
--            Sun | Client           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

local VECTOR_MAX = Star_Trek.World.Vector_Max or 131071
local AU_PRECALC = AU(1)

SELF.LightSource = true

function SELF:Update()
	SELF.Base.Update(self)

	-- Initialise basic information.
	self.LightTable = self.LightTable or {
		type = MATERIAL_LIGHT_DISABLE,
		color = self.LightColorVector,
	}

	local colorVector = self.LightColorVector
	local maxValue = math.max(colorVector.x, colorVector.y, colorVector.z)
	self.LightColor = Color(
		colorVector.x / maxValue * 255,
		colorVector.y / maxValue * 255,
		colorVector.z / maxValue * 255
	)

	self.GlowMaterial = Material("sprites/glow04_noz")
end

function SELF:RenderThink(shipPos, shipAng)
	SELF.Base.RenderThink(self, shipPos, shipAng)

	-- Handle Light Source.
	local lightTable = self.LightTable

	local distance = self.Distance
	local distanceRelative = distance / AU_PRECALC
	local brightness = math.min(10, 1 / (distanceRelative * distanceRelative))
	local lightColor = self.LightColorVector * brightness
	lightTable.color = lightColor

	local dir = self.LocalDir
	if math.max(lightColor.x, lightColor.y, lightColor.z) > 0.002 then
		lightTable.type = MATERIAL_LIGHT_POINT

		lightTable.pos = self.LocalPos
		lightTable.dir = -dir
	else
		lightTable.type = MATERIAL_LIGHT_DISABLE

		lightTable.pos = nil
		lightTable.dir = nil
	end

	-- Handle Glow Decal
	self.GlowPos = dir * VECTOR_MAX * 0.9
	local diameter = self.Diameter or 1

	self.GlowDir = -self.LocalDir

	self.GlowColor = self.LightColor
	local limit = diameter * 32
	if distance < limit then
		local factor = math.max(0, (distance / limit) * 1.2 - 0.2)
		self.GlowColor = ColorAlpha(self.LightColor, factor * 255)
	end

	if distance >= VECTOR_MAX then
		diameter = diameter * (VECTOR_MAX / distance)
	end
	self.GlowScale = diameter * 2
end

function SELF:DrawSkybox()
	if not self.RenderSkybox then return end

	self.Base.DrawSkybox(self)

	-- Draw Glow Decal
	render.SetMaterial(self.GlowMaterial)

	local scale = self.GlowScale
	render.DrawQuadEasy(
		self.GlowPos,
		self.GlowDir,
		scale,
		scale,
		self.GlowColor,
		self.Id
	)
end