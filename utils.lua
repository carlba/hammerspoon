local utils = {};
utils.table = {};

function utils.hideAllActiveWindowsExcept(window)
    for index, visibleWindow in ipairs(hs.window.visibleWindows()) do
        if window:id() ~= visibleWindow:id() then
            local result = window:application():hide()
            if not result then
                window:application():hide()
            end
        end
    end
end

function utils.hideAllActiveWindows()
    for index, window in ipairs(hs.window.allWindows()) do
        window:application():hide()
    end
end

function utils.showWindowsInAllWindows(AllWindows)
    for index, window in ipairs(AllWindows) do
        window:unminimize()
    end
end

function utils.hideWindowLayout(windowLayout)
    for index, window in ipairs(hs.window.visibleWindows()) do
        window:application():hide()
    end
end

function utils.getAllWindowsAsWindowLayout(window)
    local newWindowLayout = {}
    for index, window in ipairs(hs.window.visibleWindows()) do
        table.insert(newWindowLayout, { window:application(), window, window:screen(), nil, window:frame(), nil })
    end
    return newWindowLayout
end

function utils.countTable(table)
    local count = 0
    for k,v in pairs(table) do
         count = count + 1
    end
    return count
end

function utils.findAndKillApplication(identifier)
    local application = hs.application.find(identifier)
    local result = false
    if application then
        application:kill()
        result = true
    end
    return result
end

function utils.findAndHideApplication(identifier)
    local application = hs.application.find(identifier)
    local result = false
    if application then
        application:kill()
        result = true
    end
    return result
end

-- taken from https://stackoverflow.com/a/63081277/1839778
function utils.findInTable(t, value)
    local found = false
    for _, v in ipairs (t) do
      if v == value then
        return true
      end
    end
end

function utils.getFilteredWindowLayout (windowLayout, windowTitle)
    local newWindowLayout = {}
    for index, value in ipairs(windowLayout) do
        if value[1] == windowTitle then
            table.insert(newWindowLayout, value)
        end
    end
    return newWindowLayout
end

function utils.getFocusedWindowTitle()
    local focusedWindow = hs.window.focusedWindow()
    if focusedWindow and focusedWindow:title() then
        return focusedWindow:title();
    end
end

function utils.getFocusedWindowApplicationTitle()
    local focusedWindow = hs.window.focusedWindow()
    if focusedWindow then
        return focusedWindow:application():title();
    end
end

function utils.reverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

function utils.log(message)
    local file = io.open("/Users/cbackstrom/hammerspoon.log", "a")
    file:write(os.date("!%Y%m%d,%H:%M:%S,") .. message .. "\n")
    file:flush()
end

function utils.isTableEmpty(tbl)
    if next(tbl) == nil then
        return true
    end
end

function utils.applicationHasVisibleWindows(app)
    return app and not utils.isTableEmpty(app:visibleWindows())
end

function utils.unhideWindows(app)
    for _, app in pairs(app) do
        local foundApp = hs.application.find(app);
        if foundApp and foundApp.unhide then
            foundApp:unhide()
        elseif foundApp then
            foundApp:application():unhide()
        end
    end
end

-- table.filter({"a", "b", "c", "d"}, function(o, k, i) return o >= "c" end)  --> {"c","d"}
--
-- @FGRibreau - Francois-Guillaume Ribreau
-- @Redsmin - A full-feature client for Redis http://redsmin.com
function utils.table.filter(t, filterIter)
    local out = {}
    for k, v in pairs(t) do
      if filterIter(v, k, t) then out[k] = v end
    end
    return out
end

function utils.table.map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

return utils

