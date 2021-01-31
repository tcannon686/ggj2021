local lg = love.graphics
local StateStack = require "statestack"

-- create the Title class
local Title = {}
Title.__index = Title

function Title:new()
	local self = setmetatable({}, Title)

	return self
end

function Title:update(dt)

end

function Title:draw()
	local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)
    lg.setCanvas({prevCanvas, depth=true})
end

return Title