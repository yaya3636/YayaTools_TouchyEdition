Api = {}

Api.dofusTouchMapApiURL = [[https://api.dofus-touch-map.com/api/v1/resources/]]

function Api:GetGatherPosition(gatherId)
	local res =  developer:getRequest(self.dofusTouchMapApiURL .. gatherId)
	return developer:deserialize(developer:getRequest(self.dofusTouchMapApiURL .. gatherId))
end


return Api