local iup = require "iuplua"

local label = iup.label { title = "Hello world from IUP." }
local button = iup.button { title = "OK" }
local vbox = iup.vbox { label, button }
local dlg = iup.dialog {
  vbox,
  title = "Hello World 4",
}

-- Registers callbacks
function button:action()
  return iup.CLOSE
end

iup.ShowXY(dlg, iup.CENTER, iup.CENTER)
iup.MainLoop()
iup.Close()
