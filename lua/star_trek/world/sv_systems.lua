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

-- Initialize a new star system.
--
-- @param String name
-- @param Number x
-- @param Number y
-- @param Table planets
-- @return Table leaf
function Star_Trek.World:InitializeStarSystem(name, x, y, planets)
	local data = {
		Name = name,
		Entities = planets,
	}

	local leaf = self.QuadTree:CreateLeaf(x, y, data)
	table.insert(self.StarSystems, leaf)

	return leaf
end

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
				print(entData.Name, entData.OrbitRadius)
				entPos = parent:GetOrbitPos(entData.OrbitRadius)
			end
		end

		local success, worldEnt = Star_Trek.World:LoadEntity(entData.Id, entData.Class, entPos, entData.Ang or Angle(), entData.Model, entData.Diameter, entData.Spin, entData.LightColor)
		if not success then
			return false, worldEnt
		end

		local orbitOffset = entData.OrbitOffset
		if isvector(orbitOffset) then
			worldEnt.OrbitOffset = orbitOffset
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
--
-- @param Number x
-- @param Number y
-- @param Number r
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

-- Setup the galaxy.
function Star_Trek.World:ReLoadGalaxy()
	local loadedLeafs = table.Copy(self.LoadedLeafs or {})
	for _, leaf in pairs(loadedLeafs) do
		self:UnloadStarSystem(leaf)
	end
	self.LoadedLeafs = {}

	self.QuadTree = QuadTree(0, 0, LY(self.MaxDistance))
	self.StarSystems = {}

	local override = hook.Run("Star_Trek.World.LoadGalaxy")
	if override then return end

	self:LoadDefaultGalaxy()
end

hook.Add("InitPostEntity", "Star_Trek.World.LoadGalaxy", function() Star_Trek.World:ReLoadGalaxy() end)
hook.Add("PostCleanupMap", "Star_Trek.World.LoadGalaxy", function() Star_Trek.World:ReLoadGalaxy() end)