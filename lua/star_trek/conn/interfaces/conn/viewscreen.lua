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

function SELF:CreateViewScreenControl(viewScreenPos, viewScreenAng, scale, sideScreensW, sideScreensH)
	local success1, screenWindow = Star_Trek.LCARS:CreateWindow("button_matrix", viewScreenPos, viewScreenAng, scale, sideScreensW, sideScreensH,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Viewscreen", "CAM", WINDOW_BORDER_BOTH)
	if not success1 then
		return false, screenWindow
	end

	local viewScreen = ents.FindByName("viewscreen")[1]
	local mapCameras = {}

	local dynEnts = ents.FindByClass("prop_dynamic")
	for _, ent in pairs(dynEnts) do
		local name = ent:GetName()
		local split = string.Split(name, "_")
		if split[1] == "skybox" then
			mapCameras[tonumber(split[2])] = ent
		end
	end

	for id, ent in pairs(mapCameras) do
		local name = "Holo-Camera " .. id
		if id == 1 then
			name = name .. " (Secondary Deflector)"
		elseif id == 2 then
			name = name .. " (Bridge Aft View)"
		elseif id == 3 then
			name = name .. " (Main Deflector)"
		end

		local row = screenWindow:CreateSecondaryButtonRow(32)
		screenWindow:AddButtonToRow(row, name, nil, nil, nil, false, false, function(ply, buttonData)
			viewScreen:SetExit(ent)
		end)
	end

	return true, screenWindow
end