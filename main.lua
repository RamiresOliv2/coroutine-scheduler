local task = require("scheduler")

local looper = function(thread)
  local iam = thread.name
  local i = 0
  while true do
    i = i + 1
    print(iam .. ": I am in a loop!! x" .. tostring(i))
    task.halt() -- halt to handler deal with it!
    -- asdasd() -- simple error
  end
end


local thread = task.new("test", looper)
local thread2 = task.new("lalalala", looper, true) -- starts paused due to true

-- thread already paused, so no run
print(task.status(thread2)) -- r: paused

-- resumes the thread
task.resume(thread2)

task.handler() -- handler
print("end")
