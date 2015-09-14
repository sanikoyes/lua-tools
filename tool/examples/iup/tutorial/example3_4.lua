local iup = require "iuplua"

local multitext = iup.text { multiline = "YES", expand = "YES", name = "MULTITEXT" }

local item_open = iup.item { title = "Open..." }
local item_saveas = iup.item { title = "Save As..." }
local item_exit = iup.item { title = "Exit" }
local item_find = iup.item { title = "Find.." }
local item_goto = iup.item { title = "Go To..." }
local item_font = iup.item { title = "Font..." }
local item_about = iup.item { title = "About..." }

function item_open:action()
  local multitext = iup.GetDialogChild(item_open, "MULTITEXT")

  local filedlg = iup.filedlg {
    dialogtype = "open",
    filter = "*.txt",
    filterinfo = "Text Files",
    parentdialog = iup.GetDialog(item_open),
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
  local multitext = iup.GetDialogChild(item_open, "MULTITEXT")

  local filedlg = iup.filedlg {
    dialogtype = "save",
    filter = "*.txt",
    filterinfo = "Text Files",
    parentdialog = iup.GetDialog(item_open),
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

function item_exit:action()
  return iup.CLOSE
end

function item_find:action()
  local dlg = item_find.find_dialog
  if dlg == nil then
    local multitext = iup.GetDialogChild(item_find, "MULTITEXT")

    local txt = iup.text {
      name = "FIND_TEXT",
      visiblecolumns = "20",
    }
    local tgl_case = iup.toggle {
      title = "Case Sensitive",
      name = "FIND_CASE",
    }
    local bt_next = iup.button {
      title = "Find Next",
      padding = "10x2",
    }
    function bt_next:action()
      local multitext = bt_next.multitext
      local str = multitext.value
      local find_pos = multitext.find_pos

      local txt = iup.GetDialogChild(bt_next, "FIND_TEXT")
      local str_to_find = txt.value

      local tgl_case = iup.GetDialogChild(bt_next, "FIND_CASE")
      if tgl_case.value == "OFF" then
        str_to_find = str_to_find:upper()
        str = str:upper()
      end

      local pos = str:find(str_to_find, find_pos) or -1
      if pos == -1 then
        -- try again from the start
        pos = str:find(str_to_find) or -1
      end

      if pos > 0 then
        -- lua pos start from 1, c is 0
        pos = pos - 1
        local end_pos = pos + #str_to_find
        multitext.find_pos = end_pos
        iup.SetFocus(multitext)
        multitext.selectionpos = string.format("%d:%d", pos, end_pos)

        local lin, col = iup.TextConvertPosToLinCol(multitext, pos)
        -- position at col=0, just scroll lines
        local pos = iup.TextConvertLinColToPos(multitext, lin, 0)
        multitext.scrolltopos = pos
      else
        iup.Message("Warning", "Text not found")
      end
      return iup.DEFAULT
    end
    local bt_close = iup.button {
      title = "Close",
      padding = "10x2",
    }
    function bt_close:action()
      iup.Hide(iup.GetDialog(bt_close))
      return iup.DEFAULT
    end
    local box = iup.vbox {
      iup.label { title = "Find What:" },
      txt,
      tgl_case,
      iup.SetAttributes(
        iup.hbox {
          iup.fill {},
          bt_next,
          bt_close,
        },
        "NORMALIZESIZE=HORIZONTAL"
      ),
      margin = "10x10",
      gap = "5",
    }
    dlg = iup.dialog {
      box,
      title = "Find",
      dialogframe = "YES",
      defaultenter = bt_next,
      defaultesc = bt_close,
      parentdialog = iup.GetDialog(item_find),
    }

    -- Save the multiline to acess it from the callbacks
    dlg.multitext = multitext
    -- Save the dialog to reuse it
    item_find.find_dialog = dlg
  end
  -- centerparent first time, next time reuse the last position
  iup.ShowXY(dlg, iup.CENTER, iup.CENTER)

  return iup.DEFAULT
end

function item_goto:action()
  local multitext = iup.GetDialogChild(item_goto, "MULTITEXT")

  local line_count = multitext.linecount
  local lbl = iup.label { title = string.format("Line Number [1-%d]:", line_count) }
  -- unsigned integer number
  local txt = iup.text {
    mask = iup.MASK_UINT,
    name = "LINE_TEXT",
    visiblecolumns = "20",
  }
  local bt_ok = iup.button {
    title = "OK",
    text_linecount = line_count,
    padding = "10x2",
  }
  function bt_ok:action()
    local line_count = tonumber(bt_ok.text_linecount)
    local line = tonumber(txt.value) or -1
    if line < 1 or line >= line_count then
      iup.Message("Error", "Invalid line number.")
      return iup.DEFAULT
    end
    iup.GetDialog(bt_ok).status = "1"
    return iup.CLOSE
  end
  local bt_cancel = iup.button {
    title = "Cancel",
    padding = "10x2",
  }
  function bt_cancel:action()
    iup.GetDialog(bt_ok).status = "0"
    return iup.CLOSE
  end

  local hbox = iup.hbox {
    iup.fill {},
    bt_ok,
    bt_cancel,
    normalizesize = "HORIZONTAL",
  }
  local vbox = iup.vbox {
    lbl,
    txt,
    hbox,
    margin = "10x10", gap = "5",
  }
  local dlg = iup.dialog {
    vbox,
    title = "Go To Line",
    dialogframe = "YES",
    defaultenter = bt_ok,
    defaultesc = bt_cancel,
    parentdialog = iup.GetDialog(item_goto),
  }
  iup.Popup(dlg, iup.CENTER, iup.CENTER)

  if dlg.status == "1" then
    local line = txt.value
    local pos = iup.TextConvertLinColToPos(multitext, line, 0)
    multitext.caretpos = pos
    multitext.scrolltopos = pos
  end
  iup.Destroy(dlg)
  return iup.DEFAULT
end

function item_font:action()
  local multitext = iup.GetDialogChild(item_open, "MULTITEXT")

  local fontdlg = iup.fontdlg {
    value = multitext.font,
    parentdialog = iup.GetDialog(item_open),
  }
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
local edit_menu = iup.menu {
  item_find,
  item_goto,
}
local format_menu = iup.menu {
  item_font,
}
local help_menu = iup.menu {
  item_about,
}

local sub_menu_file = iup.submenu { title = "File", file_menu }
local sub_menu_edit = iup.submenu { title = "Edit", edit_menu }
local sub_menu_format = iup.submenu { title = "Format", format_menu }
local sub_menu_help = iup.submenu { title = "Help", help_menu }

local menu = iup.menu {
  sub_menu_file,
  sub_menu_edit,
  sub_menu_format,
  sub_menu_help,
}

local vbox = iup.vbox { multitext }

local dlg = iup.dialog {
  vbox,
  menu = menu, title = "Simple Notepad", size = "HALFxHALF",
}

-- parent for pre-defined dialogs in closed functions (IupMessage)
--iup.SetAttribute(nil, "PARENTDIALOG", dlg)

iup.ShowXY(dlg, iup.CENTER, iup.CENTER)
dlg.usersize = nil
iup.MainLoop()
iup.Close()

