local secrets = require "secrets"

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:updateRepo('default')
spoon.SpoonInstall:andUse('ReloadConfiguration')
spoon.SpoonInstall:andUse('KSheet')
spoon.ReloadConfiguration:start()

hs.loadSpoon('HomeAssistantMenu')
spoon.HomeAssistantMenu.uri = secrets.homeAssistant.uri
spoon.HomeAssistantMenu.token = secrets.homeAssistant.token
spoon.HomeAssistantMenu.temperature_sensor = secrets.homeAssistant.temperature_sensor
spoon.HomeAssistantMenu:start()

carlLogger = hs.logger.new('carlLogger')

isDebug = true

hs.window.animationDuration = 0 -- disable animations
-- https://www.hammerspoon.org/docs/hs.logger.html#level
-- Higher is more verbose
hs.logger.setGlobalLogLevel(5)

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


local function log (message)
    file = io.open("/Users/cbackstrom/hammerspoon.log", "a")
    file:write(os.date("!%Y%m%d,%H:%M:%S,") .. message .. "\n")
    file:flush()
end

function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function string.split(String, separator)
    separator = separator and separator or '%s'
    local matches={}
    for str in string.gmatch(String, "([^"..separator.."]+)") do
            table.insert(matches, str)
    end
    print (hs.inspect(matches))
    return matches
end

local function getFilteredWindowLayout (windowLayout, windowTitle)
    newWindowLayout = {}
    for index, value in ipairs(windowLayout) do
        if value[1] == windowTitle then
            table.insert(newWindowLayout, value)
        end
    end
    return newWindowLayout
end

function hideAllActiveWindowsExcept(window)
    for index, visibleWindow in ipairs(hs.window.visibleWindows()) do
        if window:id() ~= visibleWindow:id() then
            result = window:application():hide()
            if not result then
                window:application():hide()
            end
        end
    end
end

function hideAllActiveWindows()
    for index, window in ipairs(hs.window.allWindows()) do
        window:application():hide()
    end
end

function showWindowsInAllWindows(AllWindows)
    for index, window in ipairs(AllWindows) do
        window:unminimize()
    end
end

function hideWindowLayout(windowLayout)
    for index, window in ipairs(hs.window.visibleWindows()) do
        window:application():hide()
    end
end

function getAllWindowsAsWindowLayout(window)
    newWindowLayout = {}
    for index, window in ipairs(hs.window.visibleWindows()) do
        table.insert(newWindowLayout, { window:application(), window, window:screen(), nil, window:frame(), nil })
    end
    return newWindowLayout
end

function countTable(table)
    count = 0
    for k,v in pairs(table) do
         count = count + 1
    end
    return count
end

