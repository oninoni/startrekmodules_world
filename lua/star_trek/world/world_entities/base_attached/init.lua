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
--       Base Attached | Server      --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(pos, ang, model, diameter, parentId)
	SELF.Base.Init(self, WorldVector(), Angle(), model, diameter)

	self.OffsetPos = pos:ToVector()
	self.OffsetAng = ang

	self:SetParentId(parentId)
end

function SELF:GetClientData(clientData)
	clientData.Model = self.Model
	clientData.Diameter = self.Diameter
	clientData.Scale = self.Scale

	clientData.Pos = self.Pos
	clientData.Ang = self.Ang

	clientData.OffsetPos = self.OffsetPos
	clientData.OffsetAng = self.OffsetAng

	clientData.ParentId = self.ParentId
end

function SELF:GetClientDynData(clientData)
end

function SELF:SetPos(pos)
	self.OffsetPos = pos

	self.Updated = true
end

function SELF:SetAngles(ang)
	self.OffsetAng = ang

	self.Updated = true
end

function SELF:SetParentId(parentId)
	if not isnumber(parentId) then return end

	local parentEnt = Star_Trek.World.Entities[parentId]
	if not istable(parentEnt) then return end

	self.ParentId = parentId
	self.ParentEnt = parentEnt

	self.Updated = true
end

function SELF:SetParent(parentEnt)
	if not istable(parentEnt) then return end

	self:SetParentId(parentEnt.Id)
end