Terminal = {
	ip = "",
	port = 0
}

function Terminal:Send(cmd)
	self.udp:send(cmd)
end



return Terminal