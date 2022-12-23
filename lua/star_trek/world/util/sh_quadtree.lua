---------------------------------------
---------------------------------------
--          EGM:RP - Modules         --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
--   This software is only allowed   --
--  to be used with permission from  --
--       Jan 'Oninoni' Ziegler       --
--                                   --
--          Copyright ©2021          --
--       Jan 'Oninoni' Ziegler       --
---------------------------------------
---------------------------------------

---------------------------------------
--         Shared | Quadtree         --
---------------------------------------

local NODE_CAPACITY = 4
local NODE_MAX_DEPTH = 25

local quadTreeMeta = {}
quadTreeMeta.IsQuadTree = true

-- Helper function, to determine if a table is a quad tree.
function IsQuadTree(a)
	return istable(a) and a.IsQuadTree or false
end

-- Create a QuadTree and return it.
--
-- @return QuadTree quadTree
local metaTable = {__index = quadTreeMeta}
function QuadTree(x, y, r, d)
	local quadTree = {
		X = x,
		Y = y,
		R = r,
		D = d or NODE_MAX_DEPTH,

		-- if you wanna be space efficient, keep them as nil as long as possible :D
		-- gn8~
		Leafs = {},
		Nodes = {}
	}

	setmetatable(quadTree, metaTable)

	return quadTree
end

-- Checks, if the given point is in the bounding box.
--
-- @param Number x
-- @param Number y
-- @return Boolean containsPoint
function quadTreeMeta:ContainsPoint(x, y)
	return  x >= self.X - self.R
		and x <  self.X + self.R
		and y >= self.Y - self.R
		and y <  self.Y + self.R
end

-- Checks, if the given bounds are in intersecting bounding box.
--
-- @param Number x
-- @param Number y
-- @param Number r
-- @return Boolean intersect
function quadTreeMeta:Intersect(x, y, r)
	return  x + r >= self.X - self.R
		and x - r <  self.X + self.R
		and y + r >= self.Y - self.R
		and y - r <  self.Y + self.R
end

-- Subdivides the node into 4 equal quadrants.
-- This also shifts existing data into the new quadrants.
local xOffset = {-1, 1, -1, 1}
local yOffset = {-1, -1, 1, 1}
function quadTreeMeta:Subdivide()
	local r = self.R * 0.5
	local d = self.D - 1
	if d <= 0 then
		ErrorNoHaltWithStack("Maximum Quadtree Depth reached!")

		return false
	end

	for i = 1, 4 do
		local x = self.X + xOffset[i] * r
		local y = self.Y + yOffset[i] * r

		local node = QuadTree(x, y, r, d)
		self.Nodes[i] = node

		-- TODO: This could technically loose entries, but it shouldnt?
		for _, leaf in pairs(self.Leafs) do
			node:Insert(leaf)
		end
	end

	self.Leafs = {}
	return true
end

-- Insert an leaf into the quadtree.
--
-- @param Table leaf
-- @return Boolean success
function quadTreeMeta:Insert(leaf)
	local x = leaf.X
	local y = leaf.Y

	if not self:ContainsPoint(x, y) then
		return false
	end

	if #self.Nodes == 0 then
		if #self.Leafs < NODE_CAPACITY then
			table.insert(self.Leafs, leaf)

			return true
		end

		if not self:Subdivide() then
			return false
		end
	end

	for i = 1, 4 do
		if self.Nodes[i]:Insert(leaf) then return true end
	end

	return false
end

-- Create a leaf from the given position and data.
function quadTreeMeta:CreateLeaf(x, y, data)
	local leaf = {
		X = x,
		Y = y,

		Data = data,
	}

	if self:Insert(leaf) then return leaf end

	return false
end

-- Queries all objects in a given bounds.
--
-- @param Number x
-- @param Number y
-- @param Number r
-- @return Table leafsInRange
function quadTreeMeta:QueryBounds(x, y, r)
	local leafsInRange = {}
	if self:Intersect(x, y, r) then
		for _, leaf in ipairs(self.Leafs) do
			if  leaf.X >= x - r
			and leaf.X <  x + r
			and leaf.Y >= y - r
			and leaf.Y <  y + r then
				table.insert(leafsInRange, leaf)
			end
		end

		if #self.Nodes == 4 then
			for i = 1, 4 do
				table.Add(leafsInRange, self.Nodes[i]:QueryBounds(x, y, r))
			end
		end
	end

	return leafsInRange
end

-- Remove a given leave from the tree.
--
-- @param Table leaf
-- @return Boolean success
function quadTreeMeta:Remove(x, y, data)
	if not self:ContainsPoint(x, y) then
		return false
	end

	for i, leaf in ipairs(self.Leafs) do
		if leaf.Data == data then
			table.remove(self.Leafs, i)

			return true
		end
	end

	if #self.Nodes == 4 then
		for i = 1, 4 do
			if self.Nodes[i]:Remove(x, y, data) then return true end
		end
	end

	return false
end