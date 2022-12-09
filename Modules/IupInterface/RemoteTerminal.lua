local clientIp, clientPort = "127.0.0.1", 37
local serverPort = 36
local directory = [[D:\DofusBotting\TouchyBot\YayaTools_TouchyEdition]]

package.cpath = package.cpath .. ";" .. directory .. [[\RocksModules\dll\?.dll]]
package.path = package.path .. ";" .. directory .. [[\RocksModules\?.lua]]
require ("iuplua")

local iup = iup
local socket = require "socket"
local udp = socket.udp()
local data, msg_or_ip, port_or_nil

udp:settimeout(0.001)
udp:setsockname(clientIp, serverPort)
udp:setpeername(clientIp, clientPort)
Console = {}

Console.udp = udp

Console.prompt = iup.text {
    expand="Horizontal",
    dragdrop = "Yes"
}

Console.output = iup.text {
    expand="Yes",
    readonly="Yes",
    bgcolor="232 232 232",
    font = "Courier, 11",
    appendnewline = "No",
    multiline = "Yes",
    fgcolor = "2 90 10"
}

Console.loop = iup.timer{time = 10, run = "NO"}	-- run timer with every 10ms action

Console.prompt.tip =
"Enter - send command to ur script connected\n"..
"Esc - clears the command\n"..
"Ctrl+Del - clears the output\n"..
"Ctrl+O - selects a file and execute it\n"..
"Ctrl+X - exits the Console\n"..
"Up Arrow - shows the previous command in history\n"..
"Down Arrow - shows the next command in history"

Console.orig_output = io.output
Console.orig_write = io.write
Console.orig_print = print

-- Listenning

function Console.loop:action_cb()
    data, msg_or_ip, port_or_nil = Console.udp:receive()
    if data then
        print("Received :", data, msg_or_ip, port_or_nil)
    end
    self.run = "YES" -- Restart Loop
end

function io.output(filename)
  Console.orig_output(filename)
  if (filename) then
    io.write = Console.orig_write
  else
    io.write = Console.new_write
  end
end

function Console.new_write(...)
  -- Try to simulate the same behavior of the standard io.write
  local arg = {...}
  local str -- allow to print a nil value
  for i,v in ipairs(arg) do
    if (str) then
      str = str .. tostring(v)
    else
      str = tostring(v)
    end
  end
  Console.print2output(str, true)
end

io.write = Console.new_write

function print(...)
  -- Try to simulate the same behavior of the standard print
  local arg = {...}
  local str -- allow to print a nil value
  for i,v in ipairs(arg) do
    if (i > 1) then
      str = str .. "\t"  -- only add Tab for more than 1 parameters
    end
    if (str) then
      str = str .. tostring(v)
    else
      str = tostring(v)
    end
  end
  Console.print2output(str)
end

function Console.print2output(s, no_newline)
  if (no_newline) then
    Console.output.append = tostring(s)
    Console.no_newline = no_newline
  else
    if (Console.no_newline) then
      -- if io.write was called, then a print is called, must add a new line before
      Console.output.append = "\n" .. tostring(s) .. "\n"
      Console.no_newline = nil
    else  
      Console.output.append = tostring(s) .. "\n"
    end
  end
end

function Console.print_command(cmd)
  Console.add_command(cmd)
  Console.print2output("> " .. cmd)
end

function  Console.add_command(cmd)
  Console.cmd_index = nil
  if (not Console.cmd_list) then
    Console.cmd_list = {}
  end
  local n = #(Console.cmd_list)
  Console.cmd_list[n+1] = cmd
end

function  Console.prev_command()
  if (not Console.cmd_list) then
    return
  end
  if (not Console.cmd_index) then
    Console.cmd_index = #(Console.cmd_list)
  else
    Console.cmd_index = Console.cmd_index - 1
    if (Console.cmd_index == 0) then
      Console.cmd_index = 1
    end
  end
  Console.prompt.value = Console.cmd_list[Console.cmd_index]
end

function  Console.next_command()
  if (not Console.cmd_list) then
    return
  end
  if (not Console.cmd_index) then
    return
  else
    Console.cmd_index = Console.cmd_index + 1
    local n = #(Console.cmd_list)
    if (Console.cmd_index == n+1) then
      Console.cmd_index = n
    end
  end
  Console.prompt.value = Console.cmd_list[Console.cmd_index]
end

function Console.do_string(cmd)
  Console.print_command(cmd)
  --assert(loadstring(cmd))()
end

function Console.prompt:k_any(key)
  if (key == iup.K_CR) then  -- Enter executes the string
    Console.do_string("Sended: " .. self.value .. " | IP: " .. clientIp .. " Port: " .. clientPort)
    Console.udp:send(self.value)
    self.value = ""
  end
  if (key == iup.K_ESC) then  -- Esc clears Console.prompt
    self.value = ""
  end
  if (key == iup.K_cX) then  -- Ctrl+X exits the Console
    Console.dialog:close_cb()
  end
  if (key == iup.K_cDEL) then  -- Ctrl+Del clears Console.output
    Console.output.value = ""
  end
  if (key == iup.K_UP) then  -- Up Arrow - shows the previous command in history
    Console.prev_command()
  end
  if (key == iup.K_DOWN) then  -- Down Arrow - shows the next command in history
    Console.next_command()
  end
end

Console.dialog = iup.dialog {
    iup.vbox {
        iup.frame {
            iup.hbox { -- use it to inherit margins
                Console.prompt,
            },
            title = "Command:",
        },
        iup.frame {
            iup.hbox { -- use it to inherit margins
            Console.output
        },
        title = "Output:",
        },
        margin = "5x5",
        gap = "5",
    },
    title="Yaya Terminal V1.0",
    size="350x250", -- initial size
    icon=0, -- use the Lua icon from the executable in Windows
}

function Console.dialog:close_cb()
  print = Console.orig_print  -- restore print and io.write
  io.write = Console.orig_write
  iup.ExitLoop()  -- should be removed if used inside a bigger application
  Console.dialog:destroy()
  return iup.IGNORE
end

function Console.version_info()
  print(_VERSION) -- _COPYRIGHT does not exists by default, but it could...

  print("IUP " .. iup._VERSION .. "  " .. iup._COPYRIGHT)
  print("System: " .. iup.GetGlobal("SYSTEM"))
  print("System Version: " .. iup.GetGlobal("SYSTEMVERSION"))

  local mot = iup.GetGlobal("MOTIFVERSION")
  if (mot) then print("  Motif Version: ", mot) end

  local gtk = iup.GetGlobal("GTKVERSION")
  if (gtk) then print("GTK Version: ", gtk) end
  print("TouchyTerminal by Yaya Version: 1.0")
end

Console.dialog:show()
Console.dialog.size = nil -- reset initial size, allow resize to smaller values
iup.SetFocus(Console.prompt)

Console.version_info()

Console.loop.run = "YES"
if (iup.MainLoopLevel() == 0) then
  iup.MainLoop()
end