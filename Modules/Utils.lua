Utils = {}

Utils.colorPrint = {
    ["Info"] = "#00fc4c",
    ["Terminal"] = "#45e9f5",
    ["Error"] = "#fc0000",
    ["Packet"] = "#45e9f5",
    ["Dialog"] = "#fc9905",
    ["Monsters"] = "#fc0599",
    ["Zone"] = "#fccf05",
    ["Area"] = "#fccf05",
    ["SubArea"] = "#fccf05",
    ["Dungeons"] = "#dffc05",
    ["Notification"] = "#0b0429",
    ["Json"] = "#077869",
    ["Movement"] = "#00fc4c",
    ["API"] = "#00fc4c",
    ["Craft"] = "#fc972b",
    ["Group"] = "#4571f5",
    ["Memory"] = "#9b74ed",
    ["Controller"] = "#f2fa07"
}

function Utils:Print(msg, header, color)
    local prefabStr = ""

    if color == nil then
        color = self:ColorPicker(header)
    end

    msg = tostring(msg)

    if header ~= nil then
        prefabStr = "["..string.upper(header).."] "..msg
    else
        prefabStr = msg
    end

    if color == nil then
        global:printMessage(prefabStr)
    else
        global:printColor(prefabStr, color)
    end

end

function Utils:ColorPicker(header)
    if header ~= nil then
        for k, v in pairs(self.colorPrint) do
            if string.lower(k) == string.lower(header) then
                return v
            end
        end
    end
    return nil
end

return Utils