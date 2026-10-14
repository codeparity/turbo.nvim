local M = {}

-- Dynamically adapt UI highlight groups directly from the user's active colorscheme
function M.adapt_user_colorscheme()
  local tabline = vim.api.nvim_get_hl(0, { name = "TabLine", link = false })
  local tabline_sel = vim.api.nvim_get_hl(0, { name = "TabLineSel", link = false })
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
  local identifier = vim.api.nvim_get_hl(0, { name = "Identifier", link = false })
  local special = vim.api.nvim_get_hl(0, { name = "Special", link = false })
  local warn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
  local visual = vim.api.nvim_get_hl(0, { name = "Visual", link = false })

  -- Use subtle background for menubar
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

  pcall(vim.cmd, "redrawtabline")
  pcall(vim.cmd, "redrawstatus")
end

function M.setup()
  M.adapt_user_colorscheme()
end

return M
