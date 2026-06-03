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


local thread1, r = task.new("test1", looper)
local thread2 = task.new("test2", looper, true) -- starts paused due to true

-- thread already paused, so no run
print(task.status(thread2)) -- r: paused

-- resumes the thread
task.resume(thread2)

-- task.kill(thread1)
-- print(task.status(thread)) -- dead, process killed

task.handler() -- handler
print("end")
