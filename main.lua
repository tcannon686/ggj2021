-- imports
local StateStack = require "statestack"
local Game = require "states/game"
local Title = require "states/title"

local lg = love.graphics

-- so that stdout happens during runtime on windows git bash
io.stdout:setvbuf("no")

GAME_WIDTH = 1024
GAME_HEIGHT = 576

function love.load()
    love.graphics.setDefaultFilter("nearest")

    MainFont = love.graphics.newFont("assets/ProggyClean.ttf", 16)
    love.graphics.setFont(MainFont)

    -- global, so it can be accessed easily by textbox.lua
    GuiCanvas = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)

    local screen = love.graphics.newCanvas(GAME_WIDTH, GAME_HEIGHT)

    -- push a game with 7 people onto the StateStack
    -- StateStack.push(Game:new(7))
    StateStack.push(Title:new())

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

    function love.keypressed(...)
        if ({...})[1] == "escape" then love.event.push("quit") end

        local state = StateStack:peek()
        if state and state.keypressed then
            state:keypressed(...)
        end
    end

     function love.mousepressed(...)
        local state = StateStack:peek()
        if state and state.mousepressed then
            state:mousepressed(({...})[3])
        end
    end


    function love.draw(...)
        lg.setCanvas(GuiCanvas)
        lg.clear(0,0,0,0)
        lg.setCanvas({screen, depth=true})
        lg.clear(0,0,0,0)

        local state = StateStack:peek()
        if state and state.draw then
            state:draw(...)
        end

        lg.setCanvas()
        local letterBox = math.min(lg.getWidth()/screen:getWidth(), lg.getHeight()/screen:getHeight())
        lg.draw(screen, lg.getWidth()/2, lg.getHeight()/2, 0, letterBox, letterBox*-1, GAME_WIDTH/2, GAME_HEIGHT/2)
        lg.draw(GuiCanvas, lg.getWidth()/2, lg.getHeight()/2, 0, letterBox, letterBox*1, GAME_WIDTH/2, GAME_HEIGHT/2)
    end
end
