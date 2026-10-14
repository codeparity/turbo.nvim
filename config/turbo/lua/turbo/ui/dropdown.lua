local state = require("turbo.state")
local menus = require("turbo.menus")
local menubar = require("turbo.ui.menubar")

local M = {}

local ns_id = vim.api.nvim_create_namespace("turbo_dropdown")
local selected_row = 1

local function get_valid_rows(entries)
  local valid = {}
  for i, e in ipairs(entries) do
    if not e.separator then
      table.insert(valid, i)
    end
  end
  return valid
end

local function update_selection_highlight(entries, content_width)
  if not state.menu_buf or not vim.api.nvim_buf_is_valid(state.menu_buf) then
    return
  end

  vim.api.nvim_buf_clear_namespace(state.menu_buf, ns_id, 0, -1)

  for i, entry in ipairs(entries) do
    local line_idx = i - 1
    if entry.separator then
      vim.api.nvim_buf_set_extmark(state.menu_buf, ns_id, line_idx, 0, {
        end_col = content_width,
        hl_group = "TurboMenuSeparator",
        priority = 100,
      })
    elseif i == selected_row then
      -- Highlight selected line
      vim.api.nvim_buf_set_extmark(state.menu_buf, ns_id, line_idx, 0, {
        end_col = content_width,
        hl_group = "TurboMenuSelect",
        line_hl_group = "TurboMenuSelect",
        priority = 110,
      })

      -- Mnemonic on selected line
      if entry.mnemonic and entry.label then
        local m_idx = entry.label:find(entry.mnemonic, 1, true) or entry.label:lower():find(entry.mnemonic:lower(), 1, true)
        if m_idx then
          vim.api.nvim_buf_set_extmark(state.menu_buf, ns_id, line_idx, m_idx, {
            end_col = m_idx + 1,
            hl_group = "TurboMenuSelectMnemonic",
            priority = 120,
          })
        end
      end
    else
      -- Mnemonic on unselected line
      if entry.mnemonic and entry.label then
        local m_idx = entry.label:find(entry.mnemonic, 1, true) or entry.label:lower():find(entry.mnemonic:lower(), 1, true)
        if m_idx then
          vim.api.nvim_buf_set_extmark(state.menu_buf, ns_id, line_idx, m_idx, {
            end_col = m_idx + 1,
            hl_group = "TurboMenuDropMnemonic",
            priority = 100,
          })
        end
      end

      -- Shortcut highlight
      if entry.shortcut then
        local line_text = vim.api.nvim_buf_get_lines(state.menu_buf, line_idx, line_idx + 1, false)[1] or ""
        local s_idx = line_text:find(entry.shortcut, 1, true)
        if s_idx then
          vim.api.nvim_buf_set_extmark(state.menu_buf, ns_id, line_idx, s_idx - 1, {
            end_col = s_idx - 1 + #entry.shortcut,
            hl_group = "TurboMenuShortcut",
            priority = 100,
          })
        end
      end
    end
  end

  -- Update statusline with description of selected item
  vim.cmd("redrawstatus")
end

function M.get_selected_desc()
  if not state.menu_open or not state.active_menu_idx then
    return nil
  end
  local menu = menus.items[state.active_menu_idx]
  if not menu then return nil end
  local entry = menu.entries[selected_row]
  if entry and entry.desc then
    return entry.desc
  end
  return nil
end

function M.close()
  if state.shadow_win and vim.api.nvim_win_is_valid(state.shadow_win) then
    vim.api.nvim_win_close(state.shadow_win, true)
    state.shadow_win = nil
  end
  if state.menu_win and vim.api.nvim_win_is_valid(state.menu_win) then
    vim.api.nvim_win_close(state.menu_win, true)
    state.menu_win = nil
  end
  state.shadow_buf = nil
  state.menu_buf = nil
  state.menu_open = false
  state.active_menu_idx = nil

  if state.prev_win and vim.api.nvim_win_is_valid(state.prev_win) then
    pcall(vim.api.nvim_set_current_win, state.prev_win)
  end

  vim.cmd("redrawtabline")
  vim.cmd("redrawstatus")
end

