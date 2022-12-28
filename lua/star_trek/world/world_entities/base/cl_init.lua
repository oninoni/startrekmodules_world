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
	local pos = clientData.Pos
	self.Pos = WorldVector(pos[1], pos[2], pos[3], pos[4], pos[5], pos[6])
	self.Ang = clientData.Ang

	self.Model = clientData.Model
	self.Diameter = clientData.Diameter
	self.Scale = clientData.Scale
end

function SELF:SetDynData(clientData)
end