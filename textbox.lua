local Textbox = {}
Textbox.__index = Textbox

function Textbox:new(text)
    local self = setmetatable({}, Textbox)
    self.text = text
    self.textIndex = 1
    return self
end

function Textbox:update(dt, game)
end

function Textbox:draw(game)
    local prevCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(GuiCanvas)
    love.graphics.clear(0,0,0,0)

    if self.text[self.textIndex] then
    	love.graphics.print(self.text[self.textIndex], GAME_WIDTH/16, GAME_HEIGHT*2/3, 0, 2)
	else
		game.textbox = nil
	end

    love.graphics.setCanvas({prevCanvas, depth=true})
end

function Textbox:mousepressed(k)
	if k == 1 then
		print("FUCK")
		self.textIndex = self.textIndex + 1
	end
end

return Textbox
