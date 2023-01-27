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
--           Beam | Server           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(pos, ang, length, parentId, material, color, width, tiling, stream)
	SELF.Base.Init(self, pos, ang, "models/squad/sf_bars/sf_bar25x25x8.mdl", length, parentId)

	self.Color = color or Color(255, 255, 255, 127)
	self.Width = width or 1
	self.Tiling = tiling or 512
	self.Stream = -stream or 0

	self:SetMaterial(material)
end

function SELF:GetClientData(clientData)
	SELF.Base.GetClientData(self, clientData)

	clientData.Color = self.Color
	clientData.Width = self.Width
	clientData.Tiling = self.Tiling
	clientData.Stream = self.Stream
end