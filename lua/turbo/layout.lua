local state = require("turbo.state")
local theme = require("turbo.theme")

local M = {}

-- Render the classic Borland window header or open buffer tabs below the menubar
function M.render_winbar()
  local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
  if not winid or not vim.api.nvim_win_is_valid(winid) then
    return ""
  end

  -- Skip float windows (like dropdown menus, popups, dashboards)
  local cfg = vim.api.nvim_win_get_config(winid)
  if cfg.relative and cfg.relative ~= "" then
    return ""
  end

  local bufnr = vim.api.nvim_win_get_buf(winid)
  local ft = vim.bo[bufnr].filetype

  -- Special windows that shouldn't show a winbar header
  if ft == "snacks_dashboard" or ft == "lazy" or ft == "mason" or ft == "help" or ft == "neo-tree" or ft == "nerdtree" then
    return ""
  end

  -- If bufferline is loaded and active, render bufferline tabs right below menubar!
  if package.loaded["bufferline"] and _G.nvim_bufferline then
    local ok, res = pcall(_G.nvim_bufferline)
    if ok and res and #res > 0 then
      return res
    end
  end

  local bufs = vim.fn.getbufinfo({ buflisted = 1 })

  -- When multiple buffers exist, render clickable retro tabs in the winbar
  if #bufs > 1 then
    local s = "%#TurboFrame#╔═%@v:lua.TurboWinCloseClick@%#TurboFrameBtn#[■]%X%#TurboFrame#═ "
    for _, b in ipairs(bufs) do
      local bname = vim.fn.fnamemodify(b.name, ":t")
      if #bname == 0 then bname = "NONAME00.CPP" end
      local mod = vim.bo[b.bufnr].modified and "*" or ""
      if b.bufnr == bufnr then
        s = s .. "%#TurboMenuSelect# " .. b.bufnr .. " " .. bname .. mod .. " %#TurboFrame# "
      else
        s = s .. "%" .. b.bufnr .. "@v:lua.TurboSwitchBufClick@%#TurboFrameTitle#" .. b.bufnr .. " " .. bname .. mod .. "%X %#TurboFrame# "
      end
    end
    s = s .. "%#TurboFrame#%=" .. "%@v:lua.TurboWinZoomClick@%#TurboFrameBtn#[↑]%X%#TurboFrame#═╗"
    return s
  end

  -- Single window default Borland double box frame (stable: uses exact window buffer)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local display_name = "NONAME00.CPP"
  if name and #name > 0 then
    display_name = vim.fn.fnamemodify(name, ":t")
  end

  local modified = vim.bo[bufnr].modified and "*" or ""
  local winnr = vim.api.nvim_win_get_number(winid)
  local title_str = string.format(" %d %s%s ", winnr, display_name, modified)

  local width = vim.api.nvim_win_get_width(winid)
  local fixed_chars = 14 + #title_str
  local fill_len = math.max(2, math.floor((width - fixed_chars) / 2))
  local left_fill = string.rep("═", fill_len)
  local right_fill = string.rep("═", math.max(2, width - fixed_chars - fill_len))

  local s = "%#TurboFrame#╔═"
  s = s .. "%@v:lua.TurboWinCloseClick@%#TurboFrameBtn#[■]%X"
  s = s .. "%#TurboFrame#" .. left_fill
  s = s .. "%#TurboFrameTitle#" .. title_str
  s = s .. "%#TurboFrame#" .. right_fill
  s = s .. "%@v:lua.TurboWinZoomClick@%#TurboFrameBtn#[↑]%X"
  s = s .. "%#TurboFrame#═╗"

  return s
end

-- Global winbar click handlers
_G.TurboWinCloseClick = function()
  vim.cmd("close")
end

_G.TurboWinZoomClick = function()
  M.toggle_zoom()
end

_G.TurboSwitchBufClick = function(bufnr)
  if bufnr and bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_set_current_buf(bufnr)
  end
end

-- Open File Browser / Explorer (Neo-tree, NERDTree, Snacks Picker, or Telescope)
function M.open_file_browser()
  -- 1. Try Neo-tree (the modern Neovim equivalent of NERDTree)
  if vim.fn.exists(":Neotree") == 2 then
    vim.cmd("Neotree reveal")
    return
  end

  -- 2. Try classic NERDTree if installed
  if vim.fn.exists(":NERDTreeToggle") == 2 or vim.fn.exists(":NERDTree") == 2 then
    vim.cmd("NERDTreeToggle")
    return
  end

  -- 3. Try Snacks explorer or picker
  local ok_snacks, snacks = pcall(require, "snacks")
  if ok_snacks then
    if snacks.explorer then
      snacks.explorer()
      return
    elseif snacks.picker and snacks.picker.files then
      snacks.picker.files()
      return
    end
  end

  -- 4. Try Telescope
  local ok_tele, builtin = pcall(require, "telescope.builtin")
  if ok_tele and builtin.find_files then
    builtin.find_files()
    return
  end

  -- 5. Native directory browser fallback
  vim.cmd("edit .")
