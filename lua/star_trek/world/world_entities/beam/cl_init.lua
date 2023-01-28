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
--            World Entity           --
--           Beam | Client           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

local SKY_CAM_SCALE = Star_Trek.World.Skybox_Scale or (1 / 1024)
local NEARBY_MAX = 12

function SELF:Update()
	self.WidthNearby = self.Width / SKY_CAM_SCALE
end

function SELF:RenderThink(shipPos, shipAng)
	local pos, ang = WorldToLocalBig(self.Pos, self.Ang, shipPos, shipAng)
	local distance = pos:Length()
	self.Distance = distance

	local norm = ang:Forward()

	local diameter = self.Diameter
	local endPos = pos + norm * diameter

	local originInside = distance < NEARBY_MAX
	local targetInside = endPos:Length() < NEARBY_MAX

	-- Both are inside the nearby Radius.
	if originInside and targetInside then
		self.RenderSkybox = false
		self.RenderNearby = true

		self.NearbyStartPos = pos / SKY_CAM_SCALE
		self.NearbyEndPos = endPos / SKY_CAM_SCALE

		return
	end

	-- Both are outside the nearby Radius.
	if not originInside and not targetInside then
		self.RenderSkybox = true
		self.RenderNearby = false

		-- TODO: Check Intersection when beam goes through nearby area.

		self.SkyStartPos = pos
		self.SkyEndPos = endPos

		return
	end

	self.RenderSkybox = true
	self.RenderNearby = true

	local edgePos, remainingDistance = intersect_origin_sphere(endPos, -norm, NEARBY_MAX)
	if edgePos then
		self.SkyStartPos = edgePos
		self.SkyEndPos = endPos

		local lengthNearby = diameter - remainingDistance
		local lengthSky = diameter - lengthNearby


		self.RepSky = lengthSky / self.Tiling
		self.RepNearby = lengthNearby / self.Tiling

		self.NearbyStartPos = pos / SKY_CAM_SCALE
		self.NearbyEndPos = edgePos / SKY_CAM_SCALE

		return
	end

	-- Should never happen!
	self.RenderSkybox = false
	self.RenderNearby = false
end

function SELF:DrawBeam(startPos, endPos, width, textureOffset, repetitions, n)
	render.DrawBeam(startPos, endPos, width, textureOffset, repetitions, self.Color)
end

function SELF:DrawSkybox()
	if not self.RenderSkybox then return end

	local offset = (CurTime() * self.Stream) % 1

	render.SetMaterial(Material(self.Material))
	render.DrawBeam(self.SkyStartPos, self.SkyEndPos, self.Width, self.RepNearby + offset, self.RepSky + offset, self.Color)
end

function SELF:DrawNearby()
	if not self.RenderNearby then return end

	local offset = (CurTime() * self.Stream) % 1

	render.SetMaterial(Material(self.Material))
	render.DrawBeam(self.NearbyStartPos, self.NearbyEndPos, self.WidthNearby, offset, self.RepNearby + offset, self.Color)
end