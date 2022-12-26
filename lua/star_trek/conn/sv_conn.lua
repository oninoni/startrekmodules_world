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
--    Control Navigation | Server    --
---------------------------------------

hook.Add("Star_Trek.LCARS.PreOpenInterface", "Star_Trek.Navigation.BlockMap", function(ent, interfaceName)
	if interfaceName ~= "basic" then return end

	local name = ent:GetName()
	if string.StartWith(name, "connBut") then return true end
	if name == "bridgeViewscreenButton4" then return true end
end)

function Star_Trek.Navigation:RotateChair(veh, moveLeft)
	local rotButton = veh:GetParent()
	local rotAng = rotButton:GetAngles()
	local yaw = rotAng.y

	if yaw == 0 then
		if moveLeft then
			local ent = ents.FindByName("connBut2")[1]
			if not IsValid(ent) then return end

			ent:Fire("FireUser1")
			return
		else
			local ent = ents.FindByName("connBut3")[1]
			if not IsValid(ent) then return end

			ent:Fire("FireUser1")
			return
		end
	end

	if yaw == 18 and not moveLeft then
		local ent = ents.FindByName("connBut2")[1]
		if not IsValid(ent) then return end

		ent:Fire("FireUser1")
		return
	end

	if yaw == -18 and moveLeft then
		local ent = ents.FindByName("connBut3")[1]
		if not IsValid(ent) then return end

		ent:Fire("FireUser1")
		return
	end
end

hook.Add("KeyPress", "Star_Trek.Navigation.ButtonDown", function(ply, key)
	local veh = ply:GetVehicle()
	if not IsValid(veh) then return end

	local name = veh:GetName()
	if name ~= "connSeat" then return end

	if ply:KeyDown(IN_WALK) then
		if key == IN_MOVELEFT then
			Star_Trek.Navigation:RotateChair(veh, true)
			return
		end

		if key == IN_MOVERIGHT then
			Star_Trek.Navigation:RotateChair(veh, false)
			return
		end

		if key == IN_RELOAD then
			Star_Trek.LCARS:ToggleScreenClicker(ply, true)
			return
		end
	end
end)

hook.Add("PlayerEnteredVehicle", "Star_Trek.Navigation.OppenConsole", function(ply, veh)
	local name = veh:GetName()
	if name ~= "connSeat" then return end

	local success, error = Star_Trek.LCARS:OpenInterface(ply, Star_Trek.Navigation.Button, "conn")
	if not success then
		print("Error: ", error)
		return
	end
end)

hook.Add("PlayerLeaveVehicle", "Star_Trek.Navigation.FixMouse", function(ply, veh)
	local name = veh:GetName()
	if name ~= "connSeat" then return end

	Star_Trek.LCARS:SetScreenClicker(ply, false, true)
end)