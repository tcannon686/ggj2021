local Textbox = {}
Textbox.__index = Textbox

function Textbox:new(text)
    local self = setmetatable({}, Textbox)
    self.text = text
    return self
end

function Textbox:update(dt, game)
end

function Textbox:draw(game)
    local prevCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(GuiCanvas)
    love.graphics.clear(0,0,0,0)
    love.graphics.print("hello there")
    love.graphics.setCanvas({prevCanvas, depth=true})
end

return Textbox
