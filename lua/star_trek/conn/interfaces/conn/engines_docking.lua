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
--    Copyright © 2022 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--      CONN Interface | Server      --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

function SELF:SelectEngineModeDocking()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	return -- TODO
end

function SELF:SetEngineTargetDocking()
	local engineControlWindow = self.EngineControlWindow
	if not istable(engineControlWindow) then return end

	return -- TODO
end