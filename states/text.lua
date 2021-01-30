local g3d = require "g3d"
local StateStack = require "statestack"

local TextState = {}
TextState.__index = TextState

function TextState:new(text, speakerPosition)
    local self = setmetatable({}, TextState)
    self.timer = 0
    self.text = text
    self.speakerPosition = speakerPosition
    return self
end

function TextState:update(dt)
    self.timer = self.timer + dt
    g3d.camera.target[1] = self.speakerPosition[1]
    g3d.camera.target[2] = self.speakerPosition[2] - 0.05
    g3d.camera.target[3] = self.speakerPosition[3]
    g3d.camera.updateViewMatrix()
end

function TextState:draw()
    love.graphics.print(self.text)

    StateStack.peekNext():draw()
end

return TextState
