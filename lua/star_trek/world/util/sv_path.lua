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

-- Plots a course through the loaded entities and loaded systems.
-- 
-- @param Number shipId
-- @param WorldVector startPos
-- @param WorldVector endPos
-- @param Number depth
-- @return Table course
function Star_Trek.World:PlotCourse(shipId, startPos, endPos, depth)
	depth = depth or 10

	if depth == 0 then
		return {startPos, endPos}
	end

	local fullDistance = startPos:Distance(endPos)
	local halfDistance = fullDistance / 2
	for id, ent in pairs(self.Entities) do
		if id == shipId then continue end
		if not ent.Solid then continue end

		local pos = ent.Pos
		local distance = pos:Distance(startPos)

		local closestDistance, closestPos, closestPosDistance = util.DistanceToLine(startPos:ToVector(), endPos:ToVector(), pos:ToVector())
		-- TODO: closestDistance can be 0!

		-- Check if object is beyond course.
		if closestPosDistance > distance or closestPosDistance < 0 then
			-- No Collision
			continue
		end

		-- Check if object is far away form course.
		local r = ent.Diameter * 0.5 * Star_Trek.World.MinimumOrbitMultiplier
		if closestDistance > r * 0.99 then -- TODO: Improve Margin
			-- No Collision
			continue
		end

		-- Flip, if other side is closes.
		if closestPosDistance > halfDistance then
			closestPosDistance = fullDistance - closestPosDistance
			distance = fullDistance - distance
		end

		-- Collision Detected.
		local ang1 = math.asin(r / distance)
		local ang2 = math.atan(closestDistance / closestPosDistance)
		local ang3 = ang1 - ang2

		local h = math.tan(ang3) * closestPosDistance
		local h2 = closestDistance + h
		local n = -pos + closestPos
		n = n:GetNormalized()

		local segmentPoint = pos + n * h2

		-- Recursion
		local p1 = self:PlotCourse(shipId, startPos, segmentPoint, depth - 1)
		local p2 = self:PlotCourse(shipId, segmentPoint, endPos, depth - 1)
		assert(p1[#p1] == p2[1], "Oh shit!")

		for i = 2, #p2 do
			table.insert(p1, p2[i])
		end

		return p1

		-- TODO: 3 Segment Solution aswell + Compare which one is better. (2x path of 3 segment < path of 2 segment -> use, because of rotate time.)
	end

	return {startPos, endPos}
end