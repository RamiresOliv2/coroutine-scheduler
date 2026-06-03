local task = {}

local threads = {}

local findThread = function(pid)
  for i, v in pairs(threads) do
      if v.pid == pid then return v, i end
  end

  return nil
end

task.new = function(name, f, paused)
  local s = "running"

  if paused == true then s = "paused" end

  local pid = #threads + 1
  table.insert(threads, {
    name = name,
    c = coroutine.create(f),
    pid = pid,
    status = s,
    created = os.time(),
    error = nil
  })

  if not paused then 
    local ok, r = coroutine.resume(threads[#threads].c, threads[#threads])
  else return pid end

  if ok == false then
    threads[#threads].error = r
    return nil, r
  end

  return pid
end

task.resume = function(pid)
  local thread = findThread(pid)

  if thread.status == "dead" then return false, "thread already dead." end

  if thread then
    thread.status = "running"
    return true
  end

  return false
end

task.pause = function(pid)
  local thread = findThread(pid)

  if thread.status == "dead" then return false, "thread dead." end

  if thread then
    thread.status = "paused"
    return true
  end

  return false
end

task.kill = function(pid)
  local thread = findThread(pid)

  if thread.status == "dead" then return false, "thread dead." end

  if thread then
    thread.status = "dead"
    thread.error = "process killed"
    return true
  end

  return false
end

task.status = function(pid)
  local thread = findThread(pid)
  
  if thread then
    return thread.status, thread.error
  end

  return nil
end

task.halt = function(...)
  coroutine.yield(...)
end

task.handler = function()
  while true do
    for _, thread in pairs(threads) do
      local s = coroutine.status(thread.c)
      if s == "suspended" then
        if thread.status == "running" then
          local ok, r = coroutine.resume(thread.c, thread)
          if not ok then
            print("[thread-" .. thread.name .. "] yield err:", r)
            thread.error = r
            thread.status = "dead"
          end

          if ok and r == "stop" then
            thread.status = "dead"
          end
        end
      elseif s == "dead" then
        thread.status = "dead"
      end
    end

  os.execute("sleep 0.1")
  end
end

return task
