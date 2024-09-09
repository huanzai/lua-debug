
function wait(is_thread)
    print("wait ...")
    os.remove("1")
    while true do 
        local command = "powershell -Command \"Start-Sleep -Milliseconds 10\""
        os.execute(command)

        local f = io.open("1","r")
        if f then 
            io.close(f)
            break
        end

        if is_thread then 
            coroutine.yield()
        end
    end
    print("continue ...")
end

wait()

require "debugger":start "127.0.0.1:12306":setup_patch():event "wait"
print "ok"

local count = 0
function do_something()
    count = count + 1
    if 10 == count then 
        wait(true) -- 等待
        print("start load test1.lua")
        local test1 = require "test1"
        local ret = test1()
        print("finish load test1.lua", ret)
    end
end

function do_update() 
    print("do_update")
    while true do 
        local ok,err = pcall(do_something)
        if not ok then 
            print(err)
        end
        coroutine.yield()
    end
end

local co = coroutine.create(do_update)
print("create thread")

while true do 
    coroutine.resume(co)
    local command = "powershell -Command \"Start-Sleep -Milliseconds 10\""
    os.execute(command)
end

print "okkkkkk..."
