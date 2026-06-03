local task = require("scheduler")

local looper = function(thread)
  local iam = thread.name
  local i = 0
  while true do
    i = i + 1
    print(iam .. ": I am in a loop!! x" .. tostring(i))
    coroutine.yield() -- halt to handler deal with it!
  end
end


local thread = task.new("test", looper)
local thread2 = task.new("lalalala", looper)

toilet.handler()
print("end")
