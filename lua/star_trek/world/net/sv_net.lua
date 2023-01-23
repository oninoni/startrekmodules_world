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
--       World Network | Server      --
---------------------------------------

util.AddNetworkString("Star_Trek.World.Load")
function Star_Trek.World:GetClientData(ent, update, sync)
	local clientData = {}
	clientData.Id = ent.Id

	if not update then
		clientData.Class = ent.Class
	end

	if not sync then
		ent:GetClientData(clientData, update)
	end

	ent:GetClientDynData(clientData)

	return clientData
end

-- Network a newly loaded world entity to the clients.
function Star_Trek.World:NetworkLoad(ent)
	local clientData = Star_Trek.World:GetClientData(ent)

	net.Start("Star_Trek.World.Load")
		Star_Trek.Util:WriteNetTable(clientData)
	net.Broadcast()

	return true
end

-- Network all loaded world entities to a client.
util.AddNetworkString("Star_Trek.World.LoadMultiple")
function Star_Trek.World:NetworkLoaded(ply)
	local clientDataMultiple = {}
	for id, ent in pairs(self.Entities) do
		local clientData = Star_Trek.World:GetClientData(ent)
		table.insert(clientDataMultiple, clientData)
	end

	net.Start("Star_Trek.World.LoadMultiple")
		Star_Trek.Util:WriteNetTable(clientDataMultiple)
	net.Send(ply)

	return true
end

-- Network the unloading of a world entity to all clients.
util.AddNetworkString("Star_Trek.World.UnLoad")
function Star_Trek.World:NetworkUnLoad(id)
	net.Start("Star_Trek.World.UnLoad")
		net.WriteInt(id, 32)
	net.Broadcast()

	return true
end

-- Update all data of the given entity.
util.AddNetworkString("Star_Trek.World.Update")
function Star_Trek.World:NetworkUpdate(ent)
	local clientData = Star_Trek.World:GetClientData(ent, true)

	net.Start("Star_Trek.World.Update")
		Star_Trek.Util:WriteNetTable(clientData)
	net.Broadcast()

	return true
end

-- Synchronize the dynamic data of all loaded world entities to all players.
util.AddNetworkString("Star_Trek.World.Sync")
function Star_Trek.World:NetworkSync()
	local clientDataMultiple = {}

	for id, ent in pairs(self.Entities) do
		-- Skip non-dynamic entities.
		if not ent.Dynamic then continue end

		local clientData = Star_Trek.World:GetClientData(ent, true, true)
		table.insert(clientDataMultiple, clientData)
	end

	net.Start("Star_Trek.World.Sync")
		Star_Trek.Util:WriteNetTable(clientDataMultiple)
	net.Broadcast()

	return true
end