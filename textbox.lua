local Textbox = {}
Textbox.__index = Textbox

local lg = love.graphics

function Textbox:new(text, personTalkingTo)
    local self = setmetatable({}, Textbox)
    self.text = text
    self.textIndex = 1
    self.textScroll = 0
    self.nextSprite = lg.newImage("assets/textnext.png")

    self.personTalkingTo = personTalkingTo
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

function Textbox:getCurrentText()
    return self.text[self.textIndex] and self.text[self.textIndex]:sub(0, math.floor(self.textScroll + 0.5))
end

function Textbox:doneScrollingText()
    return self.text[self.textIndex] and self:getCurrentText() == self.text[self.textIndex]
end

function Textbox:draw(game)
    local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)
    lg.clear(0,0,0,0)

    -- draw the black textbox
    lg.setColor(0,0,0,0.75)
    lg.rectangle("fill", 48,384-16, GAME_WIDTH-48-48, GAME_HEIGHT-384-16)

    -- draw the actual text
    lg.setColor(1,1,1)
    if self.text[self.textIndex] then
        lg.print(self:getCurrentText(), 64, 384, 0, 2)
    end

    -- draw the animated arrow telling you to go on to the next text box
    if self:doneScrollingText() and self.textIndex < #self.text then
        lg.draw(self.nextSprite, GAME_WIDTH-64-18, GAME_HEIGHT-64 + math.floor(math.sin(self.textScroll/3))*4)
    end

    lg.setCanvas({prevCanvas, depth=true})
end

function Textbox:onDestroy()
    -- reset the person that is talking back to their pre-animated state
    self.personTalkingTo.model.scale[2] = self.personTalkingToScale
    self.personTalkingTo.model.translation[2] = self.personTalkingToTranslation
end

function Textbox:mousepressed(k)
    -- when the player clicks
    -- go on to the next text box
    if k == 1 and self:doneScrollingText() then
        self.textIndex = self.textIndex + 1
        self.textScroll = 0
    end
end

return Textbox
