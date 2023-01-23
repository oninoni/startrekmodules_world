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

function SELF:Init(clientData)
	self:SetData(clientData)
	self:SetDynData(clientData)

	local ent = ClientsideModel(self.Model, RENDERGROUP_BOTH)
	ent:SetNoDraw(true)

	self.ClientEntity = ent
end

function SELF:Terminate()
	SafeRemoveEntity(self.ClientEntity)
end

function SELF:SetData(clientData)
	self.Pos = WorldVectorFromTable(clientData.Pos)
	self.Ang = clientData.Ang

	self.Model = clientData.Model
	self.Diameter = clientData.Diameter
	self.Scale = clientData.Scale
end

function SELF:SetDynData(clientData)
end

local VECTOR_MAX = Star_Trek.World.Vector_Max or 131071
function SELF:RenderThink(shipPos, shipAng)
	local realEnt = self.ClientEntity

	local pos, ang = WorldToLocalBig(self.Pos, self.Ang, shipPos, shipAng)
	local distance = pos:Length()
	self.Distance = distance

	-- Apply scaling
	local modelScale = self.Scale or 1
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
end

function SELF:Draw()
	self.ClientEntity:DrawModel()
end