function arrangeWindows(windowTitle)
    -- https://www.hammerspoon.org/docs/hs.layout.html


    local windowLayout = {}
    local left = hs.layout.left50;
    local right = hs.layout.right50;
    local lowerRight = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 })
    local upperRight = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.5, h = 0.5 })
    local upperRightLeft = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.25, h = 0.5 })
    local upperRightRight = hs.geometry.unitrect({ x = 0.75, y = 0, w = 0.25, h = 0.5 })
    local lowerRightRight = hs.geometry.unitrect({ x = 0.75, y = 0.5, w = 0.25, h = 0.5 })
    local lowerLeftRight = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.25, h = 0.5 })

    local rightLeft = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.25, h = 1 })

    local allScreens = hs.screen.allScreens()
    local screenCount = countTable(hs.screen.allScreens())

    local monitor1 = allScreens[1]:name()
    carlLogger.df(monitor1)


    if screenCount == 1 and (monitor1  == "Color LCD") then
        -- maximized window hs.geometry.unitrect({x=1, y=1, w=1, h=1}).
        windowLayout = {
            { "Google Chrome", nil, monitor1, right, nil, nil },
            { "PyCharm", nil, monitor1, left, nil, nil },
            { "WebStorm", nil, monitor1, left, nil, nil },
            { "Mail", nil, monitor1, upperRight, nil, nil },
            { "Microsoft Teams", nil, monitor1, right, nil, nil },
            { "Slack", nil, monitor1, right, nil, nil },
            { "Spotify", nil, monitor1, right, nil, nil },
            { "Todoist", nil, monitor1, right, nil, nil },
            { "Iterm2", nil, monitor1, right, nil, nil },
            { "Plex", nil, monitor1, upperRight, nil, nil },
        }
    elseif screenCount == 1 and (monitor1  == "PHL BDM4037U" or monitor1  == "ASUS PB287Q") then
        monitor1 = allScreens[1]:name()
        -- maximized window hs.geometry.unitrect({x=1, y=1, w=1, h=1}).
        windowLayout = {
            { "Google Chrome", nil, monitor1, rightLeft, nil, nil },
            { "Chromium", nil, monitor1, lowerLeftRight, nil, nil },
            { "Firefox", nil, monitor1, rightLeft, nil, nil },
            { "Safari", nil, monitor1, rightLeft, nil, nil },
            { "PyCharm", nil, monitor1, left, nil, nil },
            { "WebStorm", nil, monitor1, left, nil, nil },
            { "PyCharm", "Commit Changes", monitor1, right, nil, nil },
            { "Sublime Text", nil, monitor1, upperRightRight, nil },
            { "Typora", nil, monitor1, upperRightRight, nil },
            { "Wiki", nil, monitor1, upperRightRight, nil },
            { "Code", nil, monitor1, lowerRightRight, nil, nil },
            { "Mail", nil, monitor1, upperRightRight, nil, nil },
            { "Microsoft Teams", nil, monitor1, upperRightRight, nil, nil },
            { "Calendar", nil, monitor1, upperRightRight, nil, nil },
            { "Messenger", nil, monitor1, upperRightRight, nil, nil },
            { "Skype for Business", nil, monitor1, upperRightRight, nil, nil },
            { "MacPass" , nil, monitor1, upperRightRight, nil, nil },
            { "Slack", nil, monitor1, upperRightRight, nil, nil },
            { "Messenger", nil, monitor1, upperRightRight, nil, nil },
            { "Todoist", nil, monitor1, lowerRightRight, nil, nil },
            { "Iterm2", nil, monitor1, upperRightRight, nil, nil },
            { "Calculator", nil, monitor1, lowerRight, nil, nil },
            { "Activity Monitor", nil, monitor1, upperRightRight, nil, nil },
            { "Hammerspoon", nil, monitor1, upperRightRight, nil, nil },
            { "Spotify", nil, monitor1, lowerRightRight, nil, nil },
        }
    else
        monitor2 = allScreens[2]:name()
        -- maximized window hs.geometry.unitrect({x=1, y=1, w=1, h=1}).
        windowLayout = {
            { "Google Chrome", nil, monitor2, left, nil, nil },
            { "Firefox", nil, monitor2, left, nil, nil },
            { "PyCharm", nil, monitor1, left, nil, nil },
            { "PyCharm", "Commit Changes", monitor1, right, nil, nil },
            { "WebStorm", nil, monitor1, left, nil, nil },
            { "Sublime Text", nil, monitor1, upperRight, nil, nil },
            { "Mail", nil, monitor2, upperRight, nil, nil },
            { "Microsoft Teams", nil, monitor2, upperRight, nil, nil },
            { "Skype for Business", nil, monitor2, upperRight, nil, nil },
            { "Franz", nil, monitor2, upperRight, nil, nil },
            { "Slack", nil, monitor2, upperRight, nil, nil },
            { "Spotify", nil, monitor2, lowerRight, nil, nil },
            { "Todoist", nil, monitor2, lowerRight, nil, nil },
            { "iTerm2", nil, monitor1, lowerRight, nil, nil },
            { "Calculator", nil, monitor1, lowerRight, nil, nil },
        }
    end
    if windowTitle ~= nil then
        windowLayout = getFilteredWindowLayout(windowLayout, windowTitle)
        hs.timer.doAfter(0.2, function()
            hs.layout.apply(windowLayout)
        end)
    else
        hs.layout.apply(windowLayout)
    end
end


function findAndKillApplication(identifier)
    local application = hs.application.find(identifier)
    local result = false
    if application then
        application:kill()
        result = true
    end
    return result
end


function work()
    findAndKillApplication('Calculator')
end

hs.hotkey.bind({ "cmd", "alt" }, "t", arrangeWindows)
wifiWatcher = nil
homeSSID = "Fenix"
workSSID = "SmithNet"
lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

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

hs.hotkey.bind({ "cmd" }, "d", function()
    hs.grid.setGrid('4x2')
    hs.grid.setMargins('0x0')
    hs.grid.toggleShow()
end)

isCheatsheetToggled = false

function toggleCheatsheet()
    isCheatsheetToggled = not iunsCheatsheetToggled
end

hs.hotkey.bind({ "cmd", "alt" }, "c", function()
    if isCheatsheetToggled then
        spoon.KSheet:hide()
    else
        spoon.KSheet:show()
    end
    isCheatsheetToggled = not isCheatsheetToggled
end)

function applicationWatcher(appName, eventType, appObject)
    if isDebug then
        file = io.open("/Users/cbackstrom/hammerspoon.log", "a")
        file:write(os.date("!%Y%m%d,%H:%M:%S,") .. appName .. "\n")
        file:flush()
    end
    if (eventType == hs.application.watcher.launched) then
        arrangeWindows(appName)
    end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

toggle = false
storedWindowsLayout = {}
storedAllVisibleWindows = {}

hs.hotkey.bind(nil, "F19", function()
    toggle = not toggle
    carlLogger.df('State of toggle is %s', toggle)
    if toggle then
        storedAllVisibleWindows = hs.window.visibleWindows()
        focusedWindow = hs.window.focusedWindow()
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

udemyWindow = false

hs.hotkey.bind(nil, "F17", function()
    focusedWindow = hs.window.focusedWindow()
    udemyWindow = udemyWindow or hs.window.find('Udemy')
    udemyWindow:application():activate()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.space, true):post()
    focusedWindow:application():activate()
end)

hs.hotkey.bind(nil, "F16", function()
    focusedWindow = hs.window.focusedWindow()
    udemyWindow = udemyWindow or hs.window.find('Udemy')
    udemyWindow:application():activate()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.left, true):post()
    focusedWindow:application():activate()
end)
