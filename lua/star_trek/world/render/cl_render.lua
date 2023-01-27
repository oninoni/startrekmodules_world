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

local shipId, shipPos, shipAng
local nextSort = CurTime()
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

	-- Regenerate Render Entities if something changed.
	if self.ShouldGenRender then
		self.ShouldGenRender = nil
		self.RenderEntities = {}

		for _, ent in SortedPairsByMemberValue(self.Entities, "Distance", true) do
			ent:RenderThink(shipPos, shipAng)

			table.insert(self.RenderEntities, ent)
		end

		nextSort = CurTime() + SORT_DELAY
		return
	end

	local renderEntities = self.RenderEntities
	for i = 1, #renderEntities do
		local ent = renderEntities[i]
		if ent.Id == shipId then continue end

		ent:RenderThink(shipPos, shipAng)
	end

	local curTime = CurTime()
	if curTime < nextSort then
		return
	end
	nextSort = curTime + SORT_DELAY

	table.SortByMember(renderEntities, "Distance")
end

function Star_Trek.World:SkyboxDraw()
	if not shipId then return end

	local ply = LocalPlayer()
	local eyePos = ply:EyePos()
	local eyeAngles = ply:EyeAngles()

	render.SuppressEngineLighting(true)

	local mat = Matrix()
	mat:SetAngles(shipAng)
	mat:Rotate(eyeAngles)

	cam.Start3D(Vector(), mat:GetAngles(), nil, nil, nil, nil, nil, 0.5, 2)
		Star_Trek.World:DrawBackground()
	cam.End3D()

	cam.Start3D(eyePos * SKY_CAM_SCALE, eyeAngles, nil, nil, nil, nil, nil, 0.0005, 10000000)
		cam.IgnoreZ(true)
		local renderEntities = self.RenderEntities
		for i = 1, #renderEntities do
			local ent = renderEntities[i]
			if ent.Id == shipId then continue end

			ent:DrawSkybox()
		end
		cam.IgnoreZ(false)
	cam.End3D()

	render.SuppressEngineLighting(false)
end

hook.Add("PostDraw2DSkyBox", "Star_Trek.World.Draw", function()
	Star_Trek.World:SkyboxDraw()
end)

function Star_Trek.World:NearbyDraw()
	if not shipId then return end

	render.SuppressEngineLighting(true)

	cam.Start3D()
		local renderEntities = self.RenderEntities
		for i = 1, #renderEntities do
			local ent = renderEntities[i]
			if ent.Id == shipId then continue end

			ent:DrawNearby()
		end
	cam.End3D()

	render.SuppressEngineLighting(false)
end

hook.Add("PostDrawTranslucentRenderables", "Star_Trek.World.Draw", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
	if bDrawingSkybox or isDraw3DSkybox then return end

	Star_Trek.World:NearbyDraw()
end)