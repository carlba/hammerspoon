--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
hs.alert:show("hello tspoon")
local test = "this is a test"
local parts = __TS__StringSplit(test, "")

--w = hs.httpserver.new():setPort(8082):setCallback(function(method, path, headers, body)
--
--    local uriParts = string.split(path, '/')
--
--    print('method:'.. method .. ' path:' .. path .. ' body' .. body)
--
--
--
--    if uriParts[1] == 'commands' then
--        if uriParts[2] == 'work' then
--            work()
--            return '', 200, { ["Content-Type"] = "application/json" }
--
--        end
--    end
--end
