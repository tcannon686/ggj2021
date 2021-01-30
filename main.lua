-- imports
g3d = require "g3d"
local Game = require "game"
local Player = require "player"

io.stdout:setvbuf("no")

function love.load()
    love.graphics.setBackgroundColor(0.25,0.5,1)
    love.graphics.setDefaultFilter("nearest")

    local map = g3d.newModel("assets/map.obj", "assets/tileset.png", {-2, 2.5, -3.5}, nil, {-1,-1,1})
    local background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", {0,0,0}, nil, {500,500,500})
    local game = Game:new(7)
    local player = Player:new(0,0,0, map)

    function love.mousemoved(x,y, dx,dy)
        g3d.camera.firstPersonLook(dx,dy)
    end

    function love.update(dt)
        player:update(dt)
    end

    function love.keypressed(k)
        if k == "escape" then love.event.push("quit") end
    end

    function love.draw()
        map:draw()
        background:draw()
    end
end
