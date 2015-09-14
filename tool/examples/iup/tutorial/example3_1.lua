local iup = require "iuplua"

local multitext = iup.text { multiline = "YES", expand = "YES" }
local vbox = iup.vbox { multitext }
local dlg = iup.dialog {
  vbox,
  title = "Simple Notepad", size = "QUARTERxQUARTER",
}

iup.ShowXY(dlg, iup.CENTER, iup.CENTER)
dlg.usersize = nil
iup.MainLoop()
iup.Close()

