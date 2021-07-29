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


local function applicationWatcher(appName, eventType, appObject)
    if isDebug then
        log(appName .. eventType .. "\n")
    end
    
    -- https://www.hammerspoon.org/docs/hs.application.watcher.html    
    local applicationEvents = {
        hs.application.watcher.launched,
        -- hs.application.watcher.activated,
        -- hs.application.watcher.deactivated
    }

    if (utils.findInTable(applicationEvents, eventType)) then
        arrangeWindows(appName)
    end
end

local function arrangeWindows(windowTitle)
    -- https://www.hammerspoon.org/docs/hs.layout.html
    local layouts = getLayouts();
    local windowLayout = {}
    local allScreens = hs.screen.allScreens()
    local screenCount = utils.countTable(hs.screen.allScreens())
    local monitor1 = allScreens[1]:name()

    if screenCount == 1 and (monitor1  == "Color LCD") then
        -- maximized window hs.geometry.unitrect({x=1, y=1, w=1, h=1}).
        windowLayout = {
            { "Google Chrome", nil, monitor1, layouts.right, nil, nil },
            { "PyCharm", nil, monitor1, layouts.left, nil, nil },
            { "WebStorm", nil, monitor1, layouts.left, nil, nil },
            { "Mail", nil, monitor1, layouts.upperRight, nil, nil },
            { "Microsoft Teams", nil, layouts.monitor1, right, nil, nil },
            { "Slack", nil, monitor1, layouts.right, nil, nil },
            { "Spotify", nil, monitor1, layouts.right, nil, nil },
            { "Todoist", nil, monitor1, layouts.right, nil, nil },
            { "Iterm2", nil, monitor1, layouts.right, nil, nil },
            { "Plex", nil, monitor1, layouts.upperRight, nil, nil },
        }
    elseif screenCount == 1 and (monitor1  == "PHL BDM4037U" or monitor1  == "ASUS PB287Q") then
        monitor1 = allScreens[1]:name()
        -- maximized window hs.geometry.unitrect({x=1, y=1, w=1, h=1}).
        windowLayout = {
            { "Google Chrome", nil, monitor1, layouts.rightLeft, nil, nil },
            { "Chromium", nil, monitor1, layouts.lowerLeftRight, nil, nil },
            { "Firefox", nil, monitor1, layouts.rightLeft, nil, nil },
            { "Safari", nil, monitor1, layouts.rightLeft, nil, nil },
            { "PyCharm", nil, monitor1, layouts.left, nil, nil },
            { "WebStorm", nil, monitor1, layouts.left, nil, nil },
            { "PyCharm", "Commit Changes", monitor1, layouts.right, nil, nil },
            { "Sublime Text", nil, monitor1, layouts.upperRightRight, nil },
            { "Wiki", nil, monitor1, layouts.upperRightRight, nil },
            { "Code", nil, monitor1, layouts.left, nil, nil },
            { "Mail", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Microsoft Teams", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Calendar", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Messenger", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Skype for Business", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "MacPass" , nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Slack", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Messenger", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Todoist", nil, monitor1, layouts.lowerRightRight, nil, nil },
            { "Iterm2", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Calculator", nil, monitor1, layouts.lowerRight, nil, nil },
            { "Activity Monitor", nil, monitor1, layouts.upperRightRight, nil, nil },
            { "Hammerspoon", nil, monitor1, layouts.lowerRightRight, nil, nil },
            { "Spotify", nil, monitor1, layouts.lowerRightRight, nil, nil },
        }
    else
        local monitor2 = allScreens[2]:name()
        -- maximized window hs.geometry.unitrect({x=1, y=1, w=1, h=1}).
        windowLayout = {
            { "Google Chrome", nil, monitor2, layouts.left, nil, nil },
            { "Firefox", nil, monitor2, layouts.left, nil, nil },
            { "PyCharm", nil, monitor1, layouts.left, nil, nil },
            { "PyCharm", "Commit Changes", monitor1, layouts.right, nil, nil },
            { "WebStorm", nil, monitor1, layouts.left, nil, nil },
            { "Sublime Text", nil, monitor1, layouts.upperRight, nil, nil },
            { "Mail", nil, monitor2, layouts.upperRight, nil, nil },
            { "Microsoft Teams", nil, monitor2, layouts.upperRight, nil, nil },
            { "Skype for Business", nil, monitor2, layouts.upperRight, nil, nil },
            { "Franz", nil, monitor2, layouts.upperRight, nil, nil },
            { "Slack", nil, monitor2, layouts.upperRight, nil, nil },
            { "Spotify", nil, monitor2, layouts.lowerRight, nil, nil },
            { "Todoist", nil, monitor2, layouts.lowerRight, nil, nil },
            { "iTerm2", nil, monitor1, layouts.lowerRight, nil, nil },
            { "Calculator", nil, monitor1, layouts.lowerRight, nil, nil },
        }
    end
    if windowTitle ~= nil then
        windowLayout = utils.getFilteredWindowLayout(windowLayout, windowTitle)
        hs.timer.doAfter(0.2, function()
            hs.layout.apply(windowLayout)
        end)
    else
        hs.layout.apply(windowLayout)
    end
end

local function getLayouts8by2()
    hs.grid.setGrid('8x2')
    hs.grid.setMargins('0x0')
    local layouts = {}
    local monitor1 = hs.screen.allScreens()[1]
    layouts.qwer = hs.grid.getCell('0,0 4x1', monitor1)
    layouts.qwerasdf = hs.grid.getCell('0,0 4x4', monitor1)
    layouts.ty = hs.grid.getCell('4,0 2x1', monitor1)
    layouts.tyu = hs.grid.getCell('4,0 3x1', monitor1)
    layouts.tyui = hs.grid.getCell('4,0 4x1', monitor1)
    layouts.tyui = hs.grid.getCell('4,0 4x1', monitor1)
    layouts.tyuighjk = hs.grid.getCell('4,0 4x4', monitor1)
    layouts.ghjk = hs.grid.getCell('4,1 4x1', monitor1)
    layouts.ui = hs.grid.getCell('6,0 2x1', monitor1)
    layouts.as = hs.grid.getCell('0,1 2x1', monitor1)
    layouts.dfg = hs.grid.getCell('2,1 3x1', monitor1)
    layouts.hjk = hs.grid.getCell('5,1 3x1', monitor1)
    return layouts
end