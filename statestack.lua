local StateStack = {}
local stack = {}

function StateStack.push(state)
    table.insert(stack, state)
end

function StateStack.pop()
    return table.remove(stack)
end

function StateStack.peek()
    return stack[#stack]
end

function StateStack.peekNext()
    return stack[#stack-1]
end

function StateStack.jump(state)
    StateStack.clear()
    StateStack.push(state)
end

function StateStack.clear()
    stack = {}
end

return StateStack
