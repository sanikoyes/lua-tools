local iup = require "iuplua"

local label = iup.label { title = "Hello world from IUP." }
local dlg = iup.dialog {
	iup.vbox {
		label
	},
	title = "Hello World 2",
}

iup.ShowXY(dlg, iup.CENTER, iup.CENTER)
iup.MainLoop()
iup.Close()
