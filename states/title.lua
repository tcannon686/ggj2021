local lg = love.graphics
local StateStack = require "statestack"
local Game = require "states/game"
local Credits = require "states/credits"
-- create the Title class
local Title = {}
Title.__index = Title

local music
function Title:new()
	local self = setmetatable({}, Title)

    music = love.audio.newSource("music/title theme.mp3", "static")
    music:setLooping(true)
    music:setVolume(0.05)
    music:play()

	return self
end

function Title:update(dt)

end

function Title:draw()
	local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)

    lg.print("CLUELESS", GAME_WIDTH/2 - 60, GAME_HEIGHT/2 - 50, 0, 2)
    lg.print("(space to start)", GAME_WIDTH/2 - 120, GAME_HEIGHT/2, 0, 2)
    lg.print("(c for credits)", GAME_WIDTH/2 - 112, GAME_HEIGHT/2 + 50, 0, 2)

    lg.setCanvas({prevCanvas, depth=true})
end

function Title:keypressed(k)
	if k == "space" then
		StateStack.pop()
		StateStack.push(Game:new(7))
        music:stop()
	end
	if k == "c" then
		StateStack.push(Credits:new())
	end
end

return Title
