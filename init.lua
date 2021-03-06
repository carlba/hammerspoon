local secrets = require 'secrets'
require('url_shortener')
local utils = require('utils')

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:updateRepo('default')
spoon.SpoonInstall:andUse('ReloadConfiguration')
spoon.ReloadConfiguration:start()

hs.loadSpoon('HomeAssistantMenu')
spoon.HomeAssistantMenu.uri = secrets.homeAssistant.uri
spoon.HomeAssistantMenu.token = secrets.homeAssistant.token
spoon.HomeAssistantMenu.temperature_sensor = secrets.homeAssistant.temperature_sensor
-- spoon.HomeAssistantMenu:start()

local logger = hs.logger.new('main')
local isDebug = true

hs.grid.setGrid('8x2')
hs.grid.setMargins('0x0')

table.filter = utils.table.filter
table.map = utils.table.map

local function getLayOuts()
    local layouts = {}
    local monitor1 = hs.screen.allScreens()[1]
    layouts.qwer = hs.grid.getCell('0,0 4x1', monitor1)
    layouts.ty = hs.grid.getCell('4,0 2x1', monitor1)
    layouts.tyu = hs.grid.getCell('4,0 3x1', monitor1)
    layouts.tyui = hs.grid.getCell('4,0 4x1', monitor1)
    layouts.ui = hs.grid.getCell('6,0 2x1', monitor1)
    layouts.as = hs.grid.getCell('0,1 2x1', monitor1)
    layouts.dfg = hs.grid.getCell('2,1 3x1', monitor1)
    layouts.hjk = hs.grid.getCell('5,1 3x1', monitor1)
    return layouts
end

local managedApps = {'Code', 'Typora', 'Udemy', 'Chromium', 'Google Chrome', 'eDN', 'Finder'}

local function hideManagedWindows(exclusions)
    local filteredApps = table.filter(managedApps, function(o, k, i) return not utils.findInTable(exclusions, o) end)
    logger.df('filtered', hs.inspect(filteredApps))

    for _, app in pairs(filteredApps) do
        logger.df(app);
        local foundApp = hs.application.find(app)
        if foundApp then
            foundApp:hide()
        end
    end
end

local function udemyPreset()
    local windowLayout = {
        { "Code", nil, nil, nil, nil, layouts.qwer },
        { "Typora", nil, monitor1, nil, nil, layouts.as},
        { "Udemy", nil, monitor1, nil , nil, layouts.tyui},
        { "Chromium", nil, nil, nil, nil, layouts.dfg },
        { "Google Chrome", nil, monitor1, nil, nil, layouts.hjk },
        { "SmartGit", nil, monitor1, nil, nil, layouts.hjk }
    }
    local windows = utils.table.map(windowLayout, function(value) return value[1] end);
    hideManagedWindows(windows)
    utils.unhideWindows(windows)
    hs.application.open('Udemy',2, true);

    hs.layout.apply(windowLayout)
end

local function workPreset()
    local windowLayout = {
        { "Code", nil, nil, nil, nil, layouts.qwer },
        { "Typora", nil, nil, nil, nil, layouts.as },
        { "Chromium", nil, nil, nil, nil, layouts.dfg },
        { "Google Chrome", nil, nil ,nil, nil, layouts.ty }
    }
    local windows = table.map(windowLayout, function(value) return value[1] end);
    hideManagedWindows(windows)
    utils.unhideWindows(windows)
    hs.layout.apply(windowLayout)
end

local function relaxPreset()
    hideManagedWindows()
    utils.unhideWindows({'Google Chrome'})
    local windowLayout = {
        { "Google Chrome", nil, monitor1, layouts.wesd, nil, nil }
    }
    hs.layout.apply(windowLayout)
end

local function dnPreset()
    local app = hs.application.find('eDN');
    if (app and utils.applicationHasVisibleWindows(app)) then
        app:hide();
    else
        hs.application.open('eDN',2, true);
        hs.eventtap.keyStroke({"ctrl", "cmd"}, "f")
    end
end

hs.window.animationDuration = 0 -- disable animations
-- https://www.hammerspoon.org/docs/hs.logger.html#level
-- Higher is more verbose
hs.logger.setGlobalLogLevel(5)

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

local function typoraToggle()
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

local function typoraSearch()
    hs.application.launchOrFocus('Typora')
    local typora = hs.application.find('Typora')
    typora:unhide()
    typora:mainWindow():unminimize()
    typora:mainWindow():focus()
    hs.eventtap.keyStroke({"ctrl", "cmd"}, "1", 0)
    hs.timer.doAfter(0.1, function() hs.eventtap.keyStroke({"shift", "command"},"f") end)
end



-- Disabled for now will reenable later
-- local appWatcher = hs.application.watcher.new(applicationWatcher)
-- appWatcher:start()

hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "t", arrangeWindows)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "s", typoraToggle)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "1", udemyPreset)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "2", workPreset)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "3", dnPreset)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "4", relaxPreset)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "f", typoraSearch)

hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "d", function()
    hs.grid.toggleShow()
end)

hs.hotkey.bind({ "cmd", "alt" }, "t", arrangeWindows)

hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "r", function()
    local focusedWindow = hs.window.focusedWindow()
    local udemyWindow = hs.application.find('Udemy'):focusedWindow()
    udemyWindow = udemyWindow or hs.application.find('Google Chrome'):findWindow('Udemy')
    udemyWindow:application():activate()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.space, true):post()
    focusedWindow:application():activate()
end)

layouts = getLayOuts();
  
