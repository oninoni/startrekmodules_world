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
--     Base Acceleration | Client    --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(clientData)
	SELF.Base.Init(self, clientData)
end

function SELF:SetData(clientData)
	self.Model = clientData.Model
	self.Diameter = clientData.Diameter
	self.Scale = clientData.Scale

	self.Acc = clientData.Acc
	self.AngAcc = clientData.AngAcc
end

function SELF:SetDynData(clientData)
	local pos = clientData.Pos
	self.Pos = WorldVector(pos[1], pos[2], pos[3], pos[4], pos[5], pos[6])
	self.Ang = clientData.Ang

	self.Vel = clientData.Vel
	self.AngVel = clientData.AngVel
end