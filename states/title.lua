local lg = love.graphics
local StateStack = require "statestack"
local Game = require "states/game"
local Credits = require "states/credits"
local Tutorial = require "states/tutorial"

-- create the Title class
local Title = {}
Title.__index = Title

function Title:new()
	local self = setmetatable({}, Title)

    TitleMusic = love.audio.newSource("music/title theme.mp3", "static")
    TitleMusic:setLooping(true)
    TitleMusic:setVolume(0.05)
    TitleMusic:play()

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
		StateStack.push(Tutorial:new(7))
	end
	if k == "c" then
		StateStack.push(Credits:new())
	end
end

return Title
