local lg = love.graphics
local StateStack = require "statestack"
local Game = require "states/game"
-- create the Title class
local Credits = {}
Credits.__index = Credits

function Credits:new()
	local self = setmetatable({}, Credits)

	return self
end

function Credits:update(dt)

end

function Credits:draw()
	local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)

    lg.print("US", GAME_WIDTH/2 - 15, GAME_HEIGHT/2 - 100, 0, 2)
    lg.print("Zach Booth", GAME_WIDTH/2 - 75, GAME_HEIGHT/2 - 50, 0, 2)
    lg.print("Joey Silberman", GAME_WIDTH/2 - 105, GAME_HEIGHT/2, 0, 2)
    lg.print("Nic Tee", GAME_WIDTH/2 - 52, GAME_HEIGHT/2 + 50, 0, 2)
    lg.print("(c to return)", GAME_WIDTH/2 - 97, GAME_HEIGHT/2 + 100, 0, 2)

    lg.setCanvas({prevCanvas, depth=true})
end

function Credits:keypressed(k)
	if k == "c" then
		StateStack.pop()
	end
end

return Credits