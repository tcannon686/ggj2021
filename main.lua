-- imports
local StateStack = require "statestack"
local Game = require "states/game"

-- so that stdout happens during runtime on windows git bash
io.stdout:setvbuf("no")

function love.load()
    love.graphics.setBackgroundColor(0.25,0.5,1)
    love.graphics.setDefaultFilter("nearest")

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
        local state = StateStack:peek()
        if state and state.draw then
            state:draw(...)
        end
    end

    function love.keypressed(k)
        if k == "escape" then love.event.push("quit") end
    end
end
