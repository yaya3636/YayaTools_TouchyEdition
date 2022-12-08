Tools = require("YayaTools_TouchyEdition.Modules.Tools")()

function move()
	local lst = Tools.list()
	lst:pushl("a")
	lst:pushl("21")
	lst:pushl("874")
	lst:pushl("4")
	lst:pushl("a")
	lst:pushl("dg")

	global:printMessage(Tools.dump(lst:range(2, 4)))
	local timer1 = Tools.timer({ timeToWait = 0 })
	local timer2 = Tools.timer({ timeToWait = 1 })
	global:printMessage(timer1:IsFinish())
	global:printMessage(timer2:IsFinish())
	global:delay(1000 * 60)
	global:printMessage(timer2:IsFinish())

end