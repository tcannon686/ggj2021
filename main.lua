-- imports
local Game = require "game"

local intro = [[
Commands:

ask [name] [weapon|location|name]   Ask the person with the given name what they
                                    saw.
accuse [weapon] [location] [name]   Accuse the given person of commiting the
                                    murder.

Examples:
ask red weapon

]]

-- Returns the index of the value in the given table or nil.
function indexOf(table, value)
    for i, v in ipairs(table) do
        if v == value then
            return i
        end
    end
    return nil
end

function cmdlineGame()
    print(intro)

    local game = Game:new(7)

    for line in io.lines() do
        local verb, args = string.match(line, "(%w+) (.*)")

        -- if no args were given
        if not verb then
            verb = string.match(line, "(%w+)")
        end
        
        if verb == "exit" then
            break
        end

        if verb == "ask" then
            print(game:ask(string.match(args, "(%w+) (%w+)")))
        end

        if verb == "accuse" then
            if game:accuse(string.match(args, "(%w+) (%w+) (%w+)")) then
                break
            end
        end

        if verb == "truth" then
            for i,v in pairs(game.truth) do
                print(i,v)
            end
        end
    end
end

cmdlineGame()
