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

-- Vector_Max in Skybox is  (2^17) 
-- @ x1024 (2^10) Scale -> Visually at 134217728 (2^27)
Star_Trek.World.Vector_Max = 131071 -- TODO: Recheck

-- Sky Cam is not Readable Clientside, which is absurd...
Star_Trek.World.Skybox_Scale = 1 / 1024

-- Delay inbetween 2 render sorting operations.
Star_Trek.World.SortDelay = 0.5

-- Delay inbetween 2 world think operations.
Star_Trek.World.ThinkDelay = 0.025

-- Ammount of Units per Foot used in the map's skybox and outer hull models.
-- Is equal to 12 on the rp_intreipd map. Might be 16 on other maps.
Star_Trek.World.UnitPerFoot  = 12

-- Scales the distances between planets (Changes Astrometrical Units Calculation)
-- Default / Real Value: 149597870700
local REAL_M_PER_AU = 149597870700
Star_Trek.World.MetersPerAstrometricalUnit = REAL_M_PER_AU

-- Scales the distances between systems (Changes Lightyears Calculation)
-- Default / Real Value: 9460730472580800
local REAL_M_PER_LY = 9460730472580800
Star_Trek.World.MetersPerLightyear = REAL_M_PER_LY / 100

-- Radius of the world in Lightlyears (Max Distance from origin for objects)
-- The Milkyway galaxy has a radius of ~52000 LY
Star_Trek.World.MaxDistance = 75000