-- common.lua
local _M = {}

-- 同与分割form-data中的数据
function _M.split_func(s, delim)
    if type(delim) ~= "string" or string.len(delim) <= 0 then
        return nil
    end
 
    local start = 1
    local t = {}
    while true do
        local pos = string.find (s, delim, start, true)
        if not pos then
            break
        end
        table.insert (t, string.sub (s, start, pos - 1))
        start = pos + string.len (delim)
    end
    table.insert (t, string.sub (s, start))
    return t
end

-- 获取form-data中的数据，以lua table返回
function _M.get_form_data_func(form, err)
    if not form then
        ngx.say(ngx.ERR, "failed to new upload: ", err)
        ngx.exit(500)
    end

    form:set_timeout(1000)

    local paramTable = {["s"]=1}
    local tempkey = ""
    while true do
        local typ, res, err = form:read()
        if not typ then
            ngx.say("failed to read: ", err)
            return {}
        end
        local key = ""
        local value = ""
        if typ == "header" then
            local key_res = _M.split_func(res[2],";")
            key_res = key_res[2]
            key_res = _M.split_func(key_res,"=")
            key = (string.gsub(key_res[2],"\"",""))
            paramTable[key] = ""
            tempkey = key
        end 
        if typ == "body" then
            value = res
        if paramTable.s ~= nil then paramTable.s = nil end
            paramTable[tempkey] = value
        end
        if typ == "eof" then
            break
        end
    end
    return paramTable
end

-- 转换为json串格式
function _M.table_to_json_func(tbl)
    local function serialize(tbl)
        local tmp = {}
        for k, v in pairs(tbl) do
            local k_type = type(k)
            local v_type = type(v)
            local key = (k_type == "string" and "\"" .. k .. "\":")
                or (k_type == "number" and "")
            local value = (v_type == "table" and serialize(v))
                or (v_type == "boolean" and tostring(v))
                or (v_type == "string" and "\"" .. v .. "\"")
                or (v_type == "number" and v)
            tmp[#tmp + 1] = key and value and tostring(key) .. tostring(value) or nil
        end
        if table.maxn(tbl) == 0 then
            return "{" .. table.concat(tmp, ",") .. "}"
        else
            return "[" .. table.concat(tmp, ",") .. "]"
        end
    end
    assert(type(tbl) == "table")
    return serialize(tbl)
end

return _M