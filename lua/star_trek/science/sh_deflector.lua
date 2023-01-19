Deflector = {}
Deflector.__index = Deflector


-- Creates a new Deflector (System) object to be used anywhere. This can be used on any ship, not just the Serenity main ship. 
-- Parameters for the Deflector System are taken in via a table
-- Parameters include:
-- Dishes (Table): Table of the dishes 
-- CurrParticle (Table): object for the current particle
-- ParticleName (String): Name of the current selected particle (String) **ParticleName and CurrParticle will one day point to the same variable** 
-- ActiveDish (Table): Table (From the dishes table) of the current selected dish
-- FiringType (String): The current selected firing type (beam, pulse, or field)

-- For an example of the Dishes table, look in the interface init file

function Deflector:new(tbl)

    local o = {
        Dishes = tbl.Dishes or {},
        CurrParticle = tbl.CurrParticle or {},
        ParticleName = tbl.ParticleName or {},
        ActiveDish = tbl.ActiveDish or {},
        FiringType = tbl.FiringType or nil,
        InterfaceEnt = tbl.InterfaceEnt or nil,
        TimerName = tbl.TimerName or nil,
        Strength = nil,
        Time = nil,
        TimeModifier = nil
    }
    setmetatable(o, Deflector)

    return o

end

function Deflector:Fire()

    local color = self.CurrParticle.Color
    local particle = self.CurrParticle
    local activeDish = self.ActiveDish

    net.Start("Star_Trek.Deflector.Fire")
        net.WriteColor(color)
        net.WriteTable(particle)
        net.WriteTable(activeDish)
    net.Broadcast()

    if IsValid(self.InterfaceEnt) then
        self.LoopId = self.InterfaceEnt:StartLoopingSound("star_trek.world.deflector_loop")
    end

    if timer.Exists(sef.TimerName) then
        --If you fire a new particle while a pulse is already being fired
        timer.Stop(self.TimerName)
    end

    if self.FiringType == "Pulse" then
        timer.Create(self.TimerName, self.Time * self.TimeModifier, 1, function()
            self:Cease()
        end)
    end
end


function Deflector:Cease()
    net.Start("Star_Trek.Deflector.Cease")
    net.Broadcast()
    self.CurrParticle = nil
    self.ParticleName = nil
    self.FiringType = nil
    self.ActiveDish = nil

    if IsValid(self.InterfaceEnt) then
         self.InterfaceEnt:StopLoopingSound(self.LoopId)
    end

    if timer.Exists(self.TimerName) then
        timer.Stop(self.TimerName)
    end

end

function Deflector:SetDish(dishName)
    self.ActiveDish = self.Dishes[dishName]
end

if SERVER then
    util.AddNetworkString("Star_Trek.Deflector.Fire")
    util.AddNetworkString("Star_Trek.Deflector.Cease")

end

if CLIENT then

    local active = false

    local particle --To be used in the future when Particles actually have a use
    local dish
    local startPos
    local endPos
    local width
    local additionalStart
    local additionalEnd
    local additionalWidth
    net.Receive("Star_Trek.Deflector.Fire", function()
        color = net.ReadColor()
        particle = net.ReadTable()
        dish = net.ReadTable()
        active = true
        startPos = dish.startPos
        endPos = dish.endPos
        width = dish.width
        additionalStart = dish.additionalStart
        additionalEnd = dish.additionalEnd
        additionalWidth = dish.additionalWidth
        color = particle.Color
    end)


    net.Receive("Star_Trek.Deflector.Cease", function()
        active = false
    end)

    hook.Add("PreDrawTranslucentRenderables", "TestBeam", function()
        if active then
            render.SetMaterial(Material("sprites/tp_beam001"))
            render.DrawBeam(startPos, endPos, width, 1, 1, color)
            if additionalStart ~= nil and additionalEnd ~= nil then -- This is only used for drawing the realspace beam of the secondary deflector.
                render.DrawBeam(additionalStart, additionalEnd, additionalWidth, 1, 1, color)
            end
        end
    end)
end


-- Create a timer for pulses.
-- The time is based off of the strength of the beam, but the more strength the shorter the time