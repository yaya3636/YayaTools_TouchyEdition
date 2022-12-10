local directory = string.sub(package.cpath, 1, string.find(package.cpath, ";") - 6)
package.cpath = package.cpath .. ";" .. directory .. [[YayaTools_TouchyEdition\RocksModules\dll\?.dll]]

local rocksModuleDirectory <const> = "YayaTools_TouchyEdition.RocksModules."
local moduleDirectory <const> = "YayaTools_TouchyEdition.Modules."

local class = require(rocksModuleDirectory .. "30log")
local tools = class("Tools")

tools.dump = require(rocksModuleDirectory .. "dump")
tools.list = class("List", require(moduleDirectory .. "List"))
tools.timer = class("Timer", require(moduleDirectory .. "Timer"))
tools.terminal = class("Terminal", require(moduleDirectory .. "RemoteTerminal"))
tools.dictionnary = class("Dictionnary", require(moduleDirectory .. "Dictionnary"))
tools.utils = require(moduleDirectory .. "Utils")

function tools.dictionnary:init(dic)
    local tmp = {}
    if dic ~= nil then
        if dic.c then
            if dic.a then
                for _, v in pairs(dic.a) do
                    table.insert(tmp, v)
                end
            end

            if dic.dic then
                for k, v in pairs(dic.dic) do
                    tmp[k] = v
                end
            end
        else
            for k, v in pairs(dic) do
                tmp[k] = v
            end
        end
    end

    self.dic = tmp
    self.N = #self.dic
end

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

function tools.terminal:init(params)
    self.utils = tools.utils
    self.ip = "127.0.0.1"
    self.serverPort = params.serverPort
    self.clientPort = params.clientPort

    self.socket = require(rocksModuleDirectory .. "socket")
    self.udp = self.socket.udp()
    self.udp:settimeout(0.001)
    self.udp:setsockname(self.ip, self.clientPort)
    self.udp:setpeername(self.ip, self.serverPort)
    local ip, port = self.udp:getsockname()

    self.clientIp = ip
    local f = io.open(directory .. [[YayaTools_TouchyEdition\Modules\iupInterface\RemoteTerminal.lua]], "r")

    local lines = {}
    if f then
        for line in f:lines() do
            --global:printMessage(line)
            table.insert(lines, line)
        end
        f:close()
    end

    lines[1] = "local clientIp, clientPort = " .. [["]] .. self.clientIp .. [["]] .. ", " .. self.clientPort
    lines[2] = "local serverPort = " .. self.serverPort
    lines[3] = "local directory = [[" .. directory .. "YayaTools_TouchyEdition" .. "]]"
    local newF = io.open(directory .. [[YayaTools_TouchyEdition\Modules\iupInterface\TmpRemoteTerminal.lua]], "w")

    --global:printMessage(tools.dump(lines))

    if newF then
        for i, line in ipairs(lines) do
            local l = line
            --global:printMessage(l)
            if i ~= #lines then
                l = line .. "\n"
            end
            newF:write(l)
        end
        newF:close()
    end

    os.remove(directory .. [[YayaTools_TouchyEdition\Modules\iupInterface\RemoteTerminal.lua]])
    os.rename(directory .. [[YayaTools_TouchyEdition\Modules\iupInterface\TmpRemoteTerminal.lua]], directory .. [[YayaTools_TouchyEdition\Modules\iupInterface\RemoteTerminal.lua]])
    --global:printMessage(tools.dump(lines))

    io.popen("start " .. directory .. [[YayaTools_TouchyEdition\RocksModules\dll\iupLua\wLua54.exe ]]
    .. directory .. [[YayaTools_TouchyEdition\Modules\iupInterface\RemoteTerminal.lua"]]
    )
    global:delay(1000)

    self.udp:send("Connected !")
end

return tools