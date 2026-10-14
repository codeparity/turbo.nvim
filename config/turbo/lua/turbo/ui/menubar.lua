local state = require("turbo.state")
local menus = require("turbo.menus")

local M = {}

M.menu_coords = {}

function M.get_menu_col(idx)
  if M.menu_coords[idx] then
    return M.menu_coords[idx]
  end
  -- Fallback calculation
  local col = 3
  for i = 1, idx - 1 do
    col = col + #menus.items[i].title + 2
  end
  return col
end

function M.render()
  local s = "%#TurboMenuBar#"

  -- System button: ≡ (passes 0 to click callback)
  s = s .. "%0@v:lua.TurboSystemClick@ ≡ %X"

  local current_col = 3
  M.menu_coords = {}

  for idx, menu in ipairs(menus.items) do
    M.menu_coords[idx] = current_col
    local title = menu.title
    local m_char = menu.mnemonic
    local m_idx = title:find(m_char, 1, true) or 1
    local pre = title:sub(1, m_idx - 1)
    local letter = title:sub(m_idx, m_idx)
    local post = title:sub(m_idx + 1)

    -- Valid Neovim click format: %<minwid>@<funcname>@
    s = s .. "%" .. idx .. "@v:lua.TurboMenuTabClick@"

    if state.menu_open and state.active_menu_idx == idx then
      s = s .. "%#TurboMenuActive# " .. pre .. letter .. post .. " %#TurboMenuBar#"
    else
      s = s .. " " .. pre .. "%#TurboMenuMnemonic#" .. letter .. "%#TurboMenuBar#" .. post .. " "
    end

    s = s .. "%X"
    current_col = current_col + #title + 2
  end

  -- Fill the rest of the tabline with menubar background
  s = s .. "%#TurboMenuBar#%="

  -- Only show right brand label if screen is wide enough to avoid truncating menus
  local cols = vim.o.columns or 80
  if cols >= 100 then
    s = s .. "Turbo C++ 3.0 "
  end

  return s
end

-- Global click handlers for Tabline
_G.TurboMenuTabClick = function(idx, clicks, button, mods)
  local dropdown = require("turbo.ui.dropdown")
  if state.menu_open and state.active_menu_idx == idx then
    dropdown.close()
  else
    dropdown.open(idx)
  end
end

_G.TurboSystemClick = function()
  require("turbo.layout").show_about_dialog()
end

return M
