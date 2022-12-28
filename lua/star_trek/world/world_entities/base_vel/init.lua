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
--       Base Velocity | Server      --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(pos, ang, model, diameter, vel, angVel)
	SELF.Base.Init(self, pos, ang, model, diameter)

	self.Vel = vel or Vector()
	self.AngVel = angVel or Angle()
end

function SELF:SetVelocity(vel)
	self.Vel = vel

	self.Updated = true
end

function SELF:SetAngularVelocity(angVel)
	self.AngVel = angVel

	self.Updated = true
end

function SELF:GetClientData(clientData)
	clientData.Model = self.Model
	clientData.Diameter = self.Diameter
	clientData.Scale = self.Scale

	clientData.Vel = self.Vel
	clientData.AngVel = self.AngVel
end

function SELF:GetClientDynData(clientData)
	clientData.Pos = self.Pos
	clientData.Ang = self.Ang
end