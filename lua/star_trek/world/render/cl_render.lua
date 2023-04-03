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

local SKY_CAM_SCALE = Star_Trek.World.Skybox_Scale or (1 / 1024)
local SORT_DELAY = Star_Trek.World.SortDelay or 0.5
local VECTOR_MAX = Star_Trek.World.Vector_Max or 131071
local AMBIENT_LIGHT = Star_Trek.World.AmbientLight
if AMBIENT_LIGHT == nil then
	AMBIENT_LIGHT = 0.0005
end

Star_Trek.World.HullEntities = Star_Trek.World.HullEntities or {}
local function initHull()
	Star_Trek.World.Entities = {}
	Star_Trek.World.HullEntities = {}

	--for _, ent in pairs(ents.FindByModel("models/kingpommes/startrek/intrepid/exterior_*")) do
	for _, ent in pairs(ents.GetAll()) do
		local model = ent:GetModel() or ""
		if string.StartsWith(model, "models/kingpommes/startrek/intrepid/exterior_") then
			ent:SetNoDraw(true)
			table.insert(Star_Trek.World.HullEntities, ent)
		end
	end
end
hook.Add("PostCleanupMap", "Star_Trek.World.InitHull", initHull)
hook.Add("InitPostEntity", "Star_Trek.World.InitHull", initHull)

Star_Trek.World.RenderEntities = Star_Trek.World.RenderEntities or {}
Star_Trek.World.LightSources = Star_Trek.World.LightSources or {}

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

		local j = 1
		local lightSources = {{}}--,{},{},{}}
		self.LightSources = lightSources

		for _, ent in SortedPairsByMemberValue(self.Entities, "Sort", true) do
			if ent.Id == shipId then continue end

			table.insert(self.RenderEntities, ent)

			ent:RenderThink(shipPos, shipAng)

			if ent.LightSource then
				lightSources[j] = ent.LightTable

				j = j + 1
				if j >= 4 then
					break
				end
			end
		end

		nextSort = CurTime() + SORT_DELAY
		return
	end

	local renderEntities = self.RenderEntities

	local curTime = CurTime()
	if curTime >= nextSort then
		nextSort = curTime + SORT_DELAY

		-- Render Sorting.
		table.SortByMember(renderEntities, "Sort")
	end

	-- Light sources.
	local lightCount = 0
	local lightSources = self.LightSources

	for i = 1, #renderEntities do
		local ent = renderEntities[i]

		ent:RenderThink(shipPos, shipAng)
		if ent.LightSource and lightCount <= 4 then
			local lightTable = ent.LightTable
			if lightTable.type == MATERIAL_LIGHT_DISABLE then continue end

			lightCount = lightCount + 1
			lightSources[lightCount] = lightTable
		end
	end
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
		self:DrawBackground()
	cam.End3D()

	render.ResetModelLighting(AMBIENT_LIGHT, AMBIENT_LIGHT, AMBIENT_LIGHT)
	render.SetLocalModelLights(self.LightSources)
	--render.SetLightingOrigin(Vector()) Was used to prevent flickering depending on camera angle.

	render.SetColorModulation(1, 1, 1)

	cam.Start3D(eyePos * SKY_CAM_SCALE, eyeAngles, nil, nil, nil, nil, nil, 8, VECTOR_MAX)
		--cam.IgnoreZ(true)
		local renderEntities = self.RenderEntities
		for i = 1, #renderEntities do
			local ent = renderEntities[i]

			ent:DrawSkybox()
		end
		--cam.IgnoreZ(false)
	cam.End3D()

	render.SuppressEngineLighting(false)
end

hook.Add("PostDraw2DSkyBox", "Star_Trek.World.Draw", function()
	Star_Trek.World:SkyboxDraw()
end)

function Star_Trek.World:NearbyDraw()
	if not shipId then return end

	render.SuppressEngineLighting(true)

	render.ResetModelLighting(AMBIENT_LIGHT, AMBIENT_LIGHT, AMBIENT_LIGHT)
	render.SetLocalModelLights(self.LightSources)
	--render.SetLightingOrigin(Vector()) Was used to prevent flickering depending on camera angle.

	render.SetColorModulation(1, 1, 1)

	cam.Start3D()
		local flashLight = LocalPlayer():FlashlightIsOn()

		local hullEntities = self.HullEntities
		for i = 1, #hullEntities do
			local ent = hullEntities[i]
			if not IsValid(ent) then continue end

			ent:DrawModel()

			if flashLight then
				render.PushFlashlightMode(true)
				ent:DrawModel()
				render.PopFlashlightMode()
			end
		end

		local renderEntities = self.RenderEntities
		for i = 1, #renderEntities do
			local ent = renderEntities[i]

			ent:DrawNearby()
		end
	cam.End3D()

	render.SuppressEngineLighting(false)
end

hook.Add("PostDrawTranslucentRenderables", "Star_Trek.World.Draw", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
	if bDrawingSkybox or isDraw3DSkybox then return end

	Star_Trek.World:NearbyDraw()
end)