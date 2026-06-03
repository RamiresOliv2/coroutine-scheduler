# Lua Scheduler
> This is a simple scheduler made in Lua that can manage functions and control them.

## default run:
```lua
local looper = function(thread)
  local iam = thread.name
  local i = 0
  while true do
    i = i + 1
    print(iam .. ": I am in a loop!! x" .. tostring(i))
    task.halt() -- halt to handler deal with it!
    -- asdasd() -- no error
  end
end
```
![](https://github.com/RamiresOliv2/coroutine-scheduler/blob/main/IMG_20260603_120549.jpg)

## error run:
```lua
local looper = function(thread)
  local iam = thread.name
  local i = 0
  while true do
    i = i + 1
    print(iam .. ": I am in a loop!! x" .. tostring(i))
    task.halt() -- halt to handler deal with it!
    asdasd() -- simple error [to test]
  end
end
```
![](https://github.com/RamiresOliv2/coroutine-scheduler/blob/main/IMG_20260603_120518.jpg)
