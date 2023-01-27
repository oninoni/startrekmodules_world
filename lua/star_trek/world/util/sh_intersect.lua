
-- https://gamedev.stackexchange.com/questions/96459/fast-ray-sphere-collision-code
function intersect_origin_sphere(pos, dir, radius)
	local b = pos:Dot(dir)
	local c = pos:Dot(pos) - radius * radius

	-- ray's position outside sphere (c > 0)
	-- ray's direction pointing away from sphere (b > 0)
	if c > 0 and b > 0 then
		return false
	end

	local discr = b * b - c

	-- negative discriminant
	if discr < 0 then
		return false
	end

	-- Clamp t to 0
	local t = -b - math.sqrt(discr)
	t = t < 0 and 0 or t

	-- Return collision point and distance from ray origin
	return pos + dir * t, t
end