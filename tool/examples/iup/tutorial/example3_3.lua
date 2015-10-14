local iup = require "iuplua"

iup.SetGlobal("UTF8MODE", "YES")

local multitext = iup.text { multiline = "YES", expand = "YES" }
local item_open = iup.item { title = "Open..." }
local item_saveas = iup.item { title = "Save As..." }
local item_exit = iup.item { title = "Exit" }
local item_font = iup.item { title = "Font..." }
local item_about = iup.item { title = "About..." }

function item_exit:action()
  return iup.CLOSE
end

function item_open:action()
  local filedlg = iup.filedlg {
    dialogtype = "open",
    filter = "*.txt",
    filterinfo = "Text Files",
  }
  iup.Popup(filedlg, iup.CENTER, iup.CENTER)

  if filedlg.status ~= "-1" then
    local filename = filedlg.VALUE
    local fp = io.open(filename, "rb")
    local str = fp:read("*all")
    fp:close()
    multitext.value = str
  end
  iup.Destroy(filedlg)
  return iup.DEFAULT
end

function item_saveas:action()
  local filedlg = iup.filedlg {
    dialogtype = "save",
    filter = "*.txt",
    filterinfo = "Text Files",
  }
  iup.Popup(filedlg, iup.CENTER, iup.CENTER)

  if filedlg.status ~= "-1" then
    local filename = filedlg.VALUE
    local fp = io.open(filename, "wb")
    fp:write(multitext.value)
    fp:close()
  end
  iup.Destroy(filedlg)
  return iup.DEFAULT
end

function item_font:action()
  local fontdlg = iup.fontdlg { value = multitext.font }
  iup.Popup(fontdlg, iup.CENTER, iup.CENTER)

  if fontdlg.status == "1" then
    multitext.font = fontdlg.value
  end
  iup.Destroy(fontdlg)
  return iup.DEFAULT
end

function item_about:action()
  iup.Message("About", "   Simple Notepad\n\nAutors:\n   Gustavo Lyrio\n   Antonio Scuri")
  return iup.DEFAULT
end

local file_menu = iup.menu {
  item_open,
  item_saveas,
  iup.separator {},
  item_exit,
}

local format_menu = iup.menu {
  item_font,
}

local help_menu = iup.menu {
  item_about,
}

local sub_menu_file = iup.submenu { title = "File", file_menu }
local sub_menu_format = iup.submenu { title = "Format", format_menu }
local sub_menu_help = iup.submenu { title = "Help", help_menu }

local menu = iup.menu {
  sub_menu_file, 
  sub_menu_format, 
  sub_menu_help, 
}

local vbox = iup.vbox { multitext }

local dlg = iup.dialog {
  vbox,
  menu = menu, title = "Simple Notepad", size = "QUARTERxQUARTER",
}

iup.ShowXY(dlg, iup.CENTER, iup.CENTER)
dlg.usersize = nil
iup.MainLoop()
iup.Close()
