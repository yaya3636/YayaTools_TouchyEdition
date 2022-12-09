local directory = string.sub(package.cpath, 1, string.find(package.cpath, ";") - 6) .. [[YayaTools_TouchyEdition\RocksModules\dll\?.dll]]
package.cpath = package.cpath .. ";" .. directory

Tools = require("YayaTools_TouchyEdition.Modules.Tools")()
Terminal = Tools.terminal({ serverPort = 36, clientPort = 37 })

Terminal:Send("essayer la commande ( printTouchy Hello from Yaya Terminal ) depuis le terminal")
function move()
    while true do
		global:delay(1000)
		local data, msg = Terminal.udp:receive()
		if data then
			local cmd = string.sub(data, 1, (string.find(data, " ") or 1) - 1)
			local cmdValue = string.sub(data, string.find(data, " ") + 1, #data)
			if cmd == "printTerminal" then
				Terminal:Send(cmdValue)
			elseif cmd == "printTouchy" then
				global:printMessage(cmdValue)
			end
		end
	end
end