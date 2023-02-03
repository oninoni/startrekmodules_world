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
--           Base | Client           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

local SKY_CAM_SCALE = Star_Trek.World.Skybox_Scale or (1 / 1024)
local NEARBY_MAX = 16
local VECTOR_MAX = Star_Trek.World.Vector_Max or 131071

function SELF:Init(clientData)
	self:SetData(clientData)
	self:SetDynData(clientData)

	self.SkyboxEntity = self:CreateClientsideModel(self.Model)
	self.NearbyEntity = self:CreateClientsideModel(self.Model)

	self:Update()
end

function SELF:Terminate()
	SafeRemoveEntity(self.SkyboxEntity)
end

function SELF:SetData(clientData)
	for key, value in pairs(clientData) do
		self[key] = value
	end
end

function SELF:SetDynData(clientData)
end

function SELF:Update()
	WorldVectorFromTable(self.Pos)

	local modelData = self.Model
	local modelScale = self.Scale or 1
	local material = self.Material

	local nearbyEntity = self.NearbyEntity
	if IsValid(nearbyEntity) then
		self:ApplyModel(nearbyEntity, modelData)

		nearbyEntity:SetModelScale(modelScale / SKY_CAM_SCALE)
		nearbyEntity:SetMaterial(material)
	end

	local skyboxEntity = self.SkyboxEntity
	if IsValid(skyboxEntity) then
		self:ApplyModel(skyboxEntity, modelData)

		skyboxEntity:SetMaterial(material)
	end
end

function SELF:RenderThink(shipPos, shipAng)
	local pos, ang = WorldToLocalBig(self.Pos, self.Ang, shipPos, shipAng)
	self.LocalPos = pos
	self.LocalAng = ang

	local dir = Vector(pos)
	dir:Normalize()
	self.LocalDir = dir

	local distance = pos:Length()
	self.Distance = distance

	if distance / SKY_CAM_SCALE < VECTOR_MAX and distance - self.Diameter < NEARBY_MAX then
		self.RenderSkybox = false
		self.RenderNearby = true

		local nearbyEntity = self.NearbyEntity
		nearbyEntity:SetPos(pos / SKY_CAM_SCALE)
		nearbyEntity:SetAngles(ang)
	else
		self.RenderSkybox = true
		self.RenderNearby = false

		local modelScale = self.Scale or 1
		local skyboxEntity = self.SkyboxEntity
		if distance >= VECTOR_MAX then
			pos = dir * VECTOR_MAX

			skyboxEntity:SetModelScale(modelScale * (VECTOR_MAX / distance))
		else
			skyboxEntity:SetModelScale(modelScale)
		end

		skyboxEntity:SetPos(pos)
		skyboxEntity:SetAngles(ang)
	end

	self.ProjectedPos = pos
end

function SELF:ApplyModel(ent, modelData)
	local model = modelData
	if istable(modelData) then
		model = modelData.Model
	end

	ent:SetModel(model)

	if istable(modelData) then
		local skinId = modelData.Skin
		if isnumber(skinId) then
			ent:SetSkin(skinId)
		end

		local bodygroupData = modelData.Bodygroups
		if istable(bodygroupData) then
			for i, v in pairs(bodygroupData) do
				ent:SetBodygroup(i, v)
			end
		end
	end
end

function SELF:CreateClientsideModel(modelData)
	local ent = ClientsideModel("models/hunter/blocks/cube1x1x1.mdl", RENDERGROUP_BOTH)
	ent:SetNoDraw(true)

	self:ApplyModel(ent, modelData)

	return ent
end

function SELF:DrawSkybox()
	if not self.RenderSkybox then return end

	self.SkyboxEntity:DrawModel()
end

function SELF:DrawNearby()
	if not self.RenderNearby then return end

	self.NearbyEntity:DrawModel()
end