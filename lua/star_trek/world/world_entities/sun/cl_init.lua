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

		color = self.LightColor,
	}
end

function SELF:RenderThink(shipPos, shipAng)
	SELF.Base.RenderThink(self, shipPos, shipAng)

	local skyboxEntity = self.SkyboxEntity
	local pos = skyboxEntity:GetPos()

	local lightTable = self.LightTable
	lightTable.pos = pos

	local distance = self.Distance
	if distance >= VECTOR_MAX then
		lightTable.type = MATERIAL_LIGHT_DIRECTIONAL

		lightTable.dir = -Vector(pos)
		lightTable.dir:Normalize()

	else
		lightTable.type = MATERIAL_LIGHT_POINT

		lightTable.dir = nil
	end
end