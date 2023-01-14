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
--      Unit Conversion | Shared     --
---------------------------------------

local FOOT_PER_METER = 3.2808398950131233595800524934383
local UNIT_PER_METER = Star_Trek.World.UnitPerFoot * FOOT_PER_METER

local SKYBOX_SCALE = 1 / Star_Trek.World.Skybox_Scale

function Star_Trek.World:GetModelDiameter(model)
	local ent = ents.Create("prop_physics")
	ent:SetModel(model)
	ent:Spawn()

	local min, max = ent:GetModelBounds()
	SafeRemoveEntity(ent)

	local scale = max - min
	return math.max(
		math.abs(scale.x),
		math.abs(scale.y),
		math.abs(scale.z)
	)
end

-- Return the units representing the meters given.
-- 
-- @param Number m
-- @return Number u
function Star_Trek.World:MeterToUnits(m)
	return m * UNIT_PER_METER
end

-- Return the units representing the meters given.
-- 
-- @param Number u
-- @return Number m
function Star_Trek.World:UnitsToMeter(u)
	return u / UNIT_PER_METER
end

----------------
-- Conversion --
----------------

function Star_Trek.World:AstronomicalUnitToMeter(au)
	return au * self.MetersPerAstrometricalUnit
end
function AUtoM(au) return Star_Trek.World:AstronomicalUnitToMeter(au) end

function Star_Trek.World:MeterToAstronomicalUnit(m)
	return m / self.MetersPerAstrometricalUnit
end
function MtoAU(m) return Star_Trek.World:MeterToAstronomicalUnit(m) end

function Star_Trek.World:LightyearToMeter(ly)
	return ly * self.MetersPerLightyear
end
function LYtoM(ly) return Star_Trek.World:LightyearToMeter(ly) end

function Star_Trek.World:MeterToLightyear(m)
	return m / self.MetersPerLightyear
end
function MtoLY(m) return Star_Trek.World:LightyearToMeter(m) end

----------------
--   Skybox   --
----------------

-- Return the units in the skybox representing the meters given.
-- 
-- @param Number m
-- @return Number sU
function Star_Trek.World:MeterToSkybox(m)
	return self:MeterToUnits(m) / SKYBOX_SCALE
end
function M(m) return Star_Trek.World:MeterToSkybox(m) end

function Star_Trek.World:SkyboxToMeter(skybox)
	return self:UnitsToMeter(skybox * SKYBOX_SCALE)
end
function SBtoM(skybox) return Star_Trek.World:SkyboxToMeter(skybox) end

-- Return the units in the skybox representing the kilometers given.
-- 
-- @param Number m
-- @return Number sU
function Star_Trek.World:KilometerToSkybox(km)
	return self:MeterToSkybox(km * 1000)
end
function KM(km) return Star_Trek.World:KilometerToSkybox(km) end

function Star_Trek.World:SkyboxToKiloMeter(skybox)
	return self:SkyboxToMeter(skybox) / 1000
end
function SBtoKM(skybox) return Star_Trek.World:SkyboxToKiloMeter(skybox) end

-- Return the units in the skybox representing the astronomical units given.
-- 
-- @param Number au
-- @return Number sU
function Star_Trek.World:AstronomicalUnitToSkybox(au)
	return self:MeterToUnits(self:AstronomicalUnitToMeter(au)) / SKYBOX_SCALE
end
function AU(au) return Star_Trek.World:AstronomicalUnitToSkybox(au) end

function Star_Trek.World:SkyboxToAstronomicalUnit(skybox)
	return self:MeterToAstronomicalUnit(self:UnitsToMeter(skybox * SKYBOX_SCALE))
end
function SBtoAU(skybox) return Star_Trek.World:SkyboxToAstronomicalUnit(skybox) end

-- Return the units in the skybox representing the lightyears given.
-- 
-- @param Number au
-- @return Number sU
function Star_Trek.World:LightyearToSkybox(ly)
	return self:MeterToUnits(self:LightyearToMeter(ly)) / SKYBOX_SCALE
end
function LY(ly) return Star_Trek.World:LightyearToSkybox(ly) end

function Star_Trek.World:SkyboxToLightyear(skybox)
	return self:MeterToLightyear(self:UnitsToMeter(skybox * SKYBOX_SCALE))
end
function SBtoLY(skybox) return Star_Trek.World:SkyboxToLightyear(skybox) end

----------------
-- Warp Scale --
----------------

local METER_PER_SECOND_C = 	299792458

-- Get light speed in skybox units per second.
--
-- @param Number c
-- @return Number sU
function Star_Trek.World:GetLightSpeed(c)
	return self:MeterToSkybox(METER_PER_SECOND_C * c)
end
function C(c) return Star_Trek.World:GetLightSpeed(c) end

local A = 0.00264320
local N = 2.87926700
local F1 = 0.06274120
local F2 = 0.32574600

-- Return the multiples of c for a given warp factor.
-- 
-- @param Number warpFactor
-- @return Number c
function Star_Trek.World:WarpToC(warpFactor)
	if warpFactor <= 9 then
		return math.pow(warpFactor, 10 / 3)
	else
		return math.pow(warpFactor,
			10 / 3
			+ A * math.pow(-math.log(10 - warpFactor), N)
			+ F1 * math.pow(warpFactor - 9, 5)
			+ F2 * math.pow(warpFactor - 9, 11)
		)
	end
end

-- Get warp factor in skybox units per second.
--
-- @param Number warpFactor
-- @return Number sU
function Star_Trek.World:Warp(warpFactor)
	local c = self:WarpToC(warpFactor)

	return self:GetLightSpeed(c)
end
function W(warpFactor) return Star_Trek.World:Warp(warpFactor) end