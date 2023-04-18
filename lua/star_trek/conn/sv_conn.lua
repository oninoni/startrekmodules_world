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

function Star_Trek.Navigation:ToggleViewscreen(status)
	if status == nil then
		status = IsValid(self.CenterPillar)
	end

	local viewScreen = ents.FindByName("viewscreen")[1]

	if status then
		Star_Trek.Holodeck:Disintegrate(self.CenterPillar, false, function()
			viewScreen:SetNoDraw(false)

			if IsValid(self.BlackBack) then
				self.BlackBack:Remove()
				self.BlackBack = nil
			end
		end)
	else
		viewScreen:SetNoDraw(true)

		-- Remove the Pillar (Sanity Check)
		if IsValid(self.CenterPillar) then
			self.CenterPillar:Remove()
			self.CenterPillar = nil
		end

		local pillar = ents.Create("prop_physics")
		pillar:SetRenderMode(RENDERMODE_TRANSALPHA)
		pillar:SetModel("models/kingpommes/startrek/intrepid/holo_beam.mdl")
		pillar:SetPos(viewScreen:GetPos() - viewScreen:GetForward() * 11 - viewScreen:GetUp() * 2.5)
		pillar:SetAngles(Angle(0, -90, 0))
		pillar:DrawShadow(false)
		self.CenterPillar = pillar

		local leftGrid = ents.Create("prop_physics")
		leftGrid:SetRenderMode(RENDERMODE_TRANSALPHA)
		leftGrid:SetModel("models/kingpommes/startrek/intrepid/holo_wall.mdl")
		leftGrid:SetPos(pillar:GetPos() - pillar:GetForward() * 66 - pillar:GetRight() * 20)
		leftGrid:SetAngles(Angle(0, -105, 0))
		leftGrid:SetParent(pillar)
		leftGrid:DrawShadow(false)
		self.LeftGrid = leftGrid

		local rightGrid = ents.Create("prop_physics")
		rightGrid:SetRenderMode(RENDERMODE_TRANSALPHA)
		rightGrid:SetModel("models/kingpommes/startrek/intrepid/holo_wall.mdl")
		rightGrid:SetPos(pillar:GetPos() + pillar:GetForward() * 66 - pillar:GetRight() * 20)
		rightGrid:SetAngles(Angle(0, -75, 0))
		rightGrid:SetParent(pillar)
		rightGrid:DrawShadow(false)
		self.RightGrid = rightGrid

		local blackBar = ents.Create("prop_physics")
		blackBar:SetModel("models/hunter/plates/plate1x6.mdl")
		blackBar:SetMaterial("models/debug/debugwhite")
		blackBar:SetColor(Color(0, 0, 0))
		blackBar:SetPos(viewScreen:GetPos() - viewScreen:GetForward() * 20 + viewScreen:GetUp() * 100)
		blackBar:SetParent(pillar)
		blackBar:DrawShadow(false)

		local blackBack = ents.Create("prop_physics")
		blackBack:SetModel("models/hunter/plates/plate5x16.mdl")
		blackBack:SetMaterial("models/debug/debugwhite")
		blackBack:SetColor(Color(0, 0, 0))
		blackBack:SetPos(viewScreen:GetPos() - viewScreen:GetForward() * 60)
		blackBack:SetAngles(Angle(90, 0, 0))
		blackBack:DrawShadow(false)
		self.BlackBack = blackBack

		Star_Trek.Holodeck:Disintegrate(self.CenterPillar, true)
	end
end

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

	-- Move from the center.
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

	-- Move back from the Left.
	if yaw == 18 and not moveLeft then
		local ent = ents.FindByName("connBut2")[1]
		if not IsValid(ent) then return end

		ent:Fire("FireUser1")
		return
	end

	-- Move back from the Right.
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