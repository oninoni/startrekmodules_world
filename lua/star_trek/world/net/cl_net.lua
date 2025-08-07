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
--       World Network | Client      --
---------------------------------------

net.Receive("Star_Trek.World.Load", function()
	local clientData = Star_Trek.Util:ReadNetTable()

	local success, error = Star_Trek.World:LoadEntity(clientData)
	if not success then
		print(error)
	end
end)

net.Receive("Star_Trek.World.LoadMultiple", function()
	local clientDataMultiple = Star_Trek.Util:ReadNetTable()

	for _, clientData in pairs(clientDataMultiple) do
		local success, error = Star_Trek.World:LoadEntity(clientData)
		if not success then
			print(error)
		end
	end
end)

net.Receive("Star_Trek.World.UnLoad", function()
	local id = net.ReadInt(32)

	Star_Trek.World:UnLoadEntity(id)
end)

net.Receive("Star_Trek.World.Update", function()
	local clientData = Star_Trek.Util:ReadNetTable()
	local id = clientData.Id
	if not isnumber(id) then
		return
	end

	local ent = Star_Trek.World.Entities[id]
	if not istable(ent) then
		return
	end

	ent:SetData(clientData)
	ent:SetDynData(clientData)

	ent:Update()
end)

net.Receive("Star_Trek.World.Sync", function()
	local clientDataMultiple = Star_Trek.Util:ReadNetTable()
	for _, clientData in pairs(clientDataMultiple) do
		local id = clientData.Id
		if not isnumber(id) then
			continue
		end

		local ent = Star_Trek.World.Entities[id]
		if not istable(ent) then
			continue
		end

		ent:SetDynData(clientData)
	end
end)