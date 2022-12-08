local rocksModuleDirectory <const> = "YayaTools_TouchyEdition.RocksModules."
local moduleDirectory <const> = "YayaTools_TouchyEdition.Modules."

local class = require(rocksModuleDirectory .. "30log")
local tools = class("Tools")

tools.dump = require(rocksModuleDirectory .. "dump")
tools.list = class("List", require(moduleDirectory .. "List"))
tools.timer = class("Timer", require(moduleDirectory .. "Timer"))

function tools.timer:init(params)
    params = params or {}
    self.startAt = os.time()
    if params.timeToWait then
        self.timeToWait = params.timeToWait
    elseif params.min and params.max then
        self.timeToWait = math.random(params.min * 60, params.max * 60)
    else
        global:printMessage("Erreur aucun paramètre spécifier n'a été trouvé, { min, max, timeToWait }")
    end
end

return tools