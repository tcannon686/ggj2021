local StateStack = require "statestack"
local lg = love.graphics
local lume = require "lume"

local CutToBlack = {}
CutToBlack.__index = CutToBlack

function CutToBlack:new(text, callback)
    local self = setmetatable({}, CutToBlack)
    self.timer = 0.01
    self.done = false
    self.callback = callback
    self.doneCallback = false
    self.text = text
    return self
end

function CutToBlack:update(dt)
    self.timer = self.timer + dt

    if self.done then
        print("self done")
        StateStack.pop()
    end
end

function CutToBlack:draw()
    local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)

    local alpha = math.min(self.timer, 1)
    alpha = math.min(alpha, 3.5-self.timer)

    if alpha <= 0 then
        self.done = true
    end

    if not self.doneCallback and alpha >= 1 then
        self.doneCallback = true
        if self.callback then
            self.callback()
        end
        StateStack.peekNext():update(0.001)
    end

    lg.setColor(0,0,0, alpha)
    lg.rectangle("fill", 0,0, GAME_WIDTH, GAME_HEIGHT)

    lg.setColor(1,1,1, alpha^3)
    lg.print(self.text, -1*MainFont:getWidth(self.text) + GAME_WIDTH/2, GAME_HEIGHT/2 - 8, 0, 2)

    lg.setCanvas({prevCanvas, depth=true})

    lg.setColor(1,1,1)
    StateStack.peekNext():draw()
end

return CutToBlack
