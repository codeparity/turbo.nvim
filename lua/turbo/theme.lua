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
    menubar_bg = "#3c3836",
    menubar_fg = "#83a598",        -- Secondary accent cyan/blue for high-contrast readability
    menubar_mnemonic = "#fabd2f",  -- Bright yellow accelerator
    menubar_active_bg = "#504945",
    menubar_active_fg = "#fbf1c7",
    dropdown_bg = "#3c3836",
    dropdown_fg = "#ebdbb2",
    dropdown_border = "#a89984",
    dropdown_mnemonic = "#fabd2f",
    dropdown_shortcut = "#a89984",
    dropdown_sel_bg = "#458588",
    dropdown_sel_fg = "#282828",
    dropdown_sep = "#665c54",
    shadow_bg = "#1d2021",
    frame_border = "#a89984",
    frame_title = "#ebdbb2",
    frame_btn = "#fabd2f",
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
    menubar_bg = "#AAAAAA",
    menubar_fg = "#000000",
    menubar_mnemonic = "#A80000",
    menubar_active_bg = "#000000",
    menubar_active_fg = "#FFFFFF",
    dropdown_bg = "#AAAAAA",
    dropdown_fg = "#000000",
    dropdown_border = "#000000",
    dropdown_mnemonic = "#A80000",
    dropdown_shortcut = "#555555",
    dropdown_sel_bg = "#00AA00",
    dropdown_sel_fg = "#FFFFFF",
    dropdown_sep = "#555555",
    shadow_bg = "#000055",
    frame_border = "#FFFFFF",
    frame_title = "#FFFF55",
    frame_btn = "#55FF55",
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
    menubar_bg = "#3E3D32",
    menubar_fg = "#66D9EF",        -- Secondary cyan
    menubar_mnemonic = "#F92672",  -- Magenta accelerator
    menubar_active_bg = "#F92672",
    menubar_active_fg = "#272822",
    dropdown_bg = "#3E3D32",
    dropdown_fg = "#F8F8F2",
    dropdown_border = "#75715E",
    dropdown_mnemonic = "#F92672",
    dropdown_shortcut = "#A6E22E",
    dropdown_sel_bg = "#A6E22E",
    dropdown_sel_fg = "#272822",
    dropdown_sep = "#49483E",
    shadow_bg = "#1B1C18",
    frame_border = "#75715E",
    frame_title = "#66D9EF",
    frame_btn = "#E6DB74",
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
    menubar_bg = "#313244",
    menubar_fg = "#89B4FA",        -- Secondary blue
    menubar_mnemonic = "#F38BA8",  -- Red/pink accelerator
    menubar_active_bg = "#89B4FA",
    menubar_active_fg = "#1E1E2E",
    dropdown_bg = "#313244",
    dropdown_fg = "#CDD6F4",
    dropdown_border = "#585B70",
    dropdown_mnemonic = "#F38BA8",
    dropdown_shortcut = "#89B4FA",
    dropdown_sel_bg = "#89B4FA",
    dropdown_sel_fg = "#1E1E2E",
    dropdown_sep = "#45475A",
    shadow_bg = "#11111B",
    frame_border = "#585B70",
    frame_title = "#89B4FA",
    frame_btn = "#F9E2AF",
    status_bg = "#313244",
    status_fg = "#CDD6F4",
    status_key = "#F38BA8",
    status_desc = "#A6E3A1",
  },
}

