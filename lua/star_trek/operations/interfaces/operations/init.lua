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
--    LCARS OPS Interface | Server   --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

SELF.BaseInterface = "bridge_targeting_base"

-- Opening general purpose menus.
function SELF:Open(ent)
	local success, windows, offsetPos, offsetAngle = SELF.Base.Open(self, ent, false)

	local scannerSelectionWindowPos = Vector(0, -1.5, 3.3)
	local scannerSelectionWindowAng = Angle(0, 0, 11)

	local success2, scannerWindow = Star_Trek.LCARS:CreateWindow("button_matrix", scannerSelectionWindowPos, scannerSelectionWindowAng, nil, 388, 320,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Scanner Control", "SCANNER", not self.Flipped)
	if not success2 then
		return false, scannerWindow
	end
	table.insert(windows, scannerWindow)

	local commsSelectionWindowPos = Vector(25.9, -1, 3.5)
	local commsSelectionWindowAng = Angle(0, 0, 11)

	local success3, commsWindow = Star_Trek.LCARS:CreateWindow("button_matrix", commsSelectionWindowPos, commsSelectionWindowAng, nil, 368, 350,
	function(windowData, interfaceData, ply, categoryId, buttonId)
		-- No Additional Interactivity here.
	end, "Communications", "COMMS", self.Flipped)
	if not success3 then
		return false, commsWindow
	end
	table.insert(windows, commsWindow)

	return success, windows, offsetPos, offsetAngle
end