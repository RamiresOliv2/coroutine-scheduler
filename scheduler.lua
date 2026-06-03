local task = {}

local threads = {}

local findThread = function(pid)
  for i, v in pairs(threads) do
      if v.pid == pid then return v end
  end

  return nil
end

task.new = function(name, f)
  local pid = #threads + 1
  table.insert(threads, {
    name = name,
    c = coroutine.create(f),
    pid = pid,
    status = "running",
    created = os.time(),
  })

  local ok, r = coroutine.resume(threads[#threads].c, threads[#threads])

  if ok then
    return pid
  else return ok, r end
end

task.resume = function(pid)
  local thread = findThread(pid)

  if thread then
    thread.status = "running"
    return true
  end
end

task.pause = function(pid)
  local thread = findThread(pid)

  if thread then
    thread.status = "paused"
    return true
  end
end

task.loop = function()
  while true do
    for _, thread in pairs(threads) do
      local s = coroutine.status(thread.c)
      if s == "suspended" then
        if thread.status == "running" then
          local ok, r = coroutine.resume(thread.c, thread)
          if not ok then
            print("after yield err:", r)
            thread.status = "dead"
          end
        end
      elseif s == "dead" then
        thread.status = "dead"
      end
    end

  os.execute("sleep 0.1") -- poor try to not blow up
  end
end

return task
