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
--         Science | Index           --
---------------------------------------

Star_Trek:RequireModules("lcars")

Star_Trek.Science = Star_Trek.Science or {}
Star_Trek.Science.Particles = { -- TODO make this a config

	["Nadion"] = {Color = Color(255, 143, 5)},
	["Tachyon"] = {Color = Color(14, 207, 203)},
	["Antitachyon"] = {Color = Color(176, 99, 37)},
	["Tetryon"] = {Color = Color(37, 16, 176)},
	["Graviton"] = {Color = Color(0, 224, 138)},
	["Polaron"] = {Color = Color(88, 76, 247) },
	["Hadron"] = {Color = Color(255, 255, 255)},
	["Baryon"] = {Color = Color(0, 255, 34)},
	["Veteron"] = {Color = Color(252, 206, 0)},
	["Chroniton"] = {Color = Color(3, 0, 202)},
	["Antichroniton"] = {Color = Color(255, 0, 255) },
	["Lepton"] = {Color = Color(255, 255, 255)},
	["Antilepton"] = {Color = Color(255, 255, 255)},
	["Neutrino"] = {Color = Color(123, 165, 255)},
	["Antineutrino"] = {Color = Color(123, 165, 255)},
	["Thoron"] = {Color = Color(255, 217 ,0)},
	["Antithoron"] = {Color = Color(255, 217 ,0)},
	["Anyon"] = {Color = Color(225, 0 ,255)},
	["Dekyon"] = {Color = Color(255, 0, 0)},
	["Meson"] = {Color = Color(105, 105, 105)},
	["Metreon"] = {Color = Color(255, 109, 248) },
	["Positron"] = {Color = Color(131, 199, 255)},
}
if SERVER then
	include("sv_science.lua")
	include("sh_deflector.lua")
	AddCSLuaFile("sh_deflector.lua")
end

if CLIENT then
	include("sh_deflector.lua")
	return
end

if game.GetMap() ~= "rp_intrepid_v1" then return end

local setupButton = function()

	if IsValid(Star_Trek.Science.Button) then
		Star_Trek.Science.Button:Remove()
	end

	pos = Vector(-235, -268, 13375)
	ang = Angle(0, 0 , 0)

	local success, ent = Star_Trek.Button:CreateInterfaceButton(pos, ang, "models/hunter/blocks/cube05x2x025.mdl", "science")
	if not success then
		print(ent)
	end
	Star_Trek.Science.Button = ent

end
hook.Add("InitPostEntity", "Star_Trek.Science.SpawnButton", setupButton)
hook.Add("PostCleanupMap", "Star_Trek.Science.SpawnButton", setupButton)