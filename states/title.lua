local lg = love.graphics
local StateStack = require "statestack"
local Game = require "states/game"
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

    lg.print("TITLE (space to start)", GAME_WIDTH/2 - 100, GAME_HEIGHT/2, 0, 2)

    lg.setCanvas({prevCanvas, depth=true})
end

function Title:keypressed(k)
	if k == "space" then
		StateStack.pop()
		StateStack.push(Game:new(7))
	end
end

return Title