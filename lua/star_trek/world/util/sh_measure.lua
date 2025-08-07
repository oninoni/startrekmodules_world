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
--        Measurement | Shared       --
---------------------------------------

-- Get the diameter of a model.
--
-- @param string model
-- @return number diameter
function Star_Trek.World:GetModelDiameter(model)
	local ent = ents.Create("prop_physics")
	ent:SetPos(Vector(0, 0, 0))
	ent:SetModel(model)
	ent:Spawn()

	--local min, max = ent:GetModelBounds()
	local min, max = ent:GetSurroundingBounds()
	SafeRemoveEntity(ent)

	local scale = max - min
	return math.max(
		math.abs(scale.x),
		math.abs(scale.y),
		math.abs(scale.z)
	)
end

-- Show a human readable time from seconds.
--
-- @param number time
-- @return string timeString
function Star_Trek.World:MeasureTime(time)
	local timeTable = string.FormattedTime(time)

	if timeTable.h > 0 then
		return string.format("%02dh %02dm %02ds", timeTable.h, timeTable.m, timeTable.s)
	end

	if timeTable.m > 0 then
		return string.format("%02dm %02ds", timeTable.m, timeTable.s)
	end

	return string.format("%02ds", timeTable.s)
end

-- Show a human readable distance from skybox units.
--
-- @param number distance
-- @return string distanceString
function Star_Trek.World:MeasureDistance(distance)
	local distanceLY = SBtoLY(distance)
	if distanceLY >= 1 then
		return string.format("%-8.2fLY", math.Round(distanceLY, 2))
	end

	local distanceAU = SBtoAU(distance)
	if distanceAU >= 0.01 then
		return string.format("%-8.2fAU", math.Round(distanceAU, 2))
	end

	local distanceKM = SBtoKM(distance)
	if distanceKM >= 0.01 then
		return string.format("%-8.2fKM", math.Round(distanceKM, 2))
	end

	local distanceM = SBtoM(distance)
	return string.format("%-8.2fM", math.Round(distanceM, 2))
end

function Star_Trek.World:MeasureSpeed(speed)

end