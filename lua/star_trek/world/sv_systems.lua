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

Star_Trek.World.LoadedLeafs = {}

-- Load all objects in a leaf.
--
-- @param Table leaf
-- @return Boolean success
-- @return? String error
function Star_Trek.World:LoadStarSystem(leaf)
	if leaf.Loaded then return end

	print("Loading \"" .. leaf.Data.Name .. "\"", leaf)

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
		entPos = entPos + Vector(0, 0, KM(math.random(-10000, 10000)))

		local success, worldEnt = Star_Trek.World:LoadEntity(entData.Id, entData.Class, entPos, entData.Ang or Angle(), entData.Model, entData.Diameter, entData.Spin, entData.LightColor)
		if not success then
			return false, worldEnt
		end

		worldEnt.Name = entData.Name
	end

	table.insert(self.LoadedLeafs, leaf)
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

	print("Unloading \"" .. leaf.Data.Name .. "\"", leaf)

	for _, entData in pairs(leaf.Data.Entities) do
		local override = hook.Run("Star_Trek.World.UnloadStarSystem", leaf, entData)
		if override then continue end

		local success, error = Star_Trek.World:UnLoadEntity(entData.Id)
		if not success then
			return false, error
		end
	end

	table.RemoveByValue(self.LoadedLeafs, leaf)
	leaf.Loaded = nil
	return true
end

-- Update the locations, that should currently be loaded.
function Star_Trek.World:UpdateLocations(x, y, r)
	local leafs = self.QuadTree:QueryBounds(x, y, r)

	local loadedLeafs = {}
	for i, leaf in pairs(self.LoadedLeafs) do
		loadedLeafs[i] = leaf
	end

	for _, leaf in pairs(leafs) do
		Star_Trek.World:LoadStarSystem(leaf)

		table.RemoveByValue(loadedLeafs, leaf)
	end

	for _, leaf in pairs(loadedLeafs) do
		Star_Trek.World:UnloadStarSystem(leaf)
	end
end

timer.Create("Star_Trek.World.UpdateMap", 10, 0, function()
	pcall(function()
		local ship = Star_Trek.World.Entities[1]
		local pos = ship.Pos

		Star_Trek.World:UpdateLocations(pos:GetX(), pos:GetY(), LY(5))
	end)
end)

-- Adding the map ship.
-- An Intrepid class vessel, that is represented by the map.
--
-- @return Boolean success
-- @return String error
function Star_Trek.World:AddMapShip()
	local dir = Angle(0, math.random(0, 360), 0)

	local _, station = Star_Trek.World:LoadEntity(100, "base", self.Entities[4]:GetStandardOrbit(), dir, "models/crazycanadian/star_trek/stations/spacedock.mdl", KM(5))
	station.OrbitOffset = Vector(0, 0, KM(4.2))
	self.Stattion = station

	local _, mapShip = Star_Trek.World:LoadEntity(1, "ship", station:GetStandardOrbit(), Angle(), "models/kingpommes/startrek/intrepid/intrepid_sky_1024.mdl")
	self.MapShip = mapShip

	for i = 1, 10 do
		local pos = LocalToWorldBig(Vector(-M(i * 100), M(i * 100), -M(i * 100)), Angle(), mapShip.Pos, mapShip.Ang)
		Star_Trek.World:LoadEntity(100 + i, "ship", pos, ang, "models/hunter/blocks/cube4x4x4.mdl", M(50))
	end
end

