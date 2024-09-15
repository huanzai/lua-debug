

-- 测试 hook 在协程中的表现

local function co_func()

    print(1)

    coroutine.yield()

    print(2)

    coroutine.yield()

    print(3)

    coroutine.yield()

    print(4)
end

local function hook(event, line)
    if event == "call" then 
        local info = debug.getinfo(2, "lSn")
        print(string.format("event:call %s currentline:%d", info.name, info.currentline))
    elseif event == "return" then
        local info = debug.getinfo(2, "lSn")
        print(string.format("event:return %s currentline:%d", info.name, info.currentline))
    elseif event == "line" then
        print("event:line", line)
    end
end

local co = coroutine.create(co_func)

debug.sethook(co, hook, "crl")

coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)

print("done")

