local people = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
}

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

local function printGraph(graph)
    for name,connectionList in pairs(graph) do
        local str = name .. ": "
        for _,connection in pairs(connectionList) do
            str = str .. connection .. " "
        end
        print(str)
    end
end

local function makeMurderer(graph, murderer)
    for name,connectionList in pairs(graph) do
        for i,connection in pairs(connectionList) do
            if connection == murderer then connectionList[i] = nil end
        end
    end
end

math.randomseed(os.time())
local murderer = people[math.random(#people)]
local blueGraph, blueConnectionCount = makeGraph()
local redGraph, redConnectionCount = makeGraph()

-- printGraph(blueGraph)
-- print("-----")
-- printGraph(redGraph)
print("MURDERER: " .. murderer)

makeMurderer(blueGraph, murderer)
makeMurderer(redGraph, murderer)

printGraph(blueGraph)
print("-----")
printGraph(redGraph)