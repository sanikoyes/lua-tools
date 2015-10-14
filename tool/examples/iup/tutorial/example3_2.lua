local iup = require "iuplua"

local multitext = iup.text { multiline = "YES", expand = "YES" }

local item_open = iup.item { title = "Open" }
local item_saveas = iup.item { title = "Save As" }
local item_exit = iup.item { title = "Exit" }

function item_exit:action()
  return iup.CLOSE
end

local file_menu = iup.menu {
  item_open,
  item_saveas,
  iup.separator {},
  item_exit,
}

local sub1_menu = iup.submenu {
  file_menu,
  title = "File",
}

local menu = iup.menu { sub1_menu }

local vbox = iup.vbox { multitext }

local dlg = iup.dialog {
  vbox,
  menu = menu,
  title = "Simple Notepad", size = "QUARTERxQUARTER",
}

iup.ShowXY(dlg, iup.CENTER, iup.CENTER)
dlg.usersize = nil
iup.MainLoop()
iup.Close()
