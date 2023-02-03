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

SELF.LightSource = true

function SELF:Update()
	SELF.Base.Update(self)

	-- Initialise basic information.
	self.LightTable = self.LightTable or {
		type = MATERIAL_LIGHT_DISABLE,

		-- Point Light parameters only?
		range = 0,
		quadraticFalloff = 0,
		linearFalloff = 0,
		constantFalloff = 1,

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

	local lightTable = self.LightTable
	lightTable.pos = self.ProjectedPos or self.LocalPos

	local dir = self.LocalDir

	local distance = self.Distance
	if distance >= VECTOR_MAX then
		lightTable.type = MATERIAL_LIGHT_DIRECTIONAL

		lightTable.dir = -dir
	else
		lightTable.type = MATERIAL_LIGHT_POINT

		lightTable.dir = nil
	end

	self.GlowPos = dir * VECTOR_MAX * 0.9
	local diameter = self.Diameter or 1

	self.GlowDir = -self.LocalDir

	self.GlowColor = self.LightColor
	local limit = diameter * 16
	if distance < limit then
		local factor = distance / limit
		diameter = diameter * factor

		self.GlowColor = ColorAlpha(self.GlowColor, factor * 255)
	end

	if distance >= VECTOR_MAX then
		diameter = diameter * (VECTOR_MAX / distance)
	end
	self.GlowScale = diameter * 2
end

function SELF:DrawSkybox()
	if not self.RenderSkybox then return end

	self.Base.DrawSkybox(self)

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