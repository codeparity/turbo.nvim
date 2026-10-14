local state = require("turbo.state")

local M = {}

M.themes = {
  gruvbox = {
    name = "Gruvbox Dark",
    bg = "#282828",
    fg = "#ebdbb2",
    cursor = "#ebdbb2",
    sel_bg = "#504945",
    sel_fg = "#fbf1c7",
    line_nr = "#7c6f64",
    comment = "#928374",
    keyword = "#fb4934",
    string = "#b8bb26",
    func = "#fabd2f",
    type = "#83a598",
    constant = "#d3869b",
    special = "#fe8019",
    -- Menubar
    menubar_bg = "#3c3836",
    menubar_fg = "#ebdbb2",
    menubar_mnemonic = "#fabd2f",
    menubar_active_bg = "#504945",
    menubar_active_fg = "#fbf1c7",
    -- Dropdown
    dropdown_bg = "#3c3836",
    dropdown_fg = "#ebdbb2",
    dropdown_border = "#a89984",
    dropdown_mnemonic = "#fabd2f",
    dropdown_shortcut = "#a89984",
    dropdown_sel_bg = "#458588",
    dropdown_sel_fg = "#282828",
    dropdown_sep = "#665c54",
    shadow_bg = "#1d2021",
    -- Window Frame
    frame_border = "#a89984",
    frame_title = "#ebdbb2",
    frame_btn = "#fabd2f",
    -- Status
    status_bg = "#3c3836",
    status_fg = "#ebdbb2",
    status_key = "#fabd2f",
    status_desc = "#83a598",
  },
  borland = {
    name = "Borland Turbo C++",
    bg = "#0000A8",
    fg = "#FFFFFF",
    cursor = "#FFFFFF",
    sel_bg = "#00AAAA",
    sel_fg = "#000000",
    line_nr = "#5555FF",
    comment = "#55FFFF",
    keyword = "#FFFF55",
    string = "#00AAAA",
    func = "#FFFFFF",
    type = "#55FF55",
    constant = "#FFAA00",
    special = "#FF55FF",
    -- Menubar
    menubar_bg = "#AAAAAA",
    menubar_fg = "#000000",
    menubar_mnemonic = "#A80000",
    menubar_active_bg = "#000000",
    menubar_active_fg = "#FFFFFF",
    -- Dropdown
    dropdown_bg = "#AAAAAA",
    dropdown_fg = "#000000",
    dropdown_border = "#000000",
    dropdown_mnemonic = "#A80000",
    dropdown_shortcut = "#555555",
    dropdown_sel_bg = "#00AA00",
    dropdown_sel_fg = "#FFFFFF",
    dropdown_sep = "#555555",
    shadow_bg = "#000055",
    -- Window Frame
    frame_border = "#FFFFFF",
    frame_title = "#FFFF55",
    frame_btn = "#55FF55",
    -- Status
    status_bg = "#AAAAAA",
    status_fg = "#000000",
    status_key = "#A80000",
    status_desc = "#0000A8",
  },
  monokai = {
    name = "Monokai Pro",
    bg = "#272822",
    fg = "#F8F8F2",
    cursor = "#F8F8F2",
    sel_bg = "#49483E",
    sel_fg = "#F8F8F2",
    line_nr = "#75715E",
    comment = "#75715E",
    keyword = "#F92672",
    string = "#E6DB74",
    func = "#A6E22E",
    type = "#66D9EF",
    constant = "#AE81FF",
    special = "#FD971F",
    -- Menubar
    menubar_bg = "#3E3D32",
    menubar_fg = "#F8F8F2",
    menubar_mnemonic = "#F92672",
    menubar_active_bg = "#F92672",
    menubar_active_fg = "#272822",
    -- Dropdown
    dropdown_bg = "#3E3D32",
    dropdown_fg = "#F8F8F2",
    dropdown_border = "#75715E",
    dropdown_mnemonic = "#F92672",
    dropdown_shortcut = "#A6E22E",
    dropdown_sel_bg = "#A6E22E",
    dropdown_sel_fg = "#272822",
    dropdown_sep = "#49483E",
    shadow_bg = "#1B1C18",
    -- Window Frame
    frame_border = "#75715E",
    frame_title = "#66D9EF",
    frame_btn = "#E6DB74",
    -- Status
    status_bg = "#3E3D32",
    status_fg = "#F8F8F2",
    status_key = "#F92672",
    status_desc = "#66D9EF",
  },
  mocha = {
    name = "Catppuccin Mocha",
    bg = "#1E1E2E",
    fg = "#CDD6F4",
    cursor = "#F5E0DC",
    sel_bg = "#45475A",
    sel_fg = "#CDD6F4",
    line_nr = "#6C7086",
    comment = "#6C7086",
    keyword = "#CBA6F7",
    string = "#A6E3A1",
    func = "#89B4FA",
    type = "#F9E2AF",
    constant = "#FAB387",
    special = "#F38BA8",
    -- Menubar
    menubar_bg = "#313244",
    menubar_fg = "#CDD6F4",
    menubar_mnemonic = "#F38BA8",
    menubar_active_bg = "#89B4FA",
    menubar_active_fg = "#1E1E2E",
    -- Dropdown
    dropdown_bg = "#313244",
    dropdown_fg = "#CDD6F4",
    dropdown_border = "#585B70",
    dropdown_mnemonic = "#F38BA8",
    dropdown_shortcut = "#89B4FA",
    dropdown_sel_bg = "#89B4FA",
    dropdown_sel_fg = "#1E1E2E",
    dropdown_sep = "#45475A",
    shadow_bg = "#11111B",
    -- Window Frame
    frame_border = "#585B70",
    frame_title = "#89B4FA",
    frame_btn = "#F9E2AF",
    -- Status
    status_bg = "#313244",
    status_fg = "#CDD6F4",
    status_key = "#F38BA8",
    status_desc = "#A6E3A1",
  },
}

