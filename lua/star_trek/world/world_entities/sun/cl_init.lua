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

local SKY_CAM_SCALE = Star_Trek.World.Skybox_Scale or (1 / 1024)
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

		color = self.LightColor,
	}

	local color = self.LightColor
	local maxValue = math.max(color.x, color.y, color.z)
	self.ConvertedColor = Color(
		color.x / maxValue * 255,
		color.y / maxValue * 255,
		color.z / maxValue * 255
	)

	self.FlareMaterial = Material("sprites/glow04_noz")
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

	self.FlarePos = dir * VECTOR_MAX * 0.9
	local diameter = self.Diameter or 1

	self.FlareDir = -self.LocalDir

	self.FlareColor = self.ConvertedColor
	local limit = diameter * 16
	if distance < limit then
		local factor = distance / limit
		diameter = diameter * factor

		self.FlareColor = ColorAlpha(self.FlareColor, factor * 255)
	end

	if distance >= VECTOR_MAX then
		diameter = diameter * (VECTOR_MAX / distance)
	end
	self.FlareScale = diameter * 2
end

function SELF:DrawSkybox()
	if not self.RenderSkybox then return end

	self.Base.DrawSkybox(self)

	render.SetMaterial(self.FlareMaterial)

	local scale = self.FlareScale
	render.DrawQuadEasy(
		self.FlarePos,
		self.FlareDir,
		scale,
		scale,
		self.FlareColor,
		self.Id
	)
end