local webserver = {}

webserver.instance = hs.httpserver.new():setPort(8083):setCallback(function(method, path, headers, body)

    local function formatHttpReply(code, message)
        return hs.json.encode({['message'] = message}), 200, { ["Content-Type"] = "application/json" }
    end

    local uriParts = string.split(path, '/')
    print(path)

    print('method:'.. method .. ' path:' .. path .. ' body' .. body)
    print(hs.json.encode(uriParts))

    if uriParts[1] == 'commands' and not uriParts[2] then
        return formatHttpReply(404, 'Command not fosund')
    end

    if uriParts[1] == 'commands' then
        if uriParts[2] == 'typora' then
            toggleTypora()
            return formatHttpReply(200, 'OK')
        end
    end
    return formatHttpReply(404, 'Command not found'.. hs.json.encode(uriParts))
end)

function webserver:start()
    webserver.instance:start();
end

return webserver
