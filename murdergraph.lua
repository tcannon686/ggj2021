math.randomseed(os.time())
local people = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
}

local function makeGraph(name)
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

local function printGraph(graphList)
    for _,graph in pairs(graphList) do
        print("--------------------")
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

local function makeMurderer(graphList, murderer)
    for _,graph in pairs(graphList) do
        makeSus(graph, murderer)
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



local murderer = people[math.random(#people)]
local blueGraph, blueConnectionCount = makeGraph()
local redGraph, redConnectionCount = makeGraph()

-- printGraph(blueGraph)
-- print("-----")
-- printGraph(redGraph)
print("MURDERER: " .. murderer)

makeSus(blueGraph, murderer)
makeSus(redGraph, murderer)

makeRandomSus(people, {blueGraph, redGraph}, murderer)

printGraph({blueGraph, redGraph})
