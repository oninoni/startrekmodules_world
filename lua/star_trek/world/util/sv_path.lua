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
--       Path Planning | Server      --
---------------------------------------

local MAX_DEPTH = 8

-- Calculates the distance to a line AB from a point C.
--
-- @param WorldVector a
-- @param WorldVector b
-- @param WorldVector c
-- @return Number closestApproach
-- @return WorldVector approachPos
-- @return Number approachPoint
function Star_Trek.World:DistanceToLine(a, b, c)
	local ab = b - a
	local abLen = ab:Length()

	local ac = c - a
	local acLen = ac:Length()

	local area = ab:Cross(ac):Length()
	local cdLen = area / abLen

	local adLen = math.sqrt(acLen ^2 - cdLen)
	local d = a + ab:GetNormalized() * adLen

	return cdLen, d, adLen
end

-- Plots a course through the loaded entities and loaded systems.
-- 
-- @param Number shipId
-- @param WorldVector startPos
-- @param WorldVector endPos
-- @param Number depth
-- @return Boolean success
-- @return Table/String course/error
function Star_Trek.World:PlotCourse(shipId, startPos, endPos, depth)
	depth = depth or MAX_DEPTH

	if depth == 0 then
		return false, "Maximum Depth Reached"
	end

	local distance = startPos:Distance(endPos)

	for id, ent in pairs(self.Entities) do
		if id == shipId then continue end
		if not ent.Solid then continue end

		local pos = ent.Pos

		local closestApproach, approachPos, approachPoint = Star_Trek.World:DistanceToLine(startPos, endPos, pos)
		if closestApproach == 0 then
			local dir = endPos - startPos

			closestApproach = 1
			approachPos = pos + dir:GetNormalized():Angle():Right() * 1
			approachPoint = approachPos:Distance(startPos)
		end

		-- Check if object is beyond course.
		if approachPoint > distance or approachPoint < 0 then
			-- No Collision
			continue
		end

		-- Check if object is far enough away from course.
		local orbitDistance = ent.Diameter * Star_Trek.World.MinimumOrbitMultiplier
		local minimumApproach = orbitDistance * 0.5
		if closestApproach > minimumApproach then
			-- No Collision
			continue
		end

		-- Collision Detected.
		local ang1 = math.asin(orbitDistance / pos:Distance(startPos))
		local ang2 = math.atan(closestApproach / approachPoint)
		local ang3 = ang1 - ang2

		local h = math.tan(ang3) * approachPoint
		local h2 = closestApproach + h
		local n = -pos + approachPos
		n = n:GetNormalized()

		local segmentPoint = pos + n * h2

		if segmentPoint:Distance(endPos) > startPos:Distance(endPos) then
			return false, "Backwards Movement Detected"
		end

		-- Recursion
		local success1, p1 = self:PlotCourse(shipId, startPos    , segmentPoint, depth - 1)
		local success2, p2 = self:PlotCourse(shipId, segmentPoint,       endPos, depth - 1)

		-- Try other side, if one of the segments failed.
		if not success1 or not success2 then
			segmentPoint = pos - n * h2

			success1, p1 = self:PlotCourse(shipId, startPos    , segmentPoint, depth - 1)
			success2, p2 = self:PlotCourse(shipId, segmentPoint,       endPos, depth - 1)
		end

		if not success1 then return false, p1 end
		if not success2 then return false, p2 end

		assert(p1[#p1] == p2[1], "Oh shit!")

		for i = 2, #p2 do
			table.insert(p1, p2[i])
		end

		return true, p1

		-- TODO: 3 Segment Solution aswell + Compare which one is better. (2x path of 3 segment < path of 2 segment -> use, because of rotate time.)
	end

	-- No Collision
	return true, {startPos, endPos}
end