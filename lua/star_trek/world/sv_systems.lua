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
--       Star Systems | Server       --
---------------------------------------

-- Load all objects in a leaf.
--
-- @param Table leaf
-- @return Boolean success
-- @return? String error
function Star_Trek.World:LoadStarSystem(leaf)
	if leaf.Loaded then return end

	local leafPos = WorldVector(0, 0, 0, leaf.X, leaf.Y, 0)
	for _, entData in pairs(leaf.Data.Entities) do
		local override = hook.Run("Star_Trek.World.LoadStarSystem", leaf, entData)
		if override then continue end

		local orbitDir = Angle(math.random(0, 360), 0, 0):Forward()
		local orbitWorldDir = WorldVector(0, 0, 0, orbitDir.x, orbitDir.z, 0)

		local entPos = leafPos + orbitWorldDir * entData.OrbitRadius
		if isnumber(entData.ParentId) then
			local parent = self.Entities[entData.ParentId]
			if istable(parent) then
				entPos = parent:GetOrbit(entData.OrbitRadius)
			end
		end


		local success, worldEnt = Star_Trek.World:LoadEntity(entData.Id, entData.Class, entPos, entData.Ang or Angle(), entData.Model, entData.Diameter, spin)
		if not success then
			return false, worldEnt
		end
	end

	leaf.Loaded = true
	return true
end

-- Unload all objects in a leaf.
--
-- @param Table leaf
-- @return Boolean success
-- @return? String error
function Star_Trek.World:UnloadStarSystem(leaf)
	if not leaf.Loaded then return end

	for _, entData in pairs(self.Entities) do
		local override = hook.Run("Star_Trek.World.UnloadStarSystem", leaf, entData)
		if override then continue end

		local success, error = Star_Trek.World:UnLoadEntity(entData.Id)
		if not success then
			return false, error
		end
	end

	leaf.Loaded = nil
	return true
end

-- Adding the map ship.
-- An Intrepid class vessel, that is represented by the map.
--
-- @return Boolean success
-- @return String error
function Star_Trek.World:AddMapShip()
	local success, mapShip = Star_Trek.World:LoadEntity(1, "ship", self.Entities[4]:GetStandardOrbit(), Angle(), "models/kingpommes/startrek/intrepid/intrepid_sky_1024.mdl", 1)

	if not success then
		return false, worldEnt
	end

	self.MapShip = mapShip

	return true
end

-- Setup the galaxy.
function Star_Trek.World:LoadGalaxy()
	self.QuadTree = QuadTree(0, 0, LY(Star_Trek.World.MaxDistance))

	local override = hook.Run("Star_Trek.World.LoadGalaxy", self.QuadTree)
	if override then return end

	local leaf = self.QuadTree:CreateLeaf(LY(0), LY(0), {Name = "Sol System", Entities = {
		{Id = 11, OrbitRadius = AU(0), Name = "Sol", Class = "planet", Model = "models/planets/sun.mdl", Diameter = KM(1392700)},
		{Id = 2, OrbitRadius = AU(0.39), Name = "Mercury", Class = "planet", Model = "models/planets/mercury.mdl", Diameter = KM(4880)},
		{Id = 3, OrbitRadius = AU(0.72), Name = "Venus", Class = "planet", Model = "models/planets/venus.mdl", Diameter = KM(12104)},
		{Id = 4, OrbitRadius = AU(1), Name = "Earth", Class = "planet", Model = "models/planets/earth.mdl", Diameter = KM(12142)},
		{Id = 5, OrbitRadius = AU(1.52), Name = "Mars", Class = "planet", Model = "models/planets/mars.mdl", Diameter = KM(6780)},
		{Id = 6, OrbitRadius = AU(5.20), Name = "Jupiter", Class = "planet", Model = "models/planets/jupiter.mdl", Diameter = KM(139822)},
		{Id = 7, OrbitRadius = AU(9.58), Name = "Saturn", Class = "planet", Model = "models/planets/saturn.mdl", Diameter = KM(116464)},
		{Id = 8, OrbitRadius = AU(19.20), Name = "Uranus", Class = "planet", Model = "models/planets/uranus.mdl", Diameter = KM(50724)},
		{Id = 9, OrbitRadius = AU(30.05), Name = "Neptun", Class = "planet", Model = "models/planets/neptune.mdl", Diameter = KM(29244)},

		-- Earth Orbit
		{Id = 10, ParentId = 4, OrbitRadius = KM(385000), Name = "Luna", Class = "planet", Model = "models/planets/luna_big.mdl", Diameter = KM(3474.8)},
	}})
	self.QuadTree:CreateLeaf(LY(-0.6162192048), LY(-12.8379001), {Name = "Vulcan System", Entities = {

	}})
	self.QuadTree:CreateLeaf(LY(6.264895249), LY(-9.756804077), {Name = "Andoria System", Entities = {

	}})
	self.QuadTree:CreateLeaf(LY(-11.86221969), LY(1.386493211), {Name = "Tellar System", Entities = {

	}})

	print(Star_Trek.World:LoadStarSystem(leaf))
	print(Star_Trek.World:AddMapShip())
end

hook.Add("InitPostEntity", "Star_Trek.World.LoadGalaxy", function() Star_Trek.World:LoadGalaxy() end)
hook.Add("PostCleanupMap", "Star_Trek.World.LoadGalaxy", function() Star_Trek.World:LoadGalaxy() end)

local function flyToMars()
	local ship = Star_Trek.World.Entities[1]
	local mars = Star_Trek.World.Entities[10]
	local targetPos = mars:GetStandardOrbit()

	direction = targetPos - ship.Pos
	local dirNorm = direction:ToVector()
	dirNorm:Normalize()
	ship:SetAngle(dirNorm:Angle())

	local distance = direction:Length()
	print(SBtoAU(distance))

	local speedC = Star_Trek.World:WarpToC(1)
	local speed = KM(300000) * speedC
	print(SBtoAU(speed))

	local travelTime = distance / speed
	print(travelTime)

	ship:SetVelocity(dirNorm * speed)

	timer.Simple(travelTime, function()
		ship:SetVelocity(Vector())
	end)
end

flyToMars()