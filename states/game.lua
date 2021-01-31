-- imports
local lg = love.graphics
local g3d = require "g3d"
local Person = require "person"
local Player = require "player"
local lume = require "lume"

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

local function makeSus(graph, susPerson)
    for name,connectionList in pairs(graph) do
        for i,connection in pairs(connectionList) do
            if connection == susPerson then
                connectionList[i] = nil
                return
            end
        end
    end
end

local function makeMurderer(graphList, murderer)
    for _,graph in pairs(graphList) do
        makeSus(graph, murderer)
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
            print(name .. " is sus on graph no. " .. graphIndex)
            makeSus(graph, name)

            connectionSize = tableLength(graph[name])
            if connectionSize == 0 then
                print(name .. " is socially akward")
                connection = math.random(#people)
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
    self.background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", {0,0,0}, nil, {500,500,500})
    self.player = Player:new(0,0,0, self.map)

    self.textbox = nil
    self.timer = 300

    self.people = {}

    -- create all the people
    for _,name in pairs(people) do
        print(name)
        local known = {
            graph1 = graphList[1][name],
            graph2 = graphList[2][name]
        }

        self.people[name] = Person:new(name, known)
    end

    return self
end

function Game:update(dt)
    -- only update the player if there is no active textbox
    self.player:update(dt, self)

    for _, person in pairs(self.people) do
        person:update(dt, self)
    end

    self.timer = self.timer - dt

    if self.textbox then self.textbox:update(dt, self) end
end

function Game:mousemoved(x,y, dx,dy)
    if not self.textbox then
        g3d.camera.firstPersonLook(dx,dy)
    end
end

function Game:draw()
    --self.player:draw()
    self.background:draw()
    self.map:draw()

    for _, person in pairs(self.people) do
        person:draw(self)
    end

    -------------2D drawing--------------
    local prevCanvas = lg.getCanvas()
    lg.setCanvas(GuiCanvas)
    
    local currTime = math.floor(self.timer)
    lg.print("Time left: " .. math.floor(currTime/60) ..":" .. currTime % 60, 0, 0, 0, 2)

    lg.setCanvas({prevCanvas, depth=true})
    --------------------------------------


    if self.textbox then self.textbox:draw(self) end
end

function Game:keypressed(k)
    if self.textbox and self.textbox.keypressed then
        self.textbox:keypressed(k)
    end
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
