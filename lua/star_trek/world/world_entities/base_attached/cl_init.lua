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
--       Base Attached | Client      --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(clientData)
	SELF.Base.Init(self, clientData)
end

function SELF:SetData(clientData)
	self.Model = clientData.Model
	self.Material = clientData.Material

	self.Diameter = clientData.Diameter
	self.Scale = clientData.Scale

	self.Pos = WorldVectorFromTable(clientData.Pos)
	self.Ang = clientData.Ang

	self.OffsetPos = clientData.OffsetPos
	self.OffsetAng = clientData.OffsetAng

	self.ParentEnt = Star_Trek.World.Entities[clientData.ParentId]
end

function SELF:SetDynData(clientData)
end