local lume = require "lume"
local lg = love.graphics

local Textbox = {}
Textbox.__index = Textbox

local q1 = {
	"Who'd you come with?",
	"Who were you here with?",
	"And who might be accompanying you?",
	"Who did you come here with?",
	"When you entered, who did you see?",
	"Was anyone near you when you entered?",
	"Did you come with someone?",
	"Who did you arrive here with?",
}

local q2 = {
	"Who'd you leave with?",
	"Who did you notice when you left?",
	"And who was accompanying you on your way out?",
	"Who did you leave here with?",
	"When you exited, who did you see?",
	"Was anyone near you when you left?",
	"Did you leave with anyone?",
	"Who did you leave here with?",
}

local q3 = {
	"Do you like burgers? Maybe even medium-rare?",
	"What was the color of the last fish you saw?",
	"Have you been watching that new HBO show?",
	"What is your foot size?",
	"Have you ever broken a bone?",
	"What's your weight?",
	"Have you ever killed someone in the past?",
	"What did you study in college?",
	"Do you have a good french recipe? I'm looking for one.",
	"Have you ever won a game of Crowned Ultimate Magician?",
	"Did you know that you can play Vector Prospector on Steam for only $12.99?",
	"So, is it just me or does it kinda smell like laundry?",
	"You also smell that burnt toast?",
	"If you end up not being the killer, wanna grab a drink later? You seem chill.",
	"If you were the killer, who would you kill next?",
}

local choiceText = [[
[1] Graph1 question?
[2] Graph2 question?
]]

local wrapAmount = 64

function Textbox:new(text, personTalkingTo)
    local self = setmetatable({}, Textbox)

    -- preprocess the text to be nicely word wrapped
    self.text = {}
    for i, boxtext in ipairs(text) do
        self.text[i] = lume.wordwrap(boxtext, wrapAmount)
    end

    self.textIndex = 1
    self.textScroll = 0
    self.nextSprite = lg.newImage("assets/textnext.png")

    self.nextSound = love.audio.newSource("sfx/next_text.wav", "static")
    self.nextSound:setVolume(0.1)
    self.doneSound = love.audio.newSource("sfx/done_text.wav", "static")
    self.doneSound:setVolume(0.5)

    self.personTalkingTo = personTalkingTo
    -- store the initial values of the person's transform
    -- so they can be reverted back to later
    self.personTalkingToScale = personTalkingTo.model.scale[2]
    self.personTalkingToTranslation = personTalkingTo.model.translation[2]

    return self
end

function Textbox:update(dt, game)
    local textScrollSpeed = 40
    self.textScroll = self.textScroll + dt*textScrollSpeed

    -- animate the person doing the talking
    if not self:doneScrollingText() then
        local tude = 0.05
        self.personTalkingTo.model.scale[2] = self.personTalkingToScale + math.sin(self.textScroll)*tude
        self.personTalkingTo.model.translation[2] = self.personTalkingToTranslation - math.sin(self.textScroll)*tude/2
    else
        self.personTalkingTo.model.scale[2] = self.personTalkingToScale
        self.personTalkingTo.model.translation[2] = self.personTalkingToTranslation
    end

    if not self.text[self.textIndex] then
        -- get rid of this textbox when it has no more text
        game.textbox = nil
        self:onDestroy()
    end
end

function Textbox:isInChoiceMode()
    return self.text[self.textIndex] and self.text[self.textIndex] == "CHOICE"
end

function Textbox:getCurrentText()
    -- if in choice mode, don't do the typewriter effect
    if self:isInChoiceMode() then
        return choiceText
    end

    return self.text[self.textIndex] and self.text[self.textIndex]:sub(0, math.floor(self.textScroll + 0.5))
end

function Textbox:doneScrollingText()
    -- if in choice mode, don't do the typewriter effect
    if self:isInChoiceMode() then
        return true
    end

    return self.text[self.textIndex] and self:getCurrentText() == self.text[self.textIndex]
end

function Textbox:draw(game)
    -- we have to render gui elements to GuiCanvas for reasons
    local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)

    -- draw the black textbox
    lg.setColor(0,0,0,0.75)
    lg.rectangle("fill", 48,384-16, GAME_WIDTH-48-48, GAME_HEIGHT-384-16)

    -- draw the actual text
    lg.setColor(1,1,1)
    if self.text[self.textIndex] then
        lg.print(self:getCurrentText(), 64, 384, 0, 2)
    end

    -- draw the animated arrow telling you to go on to the next text box
    if self:doneScrollingText() and self.textIndex < #self.text and not self:isInChoiceMode() then
        lg.draw(self.nextSprite, GAME_WIDTH-64-18, GAME_HEIGHT-64 + math.floor(math.sin(self.textScroll/3))*4)
    end

    -- set the canvas back to the previous one
    -- it's probably the 3D canvas, so set depth to true
    lg.setCanvas({prevCanvas, depth=true})
end

function Textbox:onDestroy()
    -- reset the person that is talking back to their pre-animated state
    self.personTalkingTo.model.scale[2] = self.personTalkingToScale
    self.personTalkingTo.model.translation[2] = self.personTalkingToTranslation
    love.audio.stop(self.doneSound)
    love.audio.play(self.doneSound)
end

function Textbox:proceed()
    if not self:doneScrollingText() then return end

    self.textIndex = self.textIndex + 1
    if self.text[self.textIndex] then
        love.audio.stop(self.nextSound)
        love.audio.play(self.nextSound)
    end
    self.textScroll = 0
end

function Textbox:mousepressed(k)
    -- when the player clicks
    -- go on to the next text box
    if k == 1 and self:doneScrollingText() and not self:isInChoiceMode() then
        self:proceed()
    end
end

function Textbox:keypressed(k)
    -- if you press the corresponding key in choice mode
    -- then insert the answer as the next piece of text in the sequence

    if self:isInChoiceMode() then
        if k == "1" then
            table.insert(self.text, self.textIndex+1, lume.wordwrap(self.personTalkingTo:ask("1"), wrapAmount))
            self:proceed()
        end

        if k == "2" then
            table.insert(self.text, self.textIndex+1, lume.wordwrap(self.personTalkingTo:ask("2"), wrapAmount))
            self:proceed()
        end

    end
end

return Textbox
