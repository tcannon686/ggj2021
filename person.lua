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

    local maleSound1 = love.audio.newSource("sfx/male1.mp3", "static")
    local maleSound2 = love.audio.newSource("sfx/male2.mp3", "static")
    local maleSound3 = love.audio.newSource("sfx/male3.mp3", "static")
    local femaleSound1 = love.audio.newSource("sfx/female1.mp3", "static")
    local femaleSound2 = love.audio.newSource("sfx/female2.mp3", "static")

    
    local position = {lume.random(-2,2), 1.6, lume.random(-2,2)}
    local texture, pitch
    if name == "Crimson Reddington" then
        texture = "assets/Crimson.png"
        self.soundList = {maleSound1, maleSound2, maleSound3}
        self.pitch = 1 
    elseif name == "Aqua Bloomberg" then
        texture = "assets/Aqua.png"
        self.soundList = {femaleSound1, femaleSound2}
        self.pitch = 1.2
    elseif name == "Lief Greenhand" then
        texture = "assets/Lief.png"
        self.soundList = {femaleSound1, femaleSound2}
        self.pitch = 1 
    elseif name == "Dick Goldmember" then
        texture = "assets/Dick.png"
        self.soundList = {maleSound1, maleSound2, maleSound3}
        self.pitch = 1.1 
    elseif name == "Bob Gray" then
        texture = "assets/Bob.png"
        self.soundList = {maleSound1, maleSound2, maleSound3}
        self.pitch = 0.8 
    elseif name == "Violet Purpov" then
        texture = "assets/Violet.png"
        self.soundList = {femaleSound1, femaleSound2}
        self.pitch = 1.1 
    elseif name == "Wilson White" then
        texture = "assets/Wilson.png"
        self.soundList = {maleSound1, maleSound2, maleSound3}
        self.pitch = 0.6 
    else
        textrue = "assets/enemy.png"
    end
    self.model = g3d.newModel("assets/vertical_plane.obj", texture, position, {0,0,0}, {0.4,0.4,0.4})

    -- 2nd argument is a boolean for debugging mode, just makes it quicker.
    self.dialogue = Dialogue:new(name, true)
    -- self.text = dialogue.text

    self.speaking = false
    self.inSpeakingRange = false
    self.beenSpokenTo = false

    return self
end

function Person:ask(what)
    if what == "1" then
        local str = "I was with "
        for _,i in pairs(self.known.graph1) do
            str = str .. i .. ","
        end
        self.beenSpokenTo = true
        return str
    elseif what == "2" then
        local str = "I saw "
        for _,i in pairs(self.known.graph2) do
            str = str .. i .. ","
        end
        self.beenSpokenTo = true
        return str
    end
    -- return self.known[what]
    return nil
end

function Person:update(dt, game)
    local playerpos = game.player.position
    local playerDistance = self.model:getDistanceFrom(playerpos[1], playerpos[2], playerpos[3])

    if playerDistance < 0.75 and not game.textbox then
        -- player has now initiated a conversation with this person
        self.inSpeakingRange = true
        if self.speaking and not game.textbox then
            ----------hmm sound-------------------
            local sound = self.soundList[math.random(#self.soundList)]
            sound:setVolume(0.5)
            sound:setPitch(self.pitch)
            sound:play()
            --------------------------------------

            if self.accused then
                if self.name == game.murderer then
                    game.textbox = Textbox:new(self.dialogue.caughtText, self)
                else
                    game.textbox = Textbox:new(self.dialogue.accusedText, self)
                end
            elseif not self.beenSpokenTo then
                game.textbox = Textbox:new(self.dialogue.text, self)
            else
                game.textbox = Textbox:new(self.dialogue.spokenToText, self)
            end
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
    elseif self.inSpeakingRange and k == 2 then
        self.speaking = true
        self.accused = true
    end
end

return Person
