--- === HomeAssistantMenu===
---
--- Adds a menu bar with temperature as text icon and all switches and lights as items.
---
--- Download:

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "HomeAssistantMenu"
obj.version = "0.1"
obj.author = "Carl Bäckström <jonlorusso@gmail.com>"
obj.homepage = ""
obj.license = "MIT - https://opensource.org/licenses/MIT"


--- HomeAssistantMenu.uri
--- Variable
--- String with a HomeAssistant uri
obj.uri = 'https://changeme.hassio.org:8123'

--- HomeAssistantMenu.token
--- Variable
--- String with a HomeAssistant access token
obj.token = 'token'

--- HomeAssistantMenu.temperature_sensor
--- Variable
--- String with a HomeAssistant entity_id I.E. sensor.outside
obj.temperature_sensor = 'sensor.changeme'

obj.logger = hs.logger.new('HomeAssistantMenu')

--- HomeAssistantMenu:toggleLight()
--- Method
--- Toggle a light in HomeAssistant
---
--- Parameters:
---  * entityId: A HomeAssistant entity_id I.E. light.bathroom
function obj:toggleLight(entityId)
    local data = {}
    data["entity_id"] = entityId
    hs.http.asyncPost(self.uri .. '/api/services/light/toggle', hs.json.encode(data), headers, function() end)
end


function obj:filterEntities(entityId)
    local data = {}
    data["entity_id"] = entityId
    hs.http.asyncPost(self.uri .. '/api/services/light/toggle', hs.json.encode(data), headers, function() end)
end

function obj:refresh()
    local headers = {}
    headers['Authorization'] = 'Bearer ' .. self.token
    headers['Content-Type'] = 'application/json'

    hs.http.asyncGet(self.uri .. '/api/states/'.. self.temperature_sensor, headers, function(status, body, responseHeaders)
        self.logger.df('Status of the GET request: %s', status)
        local decoded_body = hs.json.decode(body)
        HomeAssistantMenu:setTitle(decoded_body['state'])
    end)

    hs.http.asyncGet(self.uri ..'/api/states', headers, function(status, body, responseHeaders)
        local decoded_body = hs.json.decode(body)

        local menuTable = {}
        for _, entity in ipairs(decoded_body) do
            if string.starts(entity['entity_id'], 'light.') then
                table.insert(menuTable, { title = entity['entity_id'], fn = function(_, item) self:toggleLight(item.title) end })
            end
        end
        HomeAssistantMenu:setMenu(menuTable)

    end)

end

--- HomeAssistantMenu:start()
--- Method
--- Start HomeAssistantMenu
---
--- Parameters:
---  * None
function obj:start()
    HomeAssistantMenu = hs.menubar.new()
    -- https://www.lua.org/pil/20.html
    self.logger.f('token: %s, uri: %s, temperature_sensor: %s',
                  self.token, self.uri, self.temperature_sensor)
    self:refresh()
    hs.timer.doEvery(60, self.refresh)
    return self
end

return obj
