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
--    Copyright © 2022 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--     Control Navigation | Index    --
---------------------------------------

Star_Trek:RequireModules("lcars") -- TODO: Add world

Star_Trek.Navigation = Star_Trek.Navigation or {}

if SERVER then
	include("sv_conn.lua")
end

if CLIENT then
	return
end

if game.GetMap() ~= "rp_intrepid_v1" then return end

local setupButton = function()
	if IsValid(Star_Trek.Navigation.Button) then
		Star_Trek.Navigation.Button:Remove()
	end

	local connBut2 = ents.FindByName("connBut2")[1]
	local pos = connBut2:GetPos()
	local ang = Angle()
	pos.y = 0

	local success, ent = Star_Trek.Button:CreateInterfaceButton(pos, ang, "models/hunter/blocks/cube05x2x025.mdl", "conn")
	if not success then
		print(ent)
	end
	Star_Trek.Navigation.Button = ent
end

hook.Add("InitPostEntity", "Star_Trek.Navigation.SpawnButton", setupButton)
hook.Add("PostCleanupMap", "Star_Trek.Navigation.SpawnButton", setupButton)