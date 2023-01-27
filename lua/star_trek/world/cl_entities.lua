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
function Star_Trek.World:LoadEntity(clientData)
	local id = clientData.Id
	local class = clientData.Class

	local successInit, ent = self:InitEntity(id, class, clientData)
	if not successInit then
		return false, ent
	end

	ent.Distance = math.huge

	self.ShouldGenRender = true

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

	self.ShouldGenRender = true

	return true
end