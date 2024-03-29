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
--     Base Acceleration | Server    --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(pos, ang, model, diameter, vel, angVel, acc, angAcc)
	SELF.Base.Init(self, pos, ang, model, diameter, vel, angVel)

	self:SetAcceleration(acc)
	self:SetAngularAcceleration(angAcc)
end

function SELF:GetClientData(clientData)
	clientData.Model = self.Model
	clientData.Material = self.Material

	clientData.Diameter = self.Diameter
	clientData.Scale = self.Scale

	clientData.Acc = self.Acc
	clientData.AngAcc = self.AngAcc
end

function SELF:GetClientDynData(clientData)
	clientData.Pos = self.Pos
	clientData.Ang = self.Ang

	clientData.Vel = self.Vel
	clientData.AngVel = self.AngVel
end

function SELF:SetAcceleration(acc)
	self.Acc = acc or Vector()

	self.Updated = true
end

function SELF:SetAngularAcceleration(angAcc)
	self.AngAcc = angAcc or Angle()

	self.Updated = true
end
