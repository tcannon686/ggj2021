
local locations = {
    'patio',
    'pool',
    'kitchen',
    'backyard',
    'garage',
    'theater',
    'living room'
}

local weapons = {
    'knife',
    'candlestick',
    'trophy',
    'rope',
    'pistol',
    'soap',
    'poison'
}

local people = {
    'red',
    'blue',
    'green',
    'yellow',
    'blue',
    'purple',
    'white'
}

-- Creates an array from the range i to j (inclusive)
function range (i, j)
    ret = {}
    for x = i, j do
        ret[x - i + 1] = i
    end
    return ret
end

-- Creates a permutation of the given array
function shuffle (array)
    local ret = {}
    for i, v in ipairs(array) do
        -- Place the item in a random spot in the array.
        while true do
            local index = math.random(1, #array)
            if not ret[index] then
                ret[index] = v
                break
            end
        end
    end

    return ret
end

--[[
Creates a person.

Fields:
 - ask (what)        A function to ask about the murder. The 'what' field is what
                     field of 'known' to ask about, i.e. 'person', 'location', or
                     'weapon'. Returns two values. The first value is the answer or
                     nil if they are unwilling to answer the question. The second
                     value is a string representing their dialog.
 - onMakeAccusation  Called when the user makes an accusation
 - onAccused         Called when the user accuses this person
]]
function makePerson (props)
    local known = props.known

    local ret = {
        ask = function (what)
            local dialogue
            if what == 'weapon' then
                dialogue = weapons[known[what]]
            elseif what == 'person' then
                dialogue = people[known[what]]
            elseif what == 'location' then
                dialogue = locations[known[what]]
            end
            return known[what], dialogue
        end,
        onMakeAccusation = function (props)
        end,
        onAccused = function (props)
        end
    }

    return ret
end

--[[
Creates the game state.

Fields:
 - people          A list of people created using makePerson.
 - accuse (props)  Accuse a person of the murder. Returns true if the
                   accusation is true, false otherwise. props should be a table
                   including the person, the weapon, and the location.
 - ask (props)     Ask a person a question. Props should contain two fields:
                   person, and what. Returns two values. The first value is the
                   person's response or nil if they won't answer the question,
                   the second is their dialogue.
]]
function makeGame ()
    -- Create permutations of each field.
    local weapons = shuffle(range(1, 7))
    local people = shuffle(range(1, 7))
    local locations = shuffle(range(1, 7))
    local truth

    local ret = {
        people = {}
    }

    -- Create the people.
    for i = 1, 7 do
        local known = {
            weapon = weapons[i],
            person = people[i],
            location = locations[i]
        }
        if i == 7 then
            truth = known
        else
            ret.people[i] = makePerson {
                known = known
            }
        end
    end

    ret.accuse = function (props)
        if (truth.person == props.person and
            truth.location == props.location and
            truth.weapon == props.weapon) then
            return true
        else
            for i, person in ret.people do
                person.onMakeAccusation(props)
                if i == props.person then
                    person.onAccused(props)
                end
            end
        end
    end

    ret.ask = function (props)
        return ret.people[props.person].ask(props.what)
    end

    return ret
end

-- Returns the index of the value in the given table or nil.
function indexOf (table, value)
    for i, v in ipairs(table) do
        if v == value then
            return i
        end
    end
    return nil
end

function cmdlineGame ()
    print([[Commands:

ask [name] [weapon|location|name]   Ask the person with the given name what they
                                    saw.
accuse [weapon] [location] [name]   Accuse the given person of commiting the
                                    murder.

Examples:
ask red weapon

People:
]])
    for i, v in ipairs(people) do
        print(v)
    end
    print([[
Locations:
]])
    for i, v in ipairs(locations) do
        print(v)
    end
    print([[
Weapons:
]])
    for i, v in ipairs(weapons) do
        print(v)
    end
    print()

    local game = makeGame()

    function parseArgs (table, arg)
        local value = indexOf(people, arg)
        if not value then
            value = indexOf(locations, arg)
            if not value then
                value = indexOf(weapons, arg)
                table.weapon = value
                if not value then
                    return false
                end
            else
                table.location = value
            end
        else
            table.people = value
        end
        return true
    end

    for line in io.lines() do
        local verb, args = string.match(line, '(%w+) (.*)')
        if verb == 'ask' then
            local a1, a2 = string.match(args, '(%w+) (%w+)')
            result, dialog = game.ask {
                person = indexOf(people, a1),
                what = a2
            }
            print(dialog)
        elseif verb == 'accuse' then
            local a1, a2, a3 = string.match(args, '(%w+) (%w+) (%w+)')
            local args = {}
            if (parseArgs(args, a1) and
                parseArgs(args, a2) and
                parseArgs(args, a3)) then
                if game.accuse(args) then
                    print('you win!')
                else
                    print('nope')
                end
            else
                print('unknown arguments')
            end
        else
            print('unknown command')
        end
    end
end

cmdlineGame()
