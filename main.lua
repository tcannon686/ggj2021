-- imports
local StateStack = require "statestack"
local Game = require "states/game"

-- so that stdout happens during runtime on windows git bash
io.stdout:setvbuf("no")

GAME_WIDTH = 1024
GAME_HEIGHT = 576

function love.load()
    love.graphics.setDefaultFilter("nearest")

    -- global, so it can be accessed easily by textbox.lua
    GuiCanvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)

    local screen = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)

    -- push a game with 7 people onto the StateStack
    StateStack.push(Game:new(7))

    -- define all the love callback functions in love.load
    -- so that they can reference the local variables in love.load
    function love.mousemoved(...)
        local state = StateStack:peek()
        if state and state.mousemoved then
            state:mousemoved(...)
        end
    end

    function love.update(...)
        local state = StateStack:peek()
        if state and state.update then
            state:update(...)
        end
    end

    function love.draw(...)
        love.graphics.setCanvas({screen, depth=true})
        love.graphics.clear(0,0,0,0)

        local state = StateStack:peek()
        if state and state.draw then
            state:draw(...)
        end


        love.graphics.setCanvas()
        local letterBox = math.min(love.graphics.getWidth()/screen:getWidth(), love.graphics.getHeight()/screen:getHeight())
        love.graphics.draw(screen, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, letterBox, letterBox*-1, GAME_WIDTH/2, GAME_HEIGHT/2)
        love.graphics.draw(GuiCanvas, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, letterBox, letterBox*1, GAME_WIDTH/2, GAME_HEIGHT/2)
    end

    function love.keypressed(k)
        if k == "escape" then love.event.push("quit") end
    end
end
