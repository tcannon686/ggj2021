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
people = lume.shuffle(people)
for i,v in ipairs(people) do
    print(i,v)
end

local function makeGraph()
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

    local murderer

    -- get rid of self-references
    for person, list in pairs(graph) do
        local count = 0
        for i, other in pairs(list) do
            if other == person then
                list[i] = nil
            else
                count = count + 1
            end
        end
        --print(person, count)

        if count == 0 then
            murderer = person
            --print("murderer: " .. murderer)

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

    return graph, murderer
end

local function makeSus(graphList)
    local murderer = people[math.random(#people)]
    local hasMadeSus = false
    print("the murderer is " .. murderer)

    for i,graph in ipairs(graphList) do
        for name,list in pairs(graph) do
            if list[murderer] then
                -- count the number of people in this list
                -- if we have more than one person, the sus can be straight up removed
                local count = 0
                for _,_ in pairs(list) do
                    count = count + 1
                end

                -- only make this person sus if we have to
                -- or a random chance
                if not hasMadeSus or math.random() > 0.5 then
                    list[murderer] = nil

                    -- if this person has no other connections
                    -- or by random chance
                    -- then change their connection instead of straight up removing it
                    if count == 1 or math.random() > 0.5 then
                        local r = math.random(#people)
                        local newRef = people[r]

                        -- don't choose either the murderer or self
                        while newRef == murderer or newRef == name do
                            r = r + 1
                            if r > #people then
                                r = 1
                            end
                            newRef = people[r]
                        end

                        list[newRef] = newRef
                        hasMadeSus = true
                    end
                end
            end
        end
    end

    return murderer
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
    end
end

local graphList = {makeGraph(), makeGraph()}

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
--printGraph(graphList)
