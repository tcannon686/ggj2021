-- imports
local g3d = require "g3d"
local Person = require "person"
local Player = require "player"
local lume = require "lume"

--[[
Creates the game state.

Fields:
 - people          A list of people created using makePerson.
 - accuse (props)  Accuse a person of the murder. Returns true if the
                   accusation is true, false otherwise. props should be a table
                   including the person, the weapon, and the location.
 - ask (props)     Ask a person a question. Props should contain two fields:
                   person, and what. Returns two values. The first value is the
                   person's response or nil if they won't answer the question,
                   the second is their dialogue.
]]

local wordRepresentations = {
    locations = {
        "patio",
        "pool",
        "kitchen",
        "backyard",
        "garage",
        "theater",
        "living_room"
    },

    weapons = {
        "knife",
        "candlestick",
        "trophy",
        "rope",
        "pistol",
        "soap",
        "poison"
    },

    people = {
        "red",
        "blue",
        "green",
        "yellow",
        "blue",
        "purple",
        "white"
    }
}

-- create the Game class
local Game = {}
Game.__index = Game

function Game:new(personCount)
    local self = setmetatable({}, Game)

    local function range(n)
        local ret = {}
        for i=1, n do ret[i] = i end
        return ret
    end

    -- create permutations of each field
    local weaponsDeck = lume.shuffle(range(personCount))
    local peopleDeck = lume.shuffle(range(personCount))
    local locationsDeck = lume.shuffle(range(personCount))

    self.map = g3d.newModel("assets/map.obj", "assets/tileset.png", {-2, 2.5, -3.5}, nil, {-1,-1,1})
    self.background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", {0,0,0}, nil, {500,500,500})
    self.player = Player:new(0,0,0, self.map)

    self.people = {}

    -- create all the people
    for i=1, personCount do
        local known = {
            weapon = wordRepresentations.weapons[weaponsDeck[i]],
            person = wordRepresentations.people[peopleDeck[i]],
            location = wordRepresentations.locations[locationsDeck[i]],
        }

        if i == personCount then
            self.truth = known
        else
            -- a person's index in self.people is their name
            local name = wordRepresentations.people[i]
            self.people[name] = Person:new(name, known)
        end
    end

    return self
end

function Game:update(dt)
    self.player:update(dt)

    for _, person in pairs(self.people) do
        person:update(dt, self)
    end
end

function Game:mousemoved(x,y, dx,dy)
    g3d.camera.firstPersonLook(dx,dy)
end

function Game:draw()
    --self.player:draw()
    self.background:draw()
    self.map:draw()

    for _, person in pairs(self.people) do
        person:draw(self)
    end
end

function Game:accuse(person, weapon, place)
    if self.truth.person == person and self.truth.location == location and self.truth.weapon == weapon then
        print(person .. ": Argh! You got me!")
        return true
    end

    self.people[person]:onAccused()

    return false
end

function Game:ask(person, what)
    return self.people[person]:ask(what)
end

return Game
