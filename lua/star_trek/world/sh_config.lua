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
--          Config | Shared          --
---------------------------------------

-- Default Intrepid: 131071 (2^17 - 1)
-- @ x1024 (2^10) Scale -> Visually at 134217728 (2^27)
Star_Trek.World.Vector_Max = 131071 -- TODO: Recheck

-- Distance in the skybox in which objects are rendered in real space not in the skybox.
-- Default Intrepid: 16
Star_Trek.World.NearbyRenderMax = 16

-- Sky Cam is not Readable Clientside, which is absurd...
-- Default Intrepid: 1 / 1024
Star_Trek.World.Skybox_Scale = 1 / 1024

-- Delay inbetween 2 render sorting operations.
-- Default: 0.5
Star_Trek.World.SortDelay = 0.5

-- Delay inbetween 2 world think operations.
-- Default: 0.025
Star_Trek.World.ThinkDelay = 0.025

-- Ammount of Units per Foot used in the map's skybox and outer hull models.
-- Default Intrepid: 12 (Might be 16 on other maps.)
Star_Trek.World.UnitPerFoot = 12

-- Multiplier of an objects diameter to get to the standard orbit.
-- Default: 2
Star_Trek.World.StandardOrbitMultiplier = 2

-- Multiplier of an objects diameter to get to the minimum Orbit.
-- Default: 1.2
Star_Trek.World.MinimumOrbitMultiplier = 1.2

-- Scales the distances between planets (Changes Astrometrical Units Calculation)
local REAL_M_PER_AU = 149597870700
Star_Trek.World.MetersPerAstrometricalUnit = REAL_M_PER_AU

-- Scales the distances between systems (Changes Lightyears Calculation)
local REAL_M_PER_LY = 9460730472580800
Star_Trek.World.MetersPerLightyear = REAL_M_PER_LY / 100

-- Radius of the world in Lightyears (Max Distance from origin for objects)
-- The Milkyway galaxy has a radius of ~52000 LY
-- Default: 75000
Star_Trek.World.MaxDistance = 75000

-- Ambient Light brightness in the absense of stars of silimar sources.
-- Default: 0.0005
Star_Trek.World.AmbientLight = 0.0005