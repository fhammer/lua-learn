---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by fuzh2.
--- DateTime: 2021/7/27 22:07
---

print('hello lua')

-- 初始化表
mytable = {}

-- 指定值
mytable['tag'] = "Lua"

print(mytable.tag)

-- 移除引用
mytable = nil
-- lua 垃圾回收会释放内存


str1 = "OK 我赢了"
i = 1
while true do
    c = string.sub(str1, i, i)
    b = string.byte(c)
    if b > 128 then
        print(string.sub(str1, i, i + 2))
        i = i + 3
    else
        if b == 32 then
            print("empty")
        else
            print(c)
        end
        i = i + 1
    end
    if i > #str1 then
        break
    end
end


function split(str,delimiter)
    local dLen = string.len(delimiter)
    local newDeli = ''
    for i=1,dLen,1 do
        newDeli = newDeli .. "["..string.sub(delimiter,i,i).."]"
    end
    print(newDeli)
    local locaStart,locaEnd = string.find(str,newDeli)

    local arr = {}
    local n = 1
    while locaStart ~= nil
    do
        if locaStart>0 then
            arr[n] = string.sub(str,1,locaStart-1)
            n = n + 1
        end
        str = string.sub(str,locaEnd+1,string.len(str))
        locaStart,locaEnd = string.find(str,newDeli)
    end
    if str ~= nil then
        arr[n] = str
    end
    return arr
end
t = split("php,js", ",")
for k, v in pairs(t) do
    print(k, v)
end



function string.split(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end

    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end
--测试
local str = "1234,389,abc";
local list = string.split(str, ",");
