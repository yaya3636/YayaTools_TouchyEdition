Tools = require("YayaTools_TouchyEdition.Modules.Tools")()

Terminal = Tools.terminal({ serverPort = 36, clientPort = 37 })

Terminal:Send("essayer la commande ( printTouchy Hello from Yaya Terminal ) depuis le terminal")

Terminal:AddSavedCmd("printTouchy") -- Ctrl+Fleche droite ou bas dans le terminal pour avoir la commande rapide

local x = "x"

Terminal:AddFunc("modifyX", function()
	x = "y"
end)

Terminal:Send("essayer la commande ( execute modifyX ) depuis le terminal pour executer la fonction enregistré")

function move()
    while true do
		global:delay(1000)
		Terminal:ListenSocket()
		Tools.utils:Print(x)
	end
end
