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
--       World Render | Client       --
---------------------------------------

Star_Trek.World.RenderEntities = {}

local VECTOR_MAX = Star_Trek.World.Vector_Max or 131071
local SKY_CAM_SCALE = Star_Trek.World.Skybox_Scale or (1 / 1024)
local SORT_DELAY = Star_Trek.World.SortDelay or 0.5

function Star_Trek.World:GenerateRenderEntities()
	self.RenderEntities = {}
	for _, otherEnt in SortedPairsByMemberValue(self.Entities, "Distance", true) do
		otherEnt.RenderId = table.insert(self.RenderEntities, otherEnt)
	end
end

local nextSort = CurTime()
function Star_Trek.World:RenderSort()
	local curTime = CurTime()
	if curTime < nextSort then
		return
	end
	nextSort = curTime + SORT_DELAY

	table.SortByMember(self.RenderEntities, "Distance")
end

local shipId, shipPos, shipAng
function Star_Trek.World:RenderThink()
	shipId = LocalPlayer():GetNWInt("Star_Trek.World.ShipId", 1)
	local shipEnt = self.Entities[shipId]
	if shipEnt then
		shipPos = shipEnt.Pos
		shipAng = shipEnt.Ang
	else
		-- Disable rendering if ship is not valid.
		shipId = nil
		return
	end

	-- Apply World Correction Offset
	-- Compensates Offset between Skybox and Map Model of Intrepid
	shipPos = shipPos + Vector(1.255, 0, 1.015)
	shipAng = shipAng + Angle(0, 180, 0)

	self:RenderSort()
	for id, ent in ipairs(self.RenderEntities) do
		local pos, ang = WorldToLocalBig(ent.Pos, ent.Ang, shipPos, shipAng)

		local realEnt = ent.ClientEntity

		-- Apply scaling
		local modelScale = ent.Scale or 1
		local distance = pos:Length()
		ent.Distance = distance

		if distance > VECTOR_MAX then
			pos = Vector(pos)
			pos:Normalize()

			pos = pos * VECTOR_MAX
			realEnt:SetModelScale(modelScale * (VECTOR_MAX / distance))
		else
			realEnt:SetModelScale(modelScale)
		end

		realEnt:SetPos(pos)
		realEnt:SetAngles(ang)

		ent.RenderId = id
	end
end

local eyePos, eyeAngles
hook.Add("PreDrawSkyBox", "Star_Trek.World.Draw", function()
	eyePos, eyeAngles = EyePos(), EyeAngles()
end)

function Star_Trek.World:Draw()
	if not shipId then return end

	render.SuppressEngineLighting(true)
	render.DepthRange(0, 0)

	local mat = Matrix()
	mat:SetAngles(shipAng)
	mat:Rotate(eyeAngles)

	cam.Start3D(Vector(), mat:GetAngles(), nil, nil, nil, nil, nil, 0.5, 2)
		self:DrawBackground()
	cam.End3D()

	cam.Start3D(eyePos * SKY_CAM_SCALE, eyeAngles, nil, nil, nil, nil, nil, 0.0005, 10000000)
		for _, ent in ipairs(self.RenderEntities) do
			if ent.Id == shipId then continue end

			ent.ClientEntity:DrawModel()
		end
	cam.End3D()

	render.DepthRange(0, 1)
	render.SuppressEngineLighting(false)
end

hook.Add("PostDraw2DSkyBox", "Star_Trek.World.Draw", function()
	Star_Trek.World:Draw()
end)