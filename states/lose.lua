local Lose = {}
Lose.__index = Lose

local lg = love.graphics

function Lose:new()
    local self = setmetatable({}, Lose)
    return self
end

function Lose:draw()
    local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)

    lg.setColor(1,1,1)
    lg.push()
    lg.scale(2,2,2)
    lg.print("You lose!", 400,250)
    lg.pop()

    lg.setCanvas({prevCanvas, depth=true})
end

return Lose
