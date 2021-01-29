local secrets = require 'secrets'
local webserver = require 'webserver'
local inspect = require('inspect')
require('hs.ipc')
require('url_shortener')
local utils = require('utils')

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

local carlLogger = hs.logger.new('carlLogger')
local isDebug = true

local layouts = {}
layouts.left = hs.layout.left50;
layouts.right = hs.layout.right50;
layouts.lowerRight = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 })
layouts.upperRight = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.5, h = 0.5 })
layouts.upperRightLeft = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.25, h = 0.5 })
layouts.upperRightRight = hs.geometry.unitrect({ x = 0.75, y = 0, w = 0.25, h = 0.5 })
layouts.lowerRightRight = hs.geometry.unitrect({ x = 0.75, y = 0.5, w = 0.25, h = 0.5 })
layouts.lowerLeftRight = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.25, h = 0.5 })
layouts.rightLeft = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.25, h = 1 })
layouts.leftLeft = hs.geometry.unitrect({ x = 0, y = 0, w = 0.25, h = 1 })

layouts.q = hs.geometry.unitrect({ x = 0, y = 0, w = 0.25, h = 0.5 })
layouts.a = hs.geometry.unitrect({ x = 0, y = 0.5, w = 0.25, h = 0.5 })
layouts.d = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.25, h = 0.5 })
layouts.f = hs.geometry.unitrect({ x = 0.75, y = 0.5, w = 0.25, h = 0.5 })
layouts.qw = hs.geometry.unitrect({ x = 0, y = 0, w = 0.5, h = 0.5 })
layouts.as = hs.geometry.unitrect({ x = 0, y = 0.5, w = 0.5, h = 0.5 })
layouts.sd = hs.geometry.unitrect({ x = 0.25, y = 0.5, w = 0.5, h = 0.5 })
layouts.df = hs.geometry.unitrect({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 })
layouts.er = hs.geometry.unitrect({ x = 0.5, y = 0, w = 0.5, h = 0.5 })
layouts.qwas = hs.layout.left50;
layouts.erdf = hs.layout.right50;

local function udemyPreset()
    local windowLayout = {
        { "Code", nil, monitor1, layouts.qw  , nil, nil },
        { "Typora", nil, monitor1, layouts.a , nil, nil },
        { "Udemy", nil, monitor1, layouts.er , nil, nil },
        { "Chromium", nil, monitor1, layouts.sd , nil, nil },
        { "Google Chrome", nil, monitor1, layouts.f, nil, nil }
    }
    hs.layout.apply(windowLayout)
end

local function workPreset()
    local windowLayout = {
        { "Code", nil, monitor1, layouts.qw  , nil, nil },
        { "Typora", nil, monitor1, layouts.a , nil, nil },
        { "Chromium", nil, monitor1, layouts.er , nil, nil },
        { "Google Chrome", nil, monitor1, layouts.df, nil, nil }
    }
    hs.layout.apply(windowLayout)
end

hs.ipc.cliInstall('/usr/local/bin')

hs.window.animationDuration = 0 -- disable animations
-- https://www.hammerspoon.org/docs/hs.logger.html#level
-- Higher is more verbose
hs.logger.setGlobalLogLevel(5)

local function log(message)
    local file = io.open("/Users/cbackstrom/hammerspoon.log", "a")
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
    return matches
end

local function arrangeWindows(windowTitle)
    -- https://www.hammerspoon.org/docs/hs.layout.html


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


local isCheatsheetToggled = false

local function toggleCheatsheet()
    isCheatsheetToggled = not isCheatsheetToggled
end

hs.hotkey.bind({ "cmd", "alt" }, "c", function()
    if isCheatsheetToggled then
        spoon.KSheet:hide()
    else
        spoon.KSheet:show()
    end
    isCheatsheetToggled = not isCheatsheetToggled
end)

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

function toggleTypora()
    local focusedWindow = hs.window.focusedWindow()
    if utils.getFocusedWindowTitle() == '.scratch.md' and focusedWindow:application():name() == 'Typora' then
        focusedWindow:application():hide()
    else
        hs.execute('open -a "Typora" "$HOME/gdrive/wiki/.scratch.md"')
        hs.application.launchOrFocus('Typora')
        local typora = hs.application.find('Typora')
        typora:unhide()
        typora:mainWindow():unminimize()
        typora:mainWindow():focus()
    end
end

hs.hotkey.bind(nil, "F19", toggleTypora)

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "t", arrangeWindows)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "s", toggleTypora)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "1", udemyPreset)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "2", workPreset)

hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "d", function()
    hs.grid.setGrid('4x2')
    hs.grid.setMargins('0x0')
    hs.grid.toggleShow()
end)

hs.hotkey.bind({ "cmd", "alt" }, "t", arrangeWindows)

local udemyWindow = false
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "r", function()
    local focusedWindow = hs.window.focusedWindow()
    udemyWindow = udemyWindow or hs.application.find('Udemy'):focusedWindow()
    udemyWindow = udemyWindow or hs.application.find('Google Chrome'):findWindow('Udemy')
    udemyWindow:application():activate()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.space, true):post()
    focusedWindow:application():activate()
end)
