-- imports
local Game = require "game"

io.stdout:setvbuf("no")

function love.load()
    love.graphics.setBackgroundColor(0.25,0.5,1)
    love.graphics.setDefaultFilter("nearest")

    local game = Game:new(7)

    function love.mousemoved(x,y, dx,dy)
        game:mousemoved(x,y,dx,dy)
    end

    function love.update(dt)
        game:update(dt)
    end

    function love.keypressed(k)
        if k == "escape" then love.event.push("quit") end
    end

    function love.draw()
        game:draw()
    end
end

function distance(x1,y1,z1, x2,y2,z2)
    return math.sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2)
end
