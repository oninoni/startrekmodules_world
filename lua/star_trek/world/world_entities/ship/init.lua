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
local TURN_SPEED = 20
-- Maximum Acceleration / Decceleration
local MAX_ACCEL = C(10)
-- Minimum time the ship will take to accelerate to full speed.
local MIN_ACCEL_TIME = 15

-- Minimum Warp Speed
local MIN_WARP = W(1)
-- Maximum Warp Speed
local MAX_WARP = W(9.99)

function SELF:Init(pos, ang, model, diameter)
	SELF.Base.Init(self, pos, ang, model, diameter)
end

function SELF:GetClientData(clientData)
	SELF.Base.GetClientData(self, clientData)

	local activeManeuver = self.ActiveManeuver
	if activeManeuver then
		clientData.ActiveManeuver = activeManeuver
		clientData.ManeuverOffset = SysTime() - self.ManeuverStart
	else
		clientData.ActiveManeuver = false
	end
end

-- Perform the given maneuver, ending a current one, if active.
--
-- @param Table maneuverData
-- @param Function callback
function SELF:TriggerManeuver(maneuverData, callback)
	self.ActiveManeuver = maneuverData
	self.ManeuverCallback = callback

	self.ManeuverStart = SysTime()
	self.Updated = true
end

function SELF:AbortCourse()
	if istable(self.Course) then
		self.Course = nil
		self.CourseStep = nil
		self.CourseCallback = nil
		self.CourseTargetSpeed = nil

		self.ActiveManeuver = nil
		self.ManeuverCallback = nil
		self.ManeuverStart = nil

		self.Vel = Vector()
		self.Acc = Vector()
		self.AngVel = Angle()
		self.AngAcc = Angle()

		self.Updated = true

		return true
	end
end

function SELF:ExecuteCourseStep()
	local step = self.CourseStep
	local startPos = self.Course[step]
	local endPos = self.Course[step + 1]

	if not IsWorldVector(endPos) then
		local callback = self.CourseCallback
		if isfunction(callback) then
			callback(self)
		end

		self.Course = nil
		self.CourseStep = nil
		self.CourseCallback = nil
		self.CourseTargetSpeed = nil

		return
	end

	self.CourseStep = self.CourseStep + 1

	-- Execute Course Segment
	local maneuverData1 = self:CreateAlignManeuverAt(startPos, self.Ang, endPos)
	self:TriggerManeuver(maneuverData1, function(_)
		local maneuverData2 = self:CreateWarpManeuver(startPos, endPos, self.CourseTargetSpeed) -- TODO: Set Speed
		self:TriggerManeuver(maneuverData2, function(_)
			self:ExecuteCourseStep()
		end)
	end)
end

function SELF:ExecuteCourse(course, targetSpeed, callback)
	self.Course = course
	self.CourseStep = 1
	self.CourseCallback = callback
	self.CourseTargetSpeed = targetSpeed

	self:ExecuteCourseStep()
end

function SELF:PlotCourse(targetPos)
	return Star_Trek.World:PlotCourse(self.Id, self.Pos, targetPos)
end

--------------------------------
--      Maneuver Planning     --
--------------------------------

-- Creates a maneuver moving a ship to a given position.
--
-- @param WorldVector startPos
-- @param WorldVector endPos
-- @param Number targetSpeed
-- @return Table maneuverData
function SELF:CreateWarpManeuver(startPos, endPos, targetSpeed)
	targetSpeed = math.min(MAX_WARP, math.max(MIN_WARP, targetSpeed))

	local maneuverData = {
		Type = "WARP",
		StartPos = startPos,
		EndPos   = endPos,

		TargetSpeed = targetSpeed,
	}

	local diff = endPos - startPos
	local distance = diff:Length()
	maneuverData.Distance = distance

	-- Determine Acceleration
	local acceleration = math.min(MAX_ACCEL, targetSpeed / MIN_ACCEL_TIME)

	-- Prep Distances and times.
	local accelDuration = targetSpeed / acceleration
	local accelDistance = targetSpeed * accelDuration / 2

	local coastDistance = distance - 2 * accelDistance
	if coastDistance < 0 then
		coastDistance = 0

		local distanceReductionFactor = distance / (2 * accelDistance)
		accelDistance = accelDistance * distanceReductionFactor
		accelDuration = math.sqrt((accelDuration * 2 * accelDistance) / targetSpeed)
	end

	-- Calculate time frames.
	maneuverData.AccelTime = accelDuration
	maneuverData.CoastDuration = coastDistance / targetSpeed
	maneuverData.DeccelTime = accelDuration + maneuverData.CoastDuration
	maneuverData.DeccelDuration = accelDuration

	maneuverData.Duration = maneuverData.CoastDuration + 2 * accelDuration

	-- Calculate Positions
	local dir = diff:GetNormalized()
	maneuverData.AccelPos = startPos + dir * accelDistance
	maneuverData.DeccelPos = endPos - dir * accelDistance

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

	local diffAng = targetAngle - startAngle
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