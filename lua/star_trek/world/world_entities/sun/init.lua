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
--            Sun | Server           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(pos, ang, model, diameter, spin, lightColor, magnitude)
	model = model or "models/crazycanadian/star_trek/planets/star.mdl"

	SELF.Base.Init(self, pos, ang, model, diameter, spin)

	self:SetLightColor(lightColor)
	self:SetMagnitude(magnitude)
end

function SELF:GetClientData(clientData)
	SELF.Base.GetClientData(self, clientData)

	clientData.LightColor = self.LightColor
	clientData.Magnitude = self.Magnitude
end

function SELF:SetLightColor(lightColor)
	self.LightColor = lightcolor

	self.Updated = true
end

function SELF:SetMagnitude(magnitude)
	self.Magnitude = magnitude

	self.Updated = true
end