function M.set_theme(name)
  if not M.themes[name] then
    name = "gruvbox"
  end
  state.active_theme = name
  local p = M.themes[name]

  vim.o.termguicolors = true
  vim.o.background = "dark"

  -- Editor Base Highlights
  local highlights = {
    Normal = { fg = p.fg, bg = p.bg },
    NormalFloat = { fg = p.dropdown_fg, bg = p.dropdown_bg },
    FloatBorder = { fg = p.dropdown_border, bg = p.dropdown_bg },
    CursorLine = { bg = p.sel_bg },
    Visual = { fg = p.sel_fg, bg = p.sel_bg },
    LineNr = { fg = p.line_nr, bg = p.bg },
    CursorLineNr = { fg = p.func, bg = p.bg, bold = true },
    SignColumn = { bg = p.bg },
    VertSplit = { fg = p.frame_border, bg = p.bg },
    WinSeparator = { fg = p.frame_border, bg = p.bg },
    Search = { fg = p.bg, bg = p.func },
    IncSearch = { fg = p.bg, bg = p.special },

    -- Syntax
    Comment = { fg = p.comment, italic = true },
    Constant = { fg = p.constant },
    String = { fg = p.string },
    Character = { fg = p.string },
    Number = { fg = p.constant },
    Boolean = { fg = p.constant, bold = true },
    Identifier = { fg = p.fg },
    Function = { fg = p.func },
    Statement = { fg = p.keyword, bold = true },
    Keyword = { fg = p.keyword, bold = true },
    PreProc = { fg = p.special },
    Type = { fg = p.type, bold = true },
    Special = { fg = p.special },
    Error = { fg = "#FFFFFF", bg = "#A80000", bold = true },
    Todo = { fg = p.bg, bg = p.func, bold = true },

    -- Diagnostics
    DiagnosticError = { fg = "#fb4934" },
    DiagnosticWarn = { fg = "#fabd2f" },
    DiagnosticInfo = { fg = "#83a598" },
    DiagnosticHint = { fg = "#b8bb26" },

    -- Menubar
    TurboMenuBar = { fg = p.menubar_fg, bg = p.menubar_bg },
    TurboMenuMnemonic = { fg = p.menubar_mnemonic, bg = p.menubar_bg, bold = true, underline = true },
    TurboMenuActive = { fg = p.menubar_active_fg, bg = p.menubar_active_bg, bold = true },
    TabLine = { fg = p.menubar_fg, bg = p.menubar_bg },
    TabLineFill = { fg = p.menubar_fg, bg = p.menubar_bg },
    TabLineSel = { fg = p.menubar_active_fg, bg = p.menubar_active_bg, bold = true },

    -- Dropdowns
    TurboMenuDropdown = { fg = p.dropdown_fg, bg = p.dropdown_bg },
    TurboMenuBorder = { fg = p.dropdown_border, bg = p.dropdown_bg },
    TurboMenuDropMnemonic = { fg = p.dropdown_mnemonic, bg = p.dropdown_bg, bold = true, underline = true },
    TurboMenuShortcut = { fg = p.dropdown_shortcut, bg = p.dropdown_bg },
    TurboMenuSelect = { fg = p.dropdown_sel_fg, bg = p.dropdown_sel_bg, bold = true },
    TurboMenuSelectMnemonic = { fg = p.dropdown_sel_fg, bg = p.dropdown_sel_bg, bold = true, underline = true },
    TurboMenuSeparator = { fg = p.dropdown_sep, bg = p.dropdown_bg },
    TurboMenuShadow = { fg = p.shadow_bg, bg = p.shadow_bg },

    -- Window Frames
    TurboFrame = { fg = p.frame_border, bg = p.bg },
    TurboFrameTitle = { fg = p.frame_title, bg = p.bg, bold = true },
    TurboFrameBtn = { fg = p.frame_btn, bg = p.bg, bold = true },

    -- Statusline
    TurboStatus = { fg = p.status_fg, bg = p.status_bg },
    TurboStatusKey = { fg = p.status_key, bg = p.status_bg, bold = true, underline = true },
    TurboStatusDesc = { fg = p.status_desc, bg = p.status_bg },
    StatusLine = { fg = p.status_fg, bg = p.status_bg },
    StatusLineNC = { fg = p.line_nr, bg = p.menubar_bg },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Trigger redraw
  vim.cmd("redrawtabline")
  vim.cmd("redrawstatus")
end

function M.get_current()
  return M.themes[state.active_theme] or M.themes.gruvbox
end

return M
