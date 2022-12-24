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
--          Planet | Server          --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(pos, ang, model, diameter, spin)
	model = model or "models/planets/earth.mdl"

	SELF.Base.Init(self, pos, ang, model, diameter, Vector(), Angle(0, spin, 0))
end

function SELF:SetSpin(spin)
	self:SetAngularVelocity(Angle(0, spin, 0))
end