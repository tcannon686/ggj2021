-- imports
local Person = require "person"
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

-- Creates an array from the range i to j (inclusive)
local function range(n)
    local ret = {}
    for i=1, n do ret[i] = i end
    return ret
end

-- create the Game class
local Game = {}
Game.__index = Game

function Game:new(personCount)
    local self = setmetatable({}, Game)

    -- Create permutations of each field.
    local weaponsDeck = lume.shuffle(range(personCount))
    local peopleDeck = lume.shuffle(range(personCount))
    local locationsDeck = lume.shuffle(range(personCount))

    self.people = {}

    -- Create the people.
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
