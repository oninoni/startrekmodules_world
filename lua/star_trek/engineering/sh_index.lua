Star_Trek:RequireModules("lcars")

Star_Trek.Engineering = Star_Trek.Engineering or {}
Star_Trek.Engineering.ChairPos = Star_Trek.Engineering.ChairPos or Vector(-212, 236, 13328)
Star_Trek.Engineering.SelectedParticleButton = Star_Trek.Engineering.SelectedParticleButton or nil

if SERVER then 
	include("sv_engineering.lua")
end

if CLIENT then 
	return
end
