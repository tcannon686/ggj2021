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

    lg.print([[
Dear Mr. Detective,

Colonel Moneybags has been murdered!


Use left click to talk to people
Use right click to accuse them of murder!

Ask people questions to find out whose stories do not line up.
The person who lies the most is the murderer!

You only get three chances to accuse the right person.
Use your clues wisely!


Press [space] to start!
]], 32,32, 0, 2)

    lg.setCanvas({prevCanvas, depth=true})
end

function Title:keypressed(k)
	if k == "space" then
		StateStack.jump(Game:new(7))
        TitleMusic:stop()
	end
end

return Title
