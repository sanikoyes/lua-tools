local iup = require "iuplua"

local label = iup.label { title = "Hello world from IUP.", padding = "10x20" }
local button = iup.button { title = "OK", padding = "30x2" }
local vbox = iup.vbox {
  label,
  button,
  alignment = "ARIGHT", gap = "10", margin = "10x10",
}
local dlg = iup.dialog {
  vbox,
  title = "Hello World 5a", maxbox = "NO", minbox = "NO",
}

function button:action()
  return iup.CLOSE
end

iup.ShowXY(dlg, iup.CENTER, iup.CENTER)
iup.MainLoop()
iup.Close()
