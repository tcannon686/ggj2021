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

-- define the person class
local Person = {}
Person.__index = Person

function Person:new(name, known)
    local self = setmetatable({}, Person)

    self.name = name
    self.known = known

    return self
end

function Person:ask(what)
    return self.known[what]
end

function Person:onAccused(props)
    print(self.name .. ": I can't believe you would accuse me! >:(")
end

return Person