-- Setup the galaxy.
function Star_Trek.World:ReLoadGalaxy()
	local loadedLeafs = table.Copy(self.LoadedLeafs or {})
	for _, leaf in pairs(loadedLeafs) do
		Star_Trek.World:UnloadStarSystem(leaf)
	end
	self.LoadedLeafs = {}

	self.QuadTree = QuadTree(0, 0, LY(Star_Trek.World.MaxDistance))
	local override = hook.Run("Star_Trek.World.LoadGalaxy", self.QuadTree)
	if override then return end

	local solLeaf = self.QuadTree:CreateLeaf(LY(0), LY(0), {Name = "Sol System", Entities = {
		{Id = 11, OrbitRadius = AU(0), Name = "Sol", Class = "sun", Diameter = KM(1392700), LightColor = Vector(1, 1, 1)},
		{Id = 2, OrbitRadius = AU(0.39), Name = "Mercury", Class = "planet", Model = "models/planets/mercury.mdl", Diameter = KM(4880)},
		{Id = 3, OrbitRadius = AU(0.72), Name = "Venus", Class = "planet", Model = "models/planets/venus.mdl", Diameter = KM(12104)},
		{Id = 4, OrbitRadius = AU(1), Name = "Earth", Class = "planet", Model = nil, Diameter = KM(12142)},
		{Id = 5, OrbitRadius = AU(1.52), Name = "Mars", Class = "planet", Model = "models/planets/mars.mdl", Diameter = KM(6780)},
		{Id = 6, OrbitRadius = AU(5.20), Name = "Jupiter", Class = "planet", Model = "models/planets/jupiter.mdl", Diameter = KM(139822)},
		{Id = 7, OrbitRadius = AU(9.58), Name = "Saturn", Class = "planet", Model = "models/planets/saturn.mdl", Diameter = KM(116464)},
		{Id = 8, OrbitRadius = AU(19.20), Name = "Uranus", Class = "planet", Model = "models/planets/uranus.mdl", Diameter = KM(50724)},
		{Id = 9, OrbitRadius = AU(30.05), Name = "Neptun", Class = "planet", Model = "models/planets/neptune.mdl", Diameter = KM(29244)},

		-- Earth Orbit
		{Id = 10, ParentId = 4, OrbitRadius = KM(385000), Name = "Luna", Class = "planet", Model = "models/planets/luna_big.mdl", Diameter = KM(3474.8)},
	}})
	self.QuadTree:CreateLeaf(LY(-0.6162192048), LY(-12.8379001), {Name = "Vulcan System", Entities = {
		{Id = 12, OrbitRadius = AU(0), Name = "40 Eridiani A", Class = "sun", Diameter = KM(1130872.4), LightColor = Vector(1, 1, 1)},
		{Id = 13, OrbitRadius = AU(0.3), Name = "40 Eridiani B", Class = "sun", Diameter = KM(19497.8), LightColor = Vector(1, 1, 1)},
		{Id = 14, OrbitRadius = AU(0.2), Name = "40 Eridiani C", Class = "sun", Diameter = KM(431737), LightColor = Vector(1, 1, 1)},

		{Id = 15, OrbitRadius = AU(0.9), Name = "Vulcan", Class = "planet", Model = "models/planets/mars.mdl", Diameter = KM(12142)},
	}})
	self.QuadTree:CreateLeaf(LY(6.264895249), LY(-9.756804077), {Name = "Andoria System", Entities = {
		{Id = 16, OrbitRadius = AU(0), Name = "Procyon A", Class = "sun", Diameter = KM(2855035), LightColor = Vector(1, 1, 1)},
		{Id = 17, OrbitRadius = AU(0.3), Name = "Procyon B", Class = "sun", Diameter = KM(16712.4), LightColor = Vector(1, 1, 1)},

		{Id = 18, OrbitRadius = AU(2), Name = "Andor", Class = "planet", Model = "models/planets/earth.mdl", Diameter = KM(12142)},
	}})
	self.QuadTree:CreateLeaf(LY(-11.86221969), LY(1.386493211), {Name = "Tellar System", Entities = {
		{Id = 19, OrbitRadius = AU(0), Name = "61 Cygni A", Class = "sun", Diameter = KM(926145.5), LightColor = Vector(1, 1, 1)},
		{Id = 20, OrbitRadius = AU(0.2), Name = "61 Cygni B", Class = "sun", Diameter = KM(828656.5), LightColor = Vector(1, 1, 1)},

		{Id = 21, OrbitRadius = AU(1.5), Name = "Tellar", Class = "planet", Model = "models/planets/earth.mdl", Diameter = KM(12142)},
	}})

	Star_Trek.World:LoadStarSystem(solLeaf)
	Star_Trek.World:AddMapShip()
end

hook.Add("InitPostEntity", "Star_Trek.World.LoadGalaxy", function() Star_Trek.World:ReLoadGalaxy() end)
hook.Add("PostCleanupMap", "Star_Trek.World.LoadGalaxy", function() Star_Trek.World:ReLoadGalaxy() end)

function flyToVulcan()
	local ship = Star_Trek.World.Entities[1]
	local moon = Star_Trek.World.Entities[10]

	local targetPos = moon:GetStandardOrbit()
	--targetPos = WorldVector(0, 0, 0, LY(100), 0, 0)

	local course = ship:PlotCourse(targetPos)
	print("Nodes: ", #course)

	ship:ExecuteCourse(course, W(0.5), function()
		print("We There!")
	end)
end