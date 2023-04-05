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
--      Default Galaxy | Server      --
---------------------------------------

-- Adding the map ship.
-- An Intrepid class vessel, that is represented by the map.
-- The ship spawns in standard orbit around the given object.
--
-- @param Number parentId
-- @return Boolean success
-- @return String error
function Star_Trek.World:AddMapShip(parentId)
	local parentEnt = self.Entities[parentId]
	if not istable(parentEnt)	then return false, "Parent entity not found" end

	local model = "models/kingpommes/startrek/intrepid/intrepid_sky_1024.mdl"
	local modelSize = Star_Trek.World:GetModelDiameter(model)

	local _, mapShip = Star_Trek.World:LoadEntity(1, "ship", parentEnt:GetStandardOrbit(), Angle(), model, modelSize)
	self.MapShip = mapShip
end

-- Load the default galaxy.
function Star_Trek.World:LoadDefaultGalaxy()
	local solSystem = self:InitializeStarSystem("Sol System", LY(0), LY(0), {
		{Id = 11, OrbitRadius = AU(0), Name = "Sol", Class = "sun", Model = {Model = "models/crazycanadian/star_trek/planets/star.mdl", Skin = 2}, Diameter = KM(1392700), LightColor = Vector(1.3, 1.2, 1)},
		{Id = 2, OrbitRadius = AU(0.39), Name = "Mercury", Class = "planet", Model = "models/crazycanadian/space/sol/mercury.mdl", Diameter = KM(4880)},
		{Id = 3, OrbitRadius = AU(0.72), Name = "Venus", Class = "planet", Model = "models/crazycanadian/space/sol/venus.mdl", Diameter = KM(12104)},
		{Id = 4, OrbitRadius = AU(1), Name = "Earth", Class = "planet", Model = "models/crazycanadian/space/sol/earth.mdl", Diameter = KM(12142)},
		{Id = 5, OrbitRadius = AU(1.52), Name = "Mars", Class = "planet", Model = "models/crazycanadian/space/sol/mars.mdl", Diameter = KM(6780)},
		{Id = 6, OrbitRadius = AU(5.20), Name = "Jupiter", Class = "planet", Model = "models/crazycanadian/space/sol/jupiter.mdl", Diameter = KM(139822)},
		{Id = 7, OrbitRadius = AU(9.58), Name = "Saturn", Class = "planet", Model = "models/crazycanadian/space/sol/saturn.mdl", Diameter = KM(116464), OrbitOffset = Vector(0, 0, KM(10000))},
		{Id = 8, OrbitRadius = AU(19.20), Name = "Uranus", Class = "planet", Model = "models/planets/uranus.mdl", Diameter = KM(50724)},
		{Id = 9, OrbitRadius = AU(30.05), Name = "Neptun", Class = "planet", Model = "models/planets/neptune.mdl", Diameter = KM(29244)},

		-- Earth Orbit
		{Id = 10, ParentId = 4, OrbitRadius = KM(385000), Name = "Luna", Class = "planet", Model = "models/crazycanadian/space/sol/luna.mdl", Diameter = KM(3474.8)},
		{Id = 27, ParentId = 4, OrbitRadius = KM(10000), Name = "Earth Spacedock", Class = "base", Model = "models/crazycanadian/star_trek/stations/spacedock.mdl", Diameter = KM(5), OrbitOffset = Vector(0, 0, KM(3))},

		-- Mars Orbit
		{Id = 12, ParentId = 5, OrbitRadius = KM(9376), Name = "Phobos", Class = "planet", Model = "models/crazycanadian/space/sol/phobos.mdl", Diameter = KM(22.5)},
		{Id = 13, ParentId = 5, OrbitRadius = KM(23463), Name = "Deimos", Class = "planet", Model = "models/crazycanadian/space/sol/deimos.mdl", Diameter = KM(12.6)},

		--Jupiter Orbit
		{Id = 14, ParentId = 6, OrbitRadius = KM(422000), Name = "Io", Class = "planet", Model = "models/crazycanadian/space/sol/io.mdl", Diameter = KM(3643.2)},
		{Id = 15, ParentId = 6, OrbitRadius = KM(671000), Name = "Europa", Class = "planet", Model = "models/crazycanadian/space/sol/europa.mdl", Diameter = KM(3121.6)},
		{Id = 16, ParentId = 6, OrbitRadius = KM(1070000), Name = "Ganymede", Class = "planet", Model = "models/crazycanadian/space/sol/ganymede.mdl", Diameter = KM(5268.2)},
	})

	self:InitializeStarSystem("Vulcan System", LY(-0.6162192048), LY(-12.8379001), {
		{Id = 17, OrbitRadius = AU(0), Name = "40 Eridiani A", Class = "sun", Diameter = KM(1130872.4), LightColor = Vector(1, 1, 1)},
		{Id = 18, OrbitRadius = AU(0.3), Name = "40 Eridiani B", Class = "sun", Diameter = KM(19497.8), LightColor = Vector(1, 1, 1)},
		{Id = 19, OrbitRadius = AU(0.2), Name = "40 Eridiani C", Class = "sun", Diameter = KM(431737), LightColor = Vector(1, 1, 1)},

		{Id = 20, OrbitRadius = AU(0.9), Name = "Vulcan", Class = "planet", Model = "models/planets/mars.mdl", Diameter = KM(12142)},
	})

	self:InitializeStarSystem("Andoria System", LY(6.264895249), LY(-9.756804077), {
		{Id = 21, OrbitRadius = AU(0), Name = "Procyon A", Class = "sun", Diameter = KM(2855035), LightColor = Vector(1, 1, 1)},
		{Id = 22, OrbitRadius = AU(0.3), Name = "Procyon B", Class = "sun", Diameter = KM(16712.4), LightColor = Vector(1, 1, 1)},

		{Id = 23, OrbitRadius = AU(2), Name = "Andor", Class = "planet", Model = "models/planets/earth.mdl", Diameter = KM(12142)},
	})

	self:InitializeStarSystem("Tellar System", LY(-11.86221969), LY(1.386493211), {
		{Id = 24, OrbitRadius = AU(0), Name = "61 Cygni A", Class = "sun", Diameter = KM(926145.5), LightColor = Vector(1, 1, 1)},
		{Id = 25, OrbitRadius = AU(0.2), Name = "61 Cygni B", Class = "sun", Diameter = KM(828656.5), LightColor = Vector(1, 1, 1)},

		{Id = 26, OrbitRadius = AU(1.5), Name = "Tellar", Class = "planet", Model = "models/planets/earth.mdl", Diameter = KM(12142)},
	})

	-- Load the Sol System, where the ship spawns.
	self:LoadStarSystem(solSystem)

	-- Add the map ship.
	-- ID 22 is the Earth Spacedock.
	self:AddMapShip(27)
end