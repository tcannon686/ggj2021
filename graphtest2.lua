local people = {
    "Crimson Reddington",
    "Aqua Bloomberg",
    "Lief Greenhand",
    "Dick Goldmember",
    "Bob Gray",
    "Violet Purpov",
    "Wilson White"
}

math.randomseed(os.time())

local lume = require "lume"

local murderer

local function makeGraph()
    people = lume.shuffle(people)

    -- if there is already a murderer defined
    -- then put the murderer at the end
    if murderer then
        local i = 1
        while i < #people do
            if people[i] == murderer then
                table.remove(people, i)
                table.insert(people, murderer)
            else
                i = i + 1
            end
        end
    end

    -- split the people list into random
    -- strongly connected components
    local graph = {}
    local component = {}
    local interval = math.random(2)
    for index,thisPerson in ipairs(people) do
        print(thisPerson)
        graph[thisPerson] = {}
        component[thisPerson] = thisPerson
        for i,v in pairs(component) do
            graph[thisPerson][i] = v
            graph[i][thisPerson] = thisPerson
        end

        if (index > interval or index == #people-1) and index ~= #people-2 then
            interval = index + math.random(2)
            component = {}
            print("-----")
        end
    end
    print("-------")

    for person, list in pairs(graph) do
        local count = 0

        -- get rid of self-references
        -- and count the amount of references
        for i, other in pairs(list) do
            if other == person then
                list[i] = nil
            else
                count = count + 1
            end
        end

        if count == 0 then
            if not murderer then
                murderer = person
            end

            local r = math.random(#people)
            local newRef = people[r]

            -- don't choose either the murderer or self
            while newRef == name do
                r = r + 1
                if r > #people then
                    r = 1
                end
                newRef = people[r]
            end

            list[newRef] = newRef
        end
    end

    return graph
end

local function makeSus(graphList)
    local sussed = {}

    for _,graph in ipairs(graphList) do
        for name,list in pairs(graph) do
            if not sussed[name] and math.random() < 0.25 then
                local count = 0
                local nameToRemove
                for n,_ in pairs(list) do
                    count = count + 1
                    nameToRemove = n
                end

                if count > 1 then
                    sussed[name] = true
                    list[nameToRemove] = nil
                end
            end
        end
    end

    for i,v in pairs(sussed) do
        print("sussed " .. i)
    end
end

local function printGraph(graphList)
    for i,graph in ipairs(graphList) do
        for name,connectionList in pairs(graph) do
            local str = name .. ": "
            for _,connection in pairs(connectionList) do
                str = str .. connection .. ", "
            end
            print(str)
        end
        --print("-------------")
    end
end

--print("-------")
local graphList = {makeGraph(), makeGraph()}

--[[
printGraph(graphList)
print("-------------")
makeSus(graphList)
print("-------------")
printGraph(graphList)
]]

--[[
for name,connectionList in pairs(graphList[1]) do
    local str = name .. ": "
    for _,connection in pairs(connectionList) do
        str = str .. connection .. ", "
    end
    print(str)
end
print("-----")
for name,connectionList in pairs(graphList[2]) do
    local str = name .. ": "
    for _,connection in pairs(connectionList) do
        str = str .. connection .. ", "
    end
    print(str)
end
]]
--printGraph(graphList)
