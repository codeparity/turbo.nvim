local state = require("turbo.state")

local M = {}

function M.render()
  if state.menu_open then
    local dropdown = require("turbo.ui.dropdown")
    local desc = dropdown.get_selected_desc()
    if desc and #desc > 0 then
      return "%#TurboStatusDesc#  " .. desc .. "%#TurboStatus#%="
    end
  end

  -- Default Classic Turbo C++ Status Bar
  local s = "%#TurboStatus#"
  local items = {
    { key = "F1", label = "Help" },
    { key = "F2", label = "Save" },
    { key = "F3", label = "Open" },
    { key = "Alt-F9", label = "Compile" },
    { key = "F9", label = "Make" },
    { key = "F10", label = "Menu" },
  }

  for i, it in ipairs(items) do
    s = s .. " " .. "%#TurboStatusKey#" .. it.key .. "%#TurboStatus# " .. it.label .. " "
    if i < #items then
      s = s .. "│"
    end
  end

  -- Right-aligned position info
  s = s .. "%=" .. "%#TurboStatus# %l:%c │ %p%% "

  return s
end

return M
