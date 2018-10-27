hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:updateRepo('default')
spoon.SpoonInstall:andUse('ReloadConfiguration')
spoon.SpoonInstall:andUse('KSheet')
spoon.ReloadConfiguration:start()

local function getFilteredWindowLayout (windowLayout, windowTitle)
    newWindowLayout = {}
    for index, value in ipairs(windowLayout) do
        if value[1] == windowTitle then
            table.insert(newWindowLayout, value)
        end
    end
    return newWindowLayout
end


function arrangeWindows(windowTitle)
  local windowLayout = {}
  local lowerRight = hs.geometry.unitrect({x=0.5, y=0.5, w=0.5, h=0.5})
  local upperRight = hs.geometry.unitrect({x=0.5, y=0, w=0.5, h=0.5})
  local upper50RightLeft = hs.geometry.unitrect({x=0.5, y=0, w=0.25, h=0.5})
  local upper50RightRight = hs.geometry.unitrect({x=0.75, y=0, w=0.25, h=0.5})


  if hs.screen.allScreens()[1]:name() == "PHL BDM4037U" then
    monitor1 = hs.screen.allScreens()[1]:name()
    -- maximized window hs.geometry.unitrect({x=1, y=1, w=1, h=1}).
    windowLayout = {
        {"Google Chrome",  nil, monitor1, hs.geometry.unitrect({x=0.5, y=0, w=0.25, h=1}), nil, nil},
        {"Firefox",  nil, monitor1, hs.geometry.unitrect({x=0.5, y=0, w=0.25, h=1}), nil, nil},
        {"PyCharm",  nil, monitor1, hs.layout.left50, nil, nil},
        {"PyCharm",  "Commit Changes", monitor1, hs.layout.right50, nil, nil},
        {"Sublime Text",  nil, monitor1, upper50RightRight, nil},
        {"Mail",  nil, monitor1, upper50RightRight, nil, nil},
        {"Microsoft Teams",  nil, monitor1, upper50RightRight, nil, nil},
        {"Skype for Business",  nil, monitor1, upper50RightRight, nil, nil},
        {"Spotify",  nil, monitor1, lowerRight, nil, nil},
        {"Station",  nil, monitor1, upper50RightRight, nil, nil},
        {"Iterm2",  nil, monitor1, upper50RightRight, nil, nil},
        {"Calculator",  nil, monitor1, lowerRight, nil, nil},
    }
  else
    hs.alert.show("Work")
    monitor1 = hs.screen.allScreens()[1]:name()
    monitor2 = hs.screen.allScreens()[2]:name()
    -- maximized window hs.geometry.unitrect({x=1, y=1, w=1, h=1}).
    windowLayout = {
        {"Google Chrome",  nil, monitor2, hs.layout.left50, nil, nil},
        {"Firefox",  nil, monitor2, hs.layout.left50, nil, nil},
        {"PyCharm",  nil, monitor1, hs.layout.left50, nil, nil},
        {"PyCharm",  "Commit Changes", monitor1, hs.layout.right50, nil, nil},
        {"Sublime Text",  nil, monitor1, upperRight, nil, nil},
        {"Mail",  nil, monitor2, upperRight, nil, nil},
        {"Microsoft Teams",  nil, monitor2, upperRight, nil, nil},
        {"Skype for Business",  nil, monitor2, upperRight, nil, nil},
        {"Spotify",  nil, monitor2, lowerRight, nil, nil},
        {"Station",  nil, monitor2, upperRight, nil, nil},
        {"iTerm2",  nil, monitor1, lowerRight, nil, nil},
        {"Calculator",  nil, monitor1, lowerRight, nil, nil},
    }
  end
  if windowTitle ~= nil then
    windowLayout = getFilteredWindowLayout(windowLayout, windowTitle)
    hs.timer.doAfter(0.2,  function() hs.layout.apply(windowLayout) end)
  else
    hs.layout.apply(windowLayout)
  end
end

hs.hotkey.bind({"cmd", "alt"}, "t", arrangeWindows)
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

hs.hotkey.bind({"cmd"}, "d", function()
  hs.grid.setGrid('4x2')
  hs.grid.setMargins('0x0')
  hs.grid.toggleShow()
end)

isCheatsheetToggled = false

function toggleCheatsheet()
    isCheatsheetToggled = not isCheatsheetToggled
end

hs.hotkey.bind({"cmd", "alt"}, "c", function()
    if isCheatsheetToggled then
        spoon.KSheet:hide()
    else
        spoon.KSheet:show()
    end
    isCheatsheetToggled = not isCheatsheetToggled
end)

function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.launched) then
        arrangeWindows(appName)
    end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
