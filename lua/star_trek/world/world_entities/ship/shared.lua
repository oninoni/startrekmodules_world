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
--           Ship | Shared           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

SELF.BaseClass = "base_acc"

SELF.Dynamic = true

function SELF:ResetManeuver()
	self.ActiveManeuver = nil
	self.ManeuverStart = nil

	if SERVER then
		local callback = self.ManeuverCallback
		if isfunction(callback) then
			callback(self)
		end

		self.ManeuverCallback = nil
		self.Updated = true
	end
end

function SELF:ManeuverThink(maneuverData)
	local time = CurTime() - self.ManeuverStart

	local maneuverType = maneuverData.Type
	if maneuverType == "WARP" then
		local endPos = maneuverData.EndPos

		if time >= maneuverData.Duration then
			self.Pos = endPos
			self.Vel = Vector()
			self.Acc = Vector()

			self:ResetManeuver()
		elseif time >= maneuverData.DeccelTime then
			local lerp = math.ease.OutQuad((time - maneuverData.DeccelTime) / maneuverData.DeccelDuration)
			self.Pos = Lerp(lerp, maneuverData.DeccelPos, endPos)
		elseif time >= maneuverData.AccelTime then
			local lerp = (time - maneuverData.AccelTime) / maneuverData.CoastDuration
			self.Pos = Lerp(lerp, maneuverData.AccelPos, maneuverData.DeccelPos)
		else
			local lerp = math.ease.InQuad(time / maneuverData.AccelTime)
			self.Pos = Lerp(lerp, maneuverData.StartPos, maneuverData.AccelPos)
		end
	elseif maneuverType == "ALIGN" then
		local targetAngle = maneuverData.TargetAngle

		if time >= maneuverData.Duration then
			self.Ang = targetAngle
			self.AngVel = Angle()
			self.AngAcc = Angle()

			self:ResetManeuver()
		else
			local lerp = math.ease.InOutSine(time / maneuverData.Duration)
			self.Ang = LerpAngle(lerp, maneuverData.StartAngle, targetAngle)
		end
	elseif maneuverType == "IMPULSE" then
		-- TODO

		return
	end
end