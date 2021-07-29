local secrets = require 'secrets'
require('url_shortener')
local utils = require('utils')

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:updateRepo('default')
spoon.SpoonInstall:andUse('ReloadConfiguration')
spoon.ReloadConfiguration:start()

-- hs.loadSpoon('HomeAssistantMenu')
-- spoon.HomeAssistantMenu.uri = secrets.homeAssistant.uri
-- spoon.HomeAssistantMenu.token = secrets.homeAssistant.token
-- spoon.HomeAssistantMenu.temperature_sensor = secrets.homeAssistant.temperature_sensor
-- spoon.HomeAssistantMenu:start()

hs.application.enableSpotlightForNameSearches(true);

local logger = hs.logger.new('main')
local isDebug = true

table.filter = utils.table.filter
table.map = utils.table.map

local function getLayouts()
    hs.grid.setGrid('6x2')
    hs.grid.setMargins('0x0')
    local layouts = {}
    local monitor1 = hs.screen.allScreens()[1]
    layouts.qwas = hs.grid.getCell('0,0 2x2', monitor1)
    layouts.erdf = hs.grid.getCell('2,0 2x2', monitor1)
    layouts.er = hs.grid.getCell('2,0 2x0', monitor1)
    layouts.df = hs.grid.getCell('2,2 2x0', monitor1)
    layouts.gh = hs.grid.getCell('4,2 2x0', monitor1)
    layouts.ty = hs.grid.getCell('4,0 2x0', monitor1)
    return layouts
end

local function udemyPreset()
    local monitor1 = hs.screen.allScreens()[1]:currentMode()
    local layouts = getLayouts();

    local windowLayout
    if monitor1['w'] == 2560 and monitor1['h'] == 1600 then
        windowLayout = {
            { "Code", nil, nil, nil, nil, layouts.qwer },
            { "Code - Insiders", nil, nil, nil, nil, layouts.qwerasdf},
            { "Typora", nil, monitor1, nil, nil, layouts.as},
            { "Udemy", nil, monitor1, nil , nil, layouts.tyui},
            { "Chromium", nil, nil, nil, nil, layouts.dfg },
            { "Google Chrome", nil, monitor1, nil, nil,  layouts.tyuighjk},
            { "SmartGit", nil, monitor1, nil, nil, layouts.hjk }
        }
    else
        windowLayout = {
            { "Code", nil, nil, nil, nil, layouts.qwer },
            { "Code - Insiders", nil, nil, nil, nil, layouts.qwerasdf},
            { "Typora", nil, monitor1, nil, nil, layouts.as},
            { "Udemy", nil, monitor1, nil , nil, layouts.tyui},
            { "Chromium", nil, nil, nil, nil, layouts.dfg },
            { "Google Chrome", nil, monitor1, nil, nil, layouts.hjk },
            { "SmartGit", nil, monitor1, nil, nil, layouts.hjk },
            { "Todoist", nil, nil, nil, nil, layouts.gh },
        }
        hs.alert.show('udemy')
    end
    utils.hideWindowsInLayout(windowLayout)
    hs.application.open('Udemy',2, true);
    hs.layout.apply(windowLayout)
end

local function workPresetWeb()
    local monitor1 = hs.screen.allScreens()[1]:currentMode()
    local layouts = getLayouts();
    local windowLayout
    if monitor1['w'] == 2560 and monitor1['h'] == 1600 then
        windowLayout = {
            { "Code", nil, nil, nil, nil, layouts.qwas },
            { "Chrome", nil, nil, nil, nil, layouts.erdf }
        }
    else
        windowLayout = {
            { "Code", nil, nil, nil, nil, layouts.qwas },
            { "Google Chrome", nil, nil, nil, nil, layouts.er },
            { "Chromium", nil, nil, nil, nil, layouts.df },
            { "DataGrip", nil, nil ,nil, nil, layouts.gh },
            { "SmartGit", nil, monitor1, nil, nil, layouts.gh },
            { "Typora", nil, nil, nil, nil, layouts.df },
            { "Hammerspoon", nil, nil, nil, nil, layouts.ty },
            { "Messenger", nil, nil, nil, nil, layouts.gh },
            { "Todoist", nil, nil, nil, nil, layouts.gh },
        }
    end
    utils.hideWindowsInLayout(windowLayout)
    local test = hs.layout.apply(windowLayout)

end

local function workPreset()
    local monitor1 = hs.screen.allScreens()[1]:currentMode()
    local layouts = getLayouts();
    local windowLayout
    if monitor1['w'] == 2560 and monitor1['h'] == 1600 then
        windowLayout = {
            { "Code", nil, nil, nil, nil, layouts.qwas },
            { "Chrome", nil, nil, nil, nil, layouts.erdf }
        }
    else
        windowLayout = {
            { "Code", nil, nil, nil, nil, layouts.qwas },
            { "Google Chrome", nil, nil, nil, nil, layouts.erdf },
            { "DataGrip", nil, nil ,nil, nil, layouts.gh },
            { "SmartGit", nil, monitor1, nil, nil, layouts.gh },
            { "Typora", nil, nil, nil, nil, layouts.df },
            { "Hammerspoon", nil, nil, nil, nil, layouts.ty },
            { "Messenger", nil, nil, nil, nil, layouts.gh },
            { "Todoist", nil, nil, nil, nil, layouts.gh },
        }
    end
    utils.hideWindowsInLayout(windowLayout)
    hs.layout.apply(windowLayout)
end

local function personalPreset()
    local monitor1 = hs.screen.allScreens()[1]:currentMode()
    local layouts = getLayouts();
    local windowLayout
    if monitor1['w'] == 2560 and monitor1['h'] == 1600 then
        windowLayout = {
            { "Code", nil, nil, nil, nil, layouts.qwas },
            { "Chrome", nil, nil, nil, nil, layouts.erdf }
        }
    else
        windowLayout = {
            { "Google Chrome", nil, nil, nil, nil, layouts.erdf },
            { "Typora", nil, nil, nil, nil, layouts.df },
            { "Hammerspoon", nil, nil, nil, nil, layouts.ty },
            { "Todoist", nil, nil, nil, nil, layouts.ty },
        }
    end
    utils.hideWindowsInLayout(windowLayout)
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

hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "s", typoraToggle)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "1", workPresetWeb)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "2", workPreset)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "3", personalPreset)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "4", udemyPreset)
hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "5", dnPreset)
-- hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "f", typoraSearch)

hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "d", function()
    getLayouts()
    hs.grid.toggleShow()
end)

hs.hotkey.bind({ "cmd", "ctrl", "shift", "alt" }, "r", function()
    local focusedWindow = hs.window.focusedWindow()
    local udemyWindow = hs.application.find('Udemy'):focusedWindow()
    udemyWindow = udemyWindow or hs.application.find('Google Chrome'):findWindow('Udemy')
    udemyWindow:application():activate()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.space, true):post()
    focusedWindow:application():activate()
end)
