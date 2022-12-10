Terminal = {
	ip = "",
	port = 0,
	func = {}
}

function Terminal:Send(cmd)
	self.udp:send(cmd)
end

function Terminal:AddSavedCmd(cmd)
	self.utils:Print("Ajout de la commande rapide : " .. cmd, "Terminal")
	self:Send("addsavedcommand " .. cmd)
end

function Terminal:ListenSocket()
	local data, msg = self.udp:receive()
	--self.utils:Print("Start while data")
	while data do
		if data then
			local cmd = string.sub(data, 1, (string.find(data, " ") or 2) - 1)
			local cmdValue = string.sub(data, (string.find(data, " ") or 0 ) + 1, #data)
			if cmd == "printTerminal" then
				self:Send(cmdValue)
			elseif cmd == "printTouchy" then
				self.utils:Print(cmdValue)
			elseif cmd == "execute" then
				if self.func[cmdValue] ~= nil then
					self.utils:Print("Tentative d'exécution de la fonction : (" .. cmdValue .. ")", "Terminal")
					self.func[cmdValue]()
				else
					self.utils:Print("La fonction : (" .. cmdValue .. ") n'a pas été enregistré via Terminal:AddFunc(name, func)", "Terminal")
				end
			end
		end
		global:delay(50)
		data, msg = self.udp:receive()
	end
	--self.utils:Print("End of data")

end

function Terminal:AddFunc(name, func)
	self.utils:Print("Ajout de la fonction : " .. name, "Terminal")
	self.func[name] = func
end

return Terminal