end

-- Directory Tree toggle (Project menu)
function M.open_dir_explorer()
  M.open_file_browser()
end

function M.toggle_zoom()
  if state.is_zoomed then
    vim.cmd("wincmd =")
    state.is_zoomed = false
    vim.notify("Restored window layout", vim.log.levels.INFO)
  else
    vim.cmd("wincmd _")
    vim.cmd("wincmd |")
    state.is_zoomed = true
    vim.notify("Zoomed active window", vim.log.levels.INFO)
  end
end

function M.show_about_dialog()
  local width = 56
  local height = 11
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  local lines = {
    "",
    "           BORLAND C++ & TURBO C++ 3.0",
    "             Copyright (c) 1990, 1992",
    "               Borland International",
    "",
    "         Enhanced Modern Neovim TUI Edition",
    "         Press Alt+F to open File menu",
    "         Press F3 to open File Browser (Neo-tree)",
    "",
    "          [ Press Enter or Esc to Dismiss ]",
    "",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "double",
    title = " About Turbo C++ ",
    title_pos = "center",
    zindex = 60,
  })

  vim.wo[win].winhighlight = "Normal:TurboMenuDropdown,FloatBorder:TurboMenuBorder,FloatTitle:TurboFrameTitle"

  local close_dialog = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local opts = { buffer = buf, silent = true, nowait = true }
  vim.keymap.set("n", "<CR>", close_dialog, opts)
  vim.keymap.set("n", "<Esc>", close_dialog, opts)
  vim.keymap.set("n", "<Space>", close_dialog, opts)
  vim.keymap.set("n", "q", close_dialog, opts)
end

function M.open_theme_selector()
  local themes_list = {
    { id = "auto", name = "Auto (Respect Current Colorscheme)" },
    { id = "gruvbox", name = "Gruvbox Dark" },
    { id = "borland", name = "Borland Turbo C++ (Classic DOS Blue)" },
    { id = "monokai", name = "Monokai Pro" },
    { id = "mocha", name = "Catppuccin Mocha" },
  }

  local width = 50
  local height = #themes_list + 4
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  local lines = { " Select Color Theme:" }
  for _, t in ipairs(themes_list) do
    local mark = (t.id == state.active_theme or (t.id == "auto" and not state.active_theme)) and " [●] " or " [ ] "
    table.insert(lines, mark .. t.name)
  end
  table.insert(lines, string.rep("─", width))
  table.insert(lines, " <Enter> Apply  │  <Esc> Cancel")

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "double",
    title = " Color Palette ",
    title_pos = "center",
    zindex = 60,
  })

  vim.wo[win].winhighlight = "Normal:TurboMenuDropdown,FloatBorder:TurboMenuBorder,FloatTitle:TurboFrameTitle"

  local sel_idx = 1
  for i, t in ipairs(themes_list) do
    if t.id == state.active_theme then sel_idx = i break end
  end

  local ns = vim.api.nvim_create_namespace("turbo_theme_picker")
  local function highlight_sel()
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    vim.api.nvim_buf_set_extmark(buf, ns, sel_idx, 0, {
      end_col = width,
      hl_group = "TurboMenuSelect",
      line_hl_group = "TurboMenuSelect",
    })
  end
  highlight_sel()

  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end

  local opts = { buffer = buf, silent = true, nowait = true }
  vim.keymap.set("n", "<Down>", function()
    sel_idx = sel_idx % #themes_list + 1
    highlight_sel()
  end, opts)
  vim.keymap.set("n", "j", function()
    sel_idx = sel_idx % #themes_list + 1
    highlight_sel()
  end, opts)
  vim.keymap.set("n", "<Up>", function()
    sel_idx = (sel_idx - 2) % #themes_list + 1
    highlight_sel()
  end, opts)
  vim.keymap.set("n", "k", function()
    sel_idx = (sel_idx - 2) % #themes_list + 1
    highlight_sel()
  end, opts)
  vim.keymap.set("n", "<CR>", function()
    local chosen = themes_list[sel_idx]
    if chosen then
      if chosen.id == "auto" then
        theme.adapt_user_colorscheme()
        vim.notify("Turbo UI adapted to active colorscheme", vim.log.levels.INFO)
      else
        theme.set_theme(chosen.id)
        vim.notify("Applied theme: " .. chosen.name, vim.log.levels.INFO)
      end
    end
    close()
  end, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
  vim.keymap.set("n", "q", close, opts)
end

return M
