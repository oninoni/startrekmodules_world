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

Star_Trek.World.RenderEntities = Star_Trek.World.RenderEntities or {}

local SKY_CAM_SCALE = Star_Trek.World.Skybox_Scale or (1 / 1024)
local SORT_DELAY = Star_Trek.World.SortDelay or 0.5

function Star_Trek.World:GenerateRenderEntities()
	self.RenderEntities = {}

	for _, otherEnt in SortedPairsByMemberValue(self.Entities, "Distance", true) do
		table.insert(self.RenderEntities, otherEnt)
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
		shipPos, shipAng = LocalToWorldBig(Vector(1.255, 0, 1.015), Angle(0, 180, 0), shipEnt.Pos, shipEnt.Ang)
	else
		-- Disable rendering if ship is not valid.
		shipId = nil

		return
	end

	self:RenderSort()
	for id, ent in ipairs(self.RenderEntities) do
		if ent.Id == shipId then continue end

		ent:RenderThink(shipPos, shipAng)
	end
end

local eyePos, eyeAngles
hook.Add("PreDrawSkyBox", "Star_Trek.World.Draw", function()
	local ply = LocalPlayer()

	eyePos = ply:EyePos()
	eyeAngles = ply:EyeAngles()
end)

function Star_Trek.World:Draw()
	if not shipId then return end

	render.SuppressEngineLighting(true)
	render.SetColorModulation(1, 1, 1)

	local mat = Matrix()
	mat:SetAngles(shipAng)
	mat:Rotate(eyeAngles)

	cam.Start3D(Vector(), mat:GetAngles(), nil, nil, nil, nil, nil, 0.5, 2)
		self:DrawBackground()
	cam.End3D()

	cam.Start3D(eyePos * SKY_CAM_SCALE, eyeAngles, nil, nil, nil, nil, nil, 0.0005, 10000000)
		cam.IgnoreZ(true)
		local renderEntities = self.RenderEntities
		for i = 1, #renderEntities do
			local ent = renderEntities[i]
			if ent.Id == shipId then continue end

			ent:Draw()
		end
		cam.IgnoreZ(false)
	cam.End3D()

	render.SuppressEngineLighting(false)
end

hook.Add("PostDraw2DSkyBox", "Star_Trek.World.Draw", function()
	Star_Trek.World:Draw()
end)