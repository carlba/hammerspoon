-- Requires an API Access Token from Bit.ly
local secrets = require 'secrets'
local KUTT_IT_PASSWORD = secrets.kuttIt.password;
local KUTT_IT_TOKEN = secrets.kuttIt.token;

local HEADERS = {};
HEADERS['X-API-KEY'] = KUTT_IT_TOKEN;
HEADERS['Content-Type']= 'application/json';
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "S", function()
	local board = hs.pasteboard.getContents()
	if board:match("^https?://") then
		local response = hs.http.asyncPost(
			"https://kutt.it/api/v2/links",
			hs.json.encode({
				target=board,
				description= "Generated from Hammerspoon",
			}), HEADERS,
			function(status, response, headers)
				if (status == 200 or status == 201) then
					local msg = hs.json.decode(response)
					-- carlLogger.df(msg);

					hs.pasteboard.setContents(msg.link)
					hs.notify.new({title="kutt.it URL Shorten: Success", informativeText=msg.link}):send()
				else
					hs.notify.new({title="kutt.it URL Shorten: Failure", informativeText=response}):send()
				end
			end
		)
	else
		hs.notify.new({title="Bitly URL Shorten: Failure", informativeText="Expected: URL"}):send()
	end
end)
