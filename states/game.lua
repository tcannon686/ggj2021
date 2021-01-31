-- imports
local lg = love.graphics
local g3d = require "g3d"
local Person = require "person"
local Player = require "player"
local lume = require "lume"
local StateStack = require "statestack"
local CutToBlackState = require "states/cut_to_black"
local LoseState = require "states/lose"
local WinState = require "states/win"

people = {
    "Crimson Reddington",
    "Aqua Bloomberg",
    "Lief Greenhand",
    "Dick Goldmember",
    "Bob Gray",
    "Violet Purpov",
    "Wilson White"
}

local function makeGraphList(num)
    local function makeGraph()
        -- declare the graph
        local graph = {}
        local connectionCount = {}
        for _,person in ipairs(people) do
            graph[person] = {}
            connectionCount[person] = 0
        end

        for _,person in ipairs(people) do
            -- copy the people list into a possibleConnections list
            -- this list can be modified without affecting the original
            local possibleConnections = {}
            for i,v in pairs(people) do
                possibleConnections[i] = v
            end

            -- don't add too many connections to a single person
            if connectionCount[person] < 1 then
                for i=1, math.random(3) do
                    local connection, connectionIndex

                    -- don't allow self-connections
                    repeat
                        connectionIndex = math.random(#possibleConnections)
                        connection = possibleConnections[connectionIndex]
                    until connection ~= person

                    -- remove the possibility of this connection happening again
                    table.remove(possibleConnections, connectionIndex)

                    -- keep track of how many connections this person has
                    if not graph[person][connection] then
                        connectionCount[person] = connectionCount[person] + 1
                    end
                    graph[person][connection] = connection

                    -- also keep track of how many connections the person connecting to has
                    if not graph[connection][person] then
                        connectionCount[connection] = connectionCount[connection] + 1
                    end
                    graph[connection][person] = person
                end
            end
        end

        return graph, connectionCount
    end

    graphList = {}
    for i=1, num do
        graphList[i] = makeGraph()
    end

    return graphList
end

local function printGraph(graphList)
    for i,graph in pairs(graphList) do
        print("----Graph no.".. i .. "------")
        for name,connectionList in pairs(graph) do
            local str = name .. ": "
            for _,connection in pairs(connectionList) do
                str = str .. connection .. " "
            end
            print(str)
        end
        print("--------------------")
    end
end

local function makeSus(graph, susPerson, murderer)
    for name,connectionList in pairs(graph) do
        for i,connection in pairs(connectionList) do
            if connection == susPerson then
                if (susPerson ~= murderer and murderer ~= connection) or susPerson == murderer then
                    connectionList[i] = nil
                end
                return
            end
        end
    end
end

local function makeMurderer(graphList, murderer)
    for _,graph in pairs(graphList) do
        makeSus(graph, murderer, murderer)
    end
end

local function tableLength(T)
    count = 0
    for _,i in pairs(T) do
        count = count + 1
    end
    return count
end

local function makeRandomSus(people, graphList, murderer)

    for _,name in pairs(people) do
        if name ~= murderer and math.random(0, 1) == 1 then -- sus coinFlip
            graphIndex = math.random(#graphList)
            graph = graphList[graphIndex]
            --print(name .. " is sus on graph no. " .. graphIndex)
            makeSus(graph, name, murderer)

            connectionSize = tableLength(graph[name])
            if connectionSize == 0 then
                -- print(name .. " is socially akward")
                connection = people[math.random(#people)]
                graph[name][connection] = connection
            end
        end
    end
end

-- create the Game class
local Game = {}
Game.__index = Game

function Game:new(personCount)
    local self = setmetatable({}, Game)

    local function range(n)
        local ret = {}
        for i=1, n do ret[i] = i end
        return ret
    end

    local peopleDeck = lume.shuffle(range(personCount))

    self.murderer = people[math.random(#people)]
    local graphList = makeGraphList(2)

    print("MURDERER: " .. self.murderer)

    makeMurderer(graphList, self.murderer)
    makeRandomSus(people, graphList, self.murderer)
    printGraph(graphList)

    self.map = g3d.newModel("assets/house1.obj", "assets/castle.png", {0,2,0}, nil, {-1,-1,1})
    self.player = Player:new(-1.5,1.5,0, self.map)
    --self.player.position = {-1.5,1.5,0}
    g3d.camera.lookAt(-1.5, 1.5, 0, 0,1.5,0)
    self.textbox = nil
    self.people = {}

    self.dayCount = 0

    self.magnifyingGlass = lg.newImage("assets/magnifying_glass.png")

    local locations = {
        {2.5, 1.6, 2},
        {2.25, 1.6, 5.8},
        {-0.8, 1.6, -2.4},
        {-0.75, 1.6, -5},
        {2.65, 1.6, -7},
        {7.4, 1.6, 0.71},
        {6, 1.6, -1},
        {-0.15, 1.6, 10.5},
        {-0.62, 1.6, 3},
    }

    -- create all the people
    for _,name in pairs(people) do
        print(name)
        local known = {
            graph1 = graphList[1][name],
            graph2 = graphList[2][name]
        }

        local position = table.remove(locations, math.random(#locations))

        self.people[name] = Person:new(name, known, position)
    end

    self.firstFrame = true
    self.timer = 0

    return self
end

function Game:update(dt)
    if self.firstFrame then
        self.firstFrame = false
        self:newDay()
        StateStack.peek().timer = 2
    end

    -- only update the player if there is no active textbox
    self.player:update(dt, self)

    for _, person in pairs(self.people) do
        person:update(dt, self)
    end

    self.timer = self.timer + dt

    if self.textbox then self.textbox:update(dt, self) end

    if self.queuedNextDay and not self.textbox then
        self.queuedNextDay = false
        self:newDay()
    end

    if self.queuedWin and not self.textbox then
        StateStack.push(WinState:new())
    end
end

function Game:mousemoved(x,y, dx,dy)
    if not self.textbox then
        g3d.camera.firstPersonLook(dx,dy)
    end
end

function Game:newDay()
    for name, person in pairs(self.people) do
        person.beenSpokenTo = false
    end

    self.dayCount = self.dayCount + 1

    if self.dayCount == 4 then
        -- if you used all 3 days, you lose
        StateStack.push(LoseState:new())
    else
        local function daySetup()
            self.player.position = {-1.5,1.5,0}
            g3d.camera.lookAt(-1.5, 1.5, 0, 0,1.5,0)
        end
        StateStack.push(CutToBlackState:new("Day " .. self.dayCount, daySetup))
    end
end

function Game:queueNextDay()
    self.queuedNextDay = true
end

function Game:queueWin()
    self.queuedWin = true
end

function Game:setAccuseMode()
    self.accuseMode = true

    local function accuseSetup()
        -- store the previous positions of the people
        -- so they can be returned there afterwards
        local peoplePositions = {}
        for name,person in pairs(self.people) do
            peoplePositions[name] = {person.model.translation[1], person.model.translation[2], person.model.translation[3]}
        end

        self.player.position[1] = 6.5
        self.player.position[2] = 1.5
        self.player.position[3] = 0

        -- arrange the people in a circle
        local angle = 0
        local radius = 1.25
        for name,person in pairs(self.people) do
            person.model.translation[1] = math.cos(angle)*radius + self.player.position[1]
            person.model.translation[3] = math.sin(angle)*radius + self.player.position[3]
            angle = angle + math.pi*2/#people
        end
    end

    if StateStack.peek() == self then
        StateStack.push(CutToBlackState:new(accuseSetup))
    end
end

function Game:draw()
    self.map:draw()

    for _, person in pairs(self.people) do
        person:draw(self)
    end

    -------------2D drawing--------------
    local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)

    local minutes = math.floor(math.floor(self.timer) / 60)
    local seconds = math.floor(self.timer) % 60
    if seconds < 10 then
        seconds = "0" .. seconds
    end
    lg.print("Day " .. self.dayCount, 0, 0, 0, 2)
    lg.print("Time: " .. minutes ..":" .. seconds, 0, 24, 0, 2)

    lg.setCanvas({prevCanvas, depth=true})
    --------------------------------------


    if self.textbox then self.textbox:draw(self) end
end

function Game:keypressed(k)
    if self.textbox and self.textbox.keypressed then
        self.textbox:keypressed(k)
    end

    --if k == "r" then
        --self:setAccuseMode()
    --end
end

function Game:mousepressed(k)
    for _, person in pairs(self.people) do
        person:mousepressed(k)
    end

    if self.textbox and self.textbox.mousepressed then
        self.textbox:mousepressed(k)
    end
end




return Game
