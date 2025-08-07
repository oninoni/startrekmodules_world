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

function SELF:Init(pos, ang, model, diameter, spin, lightColorVector)
	model = model or "models/crazycanadian/star_trek/planets/star.mdl"

	SELF.Base.Init(self, pos, ang, model, diameter, spin)

	self:SetLightColorVector(lightColorVector)
end

function SELF:GetClientData(clientData)
	SELF.Base.GetClientData(self, clientData)

	clientData.LightColorVector = self.LightColorVector
end

function SELF:SetLightColorVector(lightColorVector)
	self.LightColorVector = lightColorVector

	self.Updated = true
end