Star_Trek:RequireModules("lcars")

Star_Trek.Engineering = Star_Trek.Engineering or {}
Star_Trek.Engineering.ChairPos = Vector(-212, 236, 13328) -- TODO change to chair.pos

if SERVER then
	include("sv_engineering.lua")
end

if CLIENT then
	return
end
