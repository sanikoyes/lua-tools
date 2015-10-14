local iup = require "iuplua"

local button = iup.button { title = "OK" }
local vbox = iup.vbox { button }
local dlg = iup.dialog {
  vbox,
  title = "Hello World 3",
}

-- Registers callbacks
function button:action()
  iup.Message("Hello World Message", "Hello world from IUP.")
  return iup.CLOSE
end

iup.ShowXY(dlg, iup.CENTER, iup.CENTER)
iup.MainLoop()
iup.Close()
