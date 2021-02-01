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

hs.hotkey.bind(nil, "F19", function()
    toggle = not toggle
    carlLogger.df('State of toggle is %s', toggle)
    if toggle then
        storedAllVisibleWindows = hs.window.visibleWindows()
        local focusedWindow = hs.window.focusedWindow()
        carlLogger.df('Focused window is %s', focusedWindow)
        hideAllActiveWindows()
        hs.timer.doAfter(0.01, function()
            focusedWindow:application():unhide()
            focusedWindow:centerOnScreen(hs.mouse:getCurrentScreen())
        end)
    else
        showWindowsInAllWindows(storedAllVisibleWindows)
        focusedWindow:focus()
        hs.layout.apply(storedWindowsLayout)
    end
end)

-- local function getLayOuts()
--     local layouts = {}
--     layouts.left = hs.layout.left50;
--     layouts.right = hs.layout.right50;
--     layouts.lowerRight = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 })
--     layouts.upperRight = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.5, h = 0.5 })
--     layouts.upperRightLeft = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.25, h = 0.5 })
--     layouts.upperRightRight = hs.geometry.unitrect({ x = 0.75, y = 0, w = 0.25, h = 0.5 })
--     layouts.lowerRightRight = hs.geometry.unitrect({ x = 0.75, y = 0.5, w = 0.25, h = 0.5 })
--     layouts.lowerLeftRight = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.25, h = 0.5 })
--     layouts.rightLeft = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.25, h = 1 })
--     layouts.leftLeft = hs.geometry.unitrect({ x = 0, y = 0, w = 0.25, h = 1 })
--     layouts.q = hs.geometry.unitrect({ x = 0, y = 0, w = 0.25, h = 0.5 })
--     layouts.a = hs.geometry.unitrect({ x = 0, y = 0.5, w = 0.25, h = 0.5 })
--     layouts.d = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.25, h = 0.5 })
--     layouts.f = hs.geometry.unitrect({ x = 0.75, y = 0.5, w = 0.25, h = 0.5 })
--     layouts.qw = hs.geometry.unitrect({ x = 0, y = 0, w = 0.5, h = 0.5 })
--     layouts.as = hs.geometry.unitrect({ x = 0, y = 0.5, w = 0.5, h = 0.5 })
--     layouts.sd = hs.geometry.unitrect({ x = 0.25, y = 0.5, w = 0.5, h = 0.5 })
--     layouts.df = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 })
--     layouts.er = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.5, h = 0.5 })
--     layouts.ed = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.25, h = 1 })
--     layouts.rf = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.5, h = 1 })
--     layouts.qwas = hs.layout.left50;
--     layouts.erdf = hs.layout.right50;
--     layouts.wesd = hs.geometry.unitrect({ x = 0.25, y = 0, w = 0.5, h = 1 });
--     layouts.qwerasdf = hs.geometry.unitrect({ x = 0, y = 0, w = 1, h = 1 });
--     return layouts
-- end
