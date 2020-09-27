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

hs.hotkey.bind({ "cmd", "alt" }, "t", arrangeWindows)
local wifiWatcher = nil
local homeSSID = "Fenix"
local workSSID = "SmithNet"
local lastSSID = hs.wifi.currentNetwork()

local function ssidChangedCallback()
    local newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        hs.alert.show("Joined Home SSID")
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        hs.alert.show("Departed Home SSID")
    end

    if newSSID == workSSID and lastSSID ~= workSSID then
        -- We just joined our work WiFi network
        hs.alert.show("Joined Work SSID")
    elseif newSSID ~= workSSID and lastSSID == workSSID then
        -- We just departed our work WiFi network
        hs.alert.show("Departed Work SSID")
    end
    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
