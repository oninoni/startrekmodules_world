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
--      World Entities | Client      --
---------------------------------------

-- Load a given entity into the cache.
--
-- @param Number id
-- @param String class
-- @return Boolean success
-- @return String error
function Star_Trek.World:LoadEntity(id, class)
	local successInit, ent = self:InitEntity(id, class)
	if not successInit then
		return false, ent
	end

	local shipId = LocalPlayer():GetNWInt("Star_Trek.World.ShipId", 1)
	local shipEnt = self.Entities[shipId]
	if shipEnt and IsWorldVector(shipEnt.Pos) and isangle(shipEnt.Ang) then
		local pos = WorldToLocalBig(ent.Pos, ent.Ang, shipEnt.Pos, shipEnt.Ang)
		ent.Distance = pos:Length()
	else
		return false, "Invalid Player ShipId"
	end

	self:GenerateRenderEntities()

	return true
end

-- Unloads the given entity from the local cache.
--
-- @param Number id
-- @return Boolean success
-- @return String error
function Star_Trek.World:UnLoadEntity(id)
	local successTerminate, errorTerminate = self:TerminateEntity(id)
	if not successTerminate then
		return false, errorTerminate
	end

	self:GenerateRenderEntities()

	return true
end