-- Adapt UI highlight groups directly from the user's active colorscheme
function M.adapt_user_colorscheme()
  local tabline = vim.api.nvim_get_hl(0, { name = "TabLine", link = false })
  local tabline_sel = vim.api.nvim_get_hl(0, { name = "TabLineSel", link = false })
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
  local identifier = vim.api.nvim_get_hl(0, { name = "Identifier", link = false })
  local special = vim.api.nvim_get_hl(0, { name = "Special", link = false })
  local warn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
  local visual = vim.api.nvim_get_hl(0, { name = "Visual", link = false })

  -- Use subtle background for menubar bar
  local menubar_bg = tabline.bg or normal_float.bg or 0x3c3836

  -- Use secondary foreground/accent color so text is prominent and not dim/background-like
  local menubar_fg = identifier.fg or normal.fg or 0xebdbb2

  -- Bright accelerator/mnemonic color with underline
  local mnemonic_fg = warn.fg or special.fg or 0xfabd2f

  local highlights = {
    TurboMenuBar = { fg = menubar_fg, bg = menubar_bg },
    TurboMenuMnemonic = { fg = mnemonic_fg, bg = menubar_bg, bold = true, underline = true },
    TurboMenuActive = { fg = tabline_sel.fg or 0xffffff, bg = visual.bg or tabline_sel.bg or 0x504945, bold = true },

    TurboMenuDropdown = { link = "NormalFloat" },
    TurboMenuBorder = { link = "FloatBorder" },
    TurboMenuDropMnemonic = { fg = mnemonic_fg, bg = normal_float.bg, bold = true, underline = true },
    TurboMenuShortcut = { fg = special.fg or mnemonic_fg, bg = normal_float.bg },
    TurboMenuSelect = { link = "PmenuSel" },
    TurboMenuSelectMnemonic = { link = "PmenuSel", bold = true, underline = true },
    TurboMenuSeparator = { link = "FloatBorder" },
    TurboMenuShadow = { bg = 0x111111 },

    TurboFrame = { link = "FloatBorder" },
    TurboFrameTitle = { link = "Title" },
    TurboFrameBtn = { link = "Special" },

    TurboStatus = { link = "StatusLine" },
    TurboStatusKey = { fg = mnemonic_fg, bold = true, underline = true },
    TurboStatusDesc = { link = "Title" },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  vim.cmd("redrawtabline")
  vim.cmd("redrawstatus")
end

-- Explicit theme setter (for when user explicitly requests a preset or in standalone mode)
function M.set_theme(name)
  if not name or not M.themes[name] then
    M.adapt_user_colorscheme()
    return
  end
  state.active_theme = name
  local p = M.themes[name]

  local highlights = {
    TurboMenuBar = { fg = p.menubar_fg, bg = p.menubar_bg },
    TurboMenuMnemonic = { fg = p.menubar_mnemonic, bg = p.menubar_bg, bold = true, underline = true },
    TurboMenuActive = { fg = p.menubar_active_fg, bg = p.menubar_active_bg, bold = true },

    TurboMenuDropdown = { fg = p.dropdown_fg, bg = p.dropdown_bg },
    TurboMenuBorder = { fg = p.dropdown_border, bg = p.dropdown_bg },
    TurboMenuDropMnemonic = { fg = p.dropdown_mnemonic, bg = p.dropdown_bg, bold = true, underline = true },
    TurboMenuShortcut = { fg = p.dropdown_shortcut, bg = p.dropdown_bg },
    TurboMenuSelect = { fg = p.dropdown_sel_fg, bg = p.dropdown_sel_bg, bold = true },
    TurboMenuSelectMnemonic = { fg = p.dropdown_sel_fg, bg = p.dropdown_sel_bg, bold = true, underline = true },
    TurboMenuSeparator = { fg = p.dropdown_sep, bg = p.dropdown_bg },
    TurboMenuShadow = { fg = p.shadow_bg, bg = p.shadow_bg },

    TurboFrame = { fg = p.frame_border, bg = p.bg },
    TurboFrameTitle = { fg = p.frame_title, bg = p.bg, bold = true },
    TurboFrameBtn = { fg = p.frame_btn, bg = p.bg, bold = true },

    TurboStatus = { fg = p.status_fg, bg = p.status_bg },
    TurboStatusKey = { fg = p.status_key, bg = p.status_bg, bold = true, underline = true },
    TurboStatusDesc = { fg = p.status_desc, bg = p.status_bg },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  vim.cmd("redrawtabline")
  vim.cmd("redrawstatus")
end

function M.get_current()
  return M.themes[state.active_theme] or M.themes.gruvbox
end

return M