function M.open(menu_idx)
  if not state.menu_open then
    state.prev_win = vim.api.nvim_get_current_win()
  end

  -- Close existing floats if any
  if state.shadow_win and vim.api.nvim_win_is_valid(state.shadow_win) then
    vim.api.nvim_win_close(state.shadow_win, true)
  end
  if state.menu_win and vim.api.nvim_win_is_valid(state.menu_win) then
    vim.api.nvim_win_close(state.menu_win, true)
  end

  state.active_menu_idx = menu_idx
  state.menu_open = true
  vim.cmd("redrawtabline")

  local menu = menus.items[menu_idx]
  if not menu then return end
  local entries = menu.entries

  -- Calculate width
  local max_label = 0
  local max_shortcut = 0
  for _, e in ipairs(entries) do
    if not e.separator then
      if #e.label > max_label then max_label = #e.label end
      if e.shortcut and #e.shortcut > max_shortcut then max_shortcut = #e.shortcut end
    end
  end

  local content_width = math.max(max_label + max_shortcut + 4, 22)
  local height = #entries
  local col = menubar.get_menu_col(menu_idx)
  if col + content_width + 4 > vim.o.columns then
    col = math.max(0, vim.o.columns - content_width - 4)
  end
  local row = 1

  -- Create buffers
  state.shadow_buf = vim.api.nvim_create_buf(false, true)
  state.menu_buf = vim.api.nvim_create_buf(false, true)

  vim.bo[state.menu_buf].buftype = "nofile"
  vim.bo[state.menu_buf].bufhidden = "wipe"
  vim.bo[state.menu_buf].swapfile = false

  -- Populate lines
  local lines = {}
  local shadow_lines = {}
  local sep_char = "═"
  for _, e in ipairs(entries) do
    table.insert(shadow_lines, string.rep(" ", content_width + 2))
    if e.separator then
      table.insert(lines, string.rep(sep_char, content_width))
    else
      local label = " " .. e.label
      local sc = e.shortcut or ""
      local spaces = content_width - #label - #sc - 1
      if spaces < 1 then spaces = 1 end
      table.insert(lines, label .. string.rep(" ", spaces) .. sc .. " ")
    end
  end

  vim.api.nvim_buf_set_lines(state.menu_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_lines(state.shadow_buf, 0, -1, false, shadow_lines)

  -- Open Drop Shadow Window
  state.shadow_win = vim.api.nvim_open_win(state.shadow_buf, false, {
    relative = "editor",
    row = row + 1,
    col = col + 2,
    width = content_width + 2,
    height = height,
    style = "minimal",
    focusable = false,
    zindex = 48,
  })
  vim.wo[state.shadow_win].winhighlight = "Normal:TurboMenuShadow"

  -- Open Menu Float Window
  state.menu_win = vim.api.nvim_open_win(state.menu_buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = content_width,
    height = height,
    style = "minimal",
    border = "double",
    zindex = 50,
  })
  vim.wo[state.menu_win].winhighlight = "Normal:TurboMenuDropdown,FloatBorder:TurboMenuBorder,CursorLine:TurboMenuSelect"

  -- Initialize selection
  local valids = get_valid_rows(entries)
  selected_row = valids[1] or 1
  update_selection_highlight(entries, content_width)

  -- Keymaps for navigation
  local opts = { buffer = state.menu_buf, silent = true, nowait = true }

  local function move_down()
    for _, r in ipairs(valids) do
      if r > selected_row then
        selected_row = r
        update_selection_highlight(entries, content_width)
        return
      end
    end
    selected_row = valids[1]
    update_selection_highlight(entries, content_width)
  end

  local function move_up()
    for i = #valids, 1, -1 do
      local r = valids[i]
      if r < selected_row then
        selected_row = r
        update_selection_highlight(entries, content_width)
        return
      end
    end
    selected_row = valids[#valids]
    update_selection_highlight(entries, content_width)
  end

  local function switch_left()
    local total = #menus.items
    local next_idx = menu_idx - 1
    if next_idx < 1 then next_idx = total end
    M.open(next_idx)
  end

  local function switch_right()
    local total = #menus.items
    local next_idx = menu_idx + 1
    if next_idx > total then next_idx = 1 end
    M.open(next_idx)
  end

  local function execute_current()
    local entry = entries[selected_row]
    M.close()
    if entry and entry.action then
      entry.action()
    end
  end

  vim.keymap.set("n", "<Down>", move_down, opts)
  vim.keymap.set("n", "j", move_down, opts)
  vim.keymap.set("n", "<Up>", move_up, opts)
  vim.keymap.set("n", "k", move_up, opts)
  vim.keymap.set("n", "<Left>", switch_left, opts)
  vim.keymap.set("n", "h", switch_left, opts)
  vim.keymap.set("n", "<Right>", switch_right, opts)
  vim.keymap.set("n", "l", switch_right, opts)
  vim.keymap.set("n", "<CR>", execute_current, opts)
  vim.keymap.set("n", "<Space>", execute_current, opts)
  vim.keymap.set("n", "<Esc>", M.close, opts)

  -- Mnemonic direct execution (both lowercase and uppercase)
  for _, entry in ipairs(entries) do
    if not entry.separator and entry.mnemonic and entry.action then
      local act = entry.action
      local lower = entry.mnemonic:lower()
      local upper = entry.mnemonic:upper()
      vim.keymap.set("n", lower, function()
        M.close()
        act()
      end, opts)
      vim.keymap.set("n", upper, function()
        M.close()
        act()
      end, opts)
    end
  end

  -- Mouse click handler inside dropdown
  vim.keymap.set("n", "<LeftMouse>", function()
    local mouse_pos = vim.fn.getmousepos()
    if mouse_pos.winid == state.menu_win then
      local click_row = mouse_pos.line
      local entry = entries[click_row]
      if entry and not entry.separator then
        selected_row = click_row
        execute_current()
      end
    else
      M.close()
    end
  end, opts)

  -- Alt-key switching while inside dropdown (e.g. Alt+E, Alt+S)
  for idx, m in ipairs(menus.items) do
    if m.keymap then
      vim.keymap.set("n", m.keymap, function()
        M.open(idx)
      end, opts)
    end
  end
end

return M
