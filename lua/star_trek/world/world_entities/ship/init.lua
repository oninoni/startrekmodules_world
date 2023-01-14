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
--           Ship | Server           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

-- Degree per second.
local TURN_SPEED = 30
-- Maximum Acceleration / Decceleration
local MAX_ACCEL = C(1)
-- Minimum Warp Speed
local MIN_WARP = C(1)

function SELF:Init(pos, ang, model, diameter)
	SELF.Base.Init(self, pos, ang, model, diameter)
end

function SELF:Think(deltaT)
	SELF.Base.Think(self, deltaT)

	-- Think hook for executing maneuvers.
	local maneuverData = self.ActiveManeuver
	if maneuverData then
		self:ManeuverThink(maneuverData)
	end
end

function SELF:GetClientDynData(clientData)
	SELF.Base.GetClientDynData(self, clientData)

	clientData.ActiveManeuver = self.ActiveManeuver
	clientData.ManeuverStart = self.ManeuverStart
end

-- Perform the given maneuver, ending a current one, if active.
--
-- @param Table maneuverData
-- @param Function callback
function SELF:TriggerManeuver(maneuverData, callback)
	self.ActiveManeuver = maneuverData
	self.ManeuverCallback = callback

	self.ManeuverStart = CurTime()
	self.Updated = true
end

--------------------------------
--      Maneuver Planning     --
--------------------------------

-- Creates a maneuver moving a ship to a given position.
--
-- @param WorldVector startPos
-- @param Vector startSpeed
-- @param WorldVector endPos
-- @param Vector endSpeed
-- @param Number targetSpeed
-- @return Table maneuverData
function SELF:CreateWarpManeuver(startPos, startSpeed, endPos, endSpeed, targetSpeed)
	targetSpeed = math.max(MIN_WARP, targetSpeed)

	local maneuverData = {
		Type = "WARP",
		StartPos = startPos,
		EndPos   = endPos,

		TargetSpeed = targetSpeed,
		StartSpeed = startSpeed,
		EndSpeed = endSpeed,
	}

	local diff = endPos - startPos
	local distance = diff:Length()

	-- Prep Distances and times.
	local accelSpeedDiff = targetSpeed - startSpeed
	local accelDuration = accelSpeedDiff / MAX_ACCEL
	local accelDistance = startSpeed * accelDuration + accelSpeedDiff * accelDuration / 2

	local deccelSpeedDiff = targetSpeed - endSpeed
	local deccelDuration = deccelSpeedDiff / MAX_ACCEL
	local deccelDistance = endSpeed * deccelDuration + deccelSpeedDiff * deccelDuration / 2

	local coastDistance = distance - accelDistance - deccelDistance
	-- TODO: Short Distances, that dont reach target Speed (negative)
	maneuverData.CoastDuration = coastDistance / targetSpeed

	-- Calculate time frames.
	maneuverData.Duration = accelDuration + maneuverData.CoastDuration + deccelDuration

	maneuverData.AccelTime = accelDuration

	maneuverData.DeccelTime = accelDuration + maneuverData.CoastDuration
	maneuverData.DeccelDuration = deccelDuration

	-- Calculate Positions
	local dir = diff:GetNormalized()

	maneuverData.AccelPos = startPos + dir * accelDistance
	maneuverData.DeccelPos = endPos - dir * deccelDistance

	return maneuverData
end

-- Create a maneuver aligning a ship to a given angle.
--
-- @param Angle startAngle
-- @param Angle targetAngle
-- @return Table maneuverData
function SELF:CreateAlignManeuver(startAngle, targetAngle)
	local maneuverData = {
		Type = "ALIGN",
		StartAngle = startAngle,
		TargetAngle = targetAngle,
	}

	local diffAng = startAngle - targetAngle
	diffAng:Normalize()

	local maxAng = math.max(math.abs(diffAng.y), math.abs(diffAng.p), math.abs(diffAng.r))
	maneuverData.Duration = maxAng / TURN_SPEED

	return maneuverData
end

-- Helper function to align against a target.
--
-- @param WorldVector startPos
-- @param Angle startAngle
-- @param WorldVector targetPos
-- @return Table maneuverData
function SELF:CreateAlignManeuverAt(startPos, startAng, targetPos)
	local direction = (targetPos - startPos):GetNormalized()

	return self:CreateAlignManeuver(startAng, direction:Angle())
end