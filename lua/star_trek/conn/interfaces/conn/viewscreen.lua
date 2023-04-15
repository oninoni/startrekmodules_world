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

	return true, screenWindow
end