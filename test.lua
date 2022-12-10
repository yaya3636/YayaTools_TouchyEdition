Tools = require("YayaTools_TouchyEdition.Modules.Tools")()
Api = Tools.api()

-- Terminal = Tools.terminal({ serverPort = 36, clientPort = 37 })

-- Terminal:Send("essayer la commande ( printTouchy Hello from Yaya Terminal ) depuis le terminal")

-- Terminal:AddSavedCmd("printTouchy") -- Ctrl+Fleche droite ou bas dans le terminal pour avoir la commande rapide
-- Terminal:AddSavedCmd("execute modifyX") -- Ctrl+Fleche droite ou bas dans le terminal pour avoir la commande rapide

-- local x = "x"

-- Terminal:AddFunc("modifyX", function()
-- 	x = "y"
-- end)

-- Terminal:Send("essayer la commande ( execute modifyX ) depuis le terminal pour executer la fonction enregistré")

function move()
	Tools.utils:Print(Tools.dump(Api:GetGatherPosition(1)))
end