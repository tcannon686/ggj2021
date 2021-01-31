local g3d = require "g3d"
local Textbox = require "textbox"
local StateStack = require "statestack"
local lume = require "lume"
local Dialogue = require "dialogue"

-- define the person class
local Person = {}
Person.__index = Person

function Person:new(name, known)
    local self = setmetatable({}, Person)

    self.name = name
    self.known = known

    local position = {lume.random(-2,2), 1.6, lume.random(-2,2)}
    local texture = lume.randomchoice({"assets/person1.png", "assets/person2.png"})
    self.model = g3d.newModel("assets/vertical_plane.obj", texture, position, {0,0,0}, {0.4,0.4,0.4})
    
    local dialogue = Dialogue:new(name)
    self.text = dialogue.text

    self.speaking = false
    self.inSpeakingRange = false

    return self
end

function Person:ask(what)
    return self.known[what]
end

function Person:onAccused(props)
    print(self.name .. ": I can't believe you would accuse me! >:(")
end

function Person:update(dt, game)
    local playerpos = game.player.position
    local playerDistance = self.model:getDistanceFrom(playerpos[1], playerpos[2], playerpos[3])

    if playerDistance < 0.75 and not game.textbox then
        -- player has now initiated a conversation with this person
        self.inSpeakingRange = true
        if self.speaking and not game.textbox then
            game.textbox = Textbox:new(self.text, self)
        end
    else
        self.inSpeakingRange = false
        self.speaking = false
    end

    self.model:setRotation(self.model.rotation[1], math.atan2(self.model.translation[3] - playerpos[3], self.model.translation[1] - playerpos[1])*-1, self.model.rotation[3])
end

function Person:draw(game)
    self.model:draw()
end

function Person:mousepressed(k)
    if self.inSpeakingRange and k == 1 then
        self.speaking = true
    end
end

return Person
