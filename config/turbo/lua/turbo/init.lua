local theme = require("turbo.theme")
local menubar = require("turbo.ui.menubar")
local dropdown = require("turbo.ui.dropdown")
local statusline = require("turbo.ui.statusline")
local layout = require("turbo.layout")
local compiler = require("turbo.compiler")
local menus = require("turbo.menus")
local keymaps = require("turbo.keymaps")

local M = {}

function M.setup(opts)
  opts = opts or {}
  local default_theme = opts.theme or "gruvbox"

  -- Initialize Theme
  theme.set_theme(default_theme)

  -- Setup standard core lazy-nvim keymaps (<leader> = <Space>)
  keymaps.setup()

  -- Top Menubar & Statusline
  vim.o.showtabline = 2
  vim.o.tabline = "%!v:lua.require('turbo.ui.menubar').render()"

  vim.o.laststatus = 3
  vim.o.statusline = "%!v:lua.require('turbo.ui.statusline').render()"

  -- Window headers (winbar)
  vim.o.winbar = "%!v:lua.require('turbo.layout').render_winbar()"

  -- Enable mouse across all modes
  vim.o.mouse = "a"

  -- Classic Keymaps Helper
  local map = function(modes, lhs, rhs, desc)
    vim.keymap.set(modes, lhs, rhs, { silent = true, desc = desc })
  end

  -- Alt-key top menu accelerators
  for idx, m in ipairs(menus.items) do
    if m.keymap then
      -- Map <A-key>
      map({ "n", "v" }, m.keymap, function()
        if dropdown then dropdown.open(idx) end
      end, "Turbo Menu: " .. m.title)

      -- Also map <M-key> for terminals that distinguish
      local m_alt = m.keymap:gsub("<A%-", "<M%-")
      if m_alt ~= m.keymap then
        map({ "n", "v" }, m_alt, function()
          if dropdown then dropdown.open(idx) end
        end, "Turbo Menu: " .. m.title)
      end
    end
  end

  -- F10 Menu Key
  map({ "n", "v" }, "<F10>", function()
    dropdown.open(1)
  end, "Activate Turbo Top Menu")

  -- Classic Turbo C Function Keys
  map({ "n", "v" }, "<F1>", function() vim.cmd("help") end, "Turbo Help")
  map({ "n", "v" }, "<F2>", function() vim.cmd("write") end, "Turbo Save File")
  map({ "n", "v" }, "<F3>", function() layout.open_file_dialog() end, "Turbo Open File")
  map({ "n", "v" }, "<A-F3>", function() vim.cmd("close") end, "Turbo Close Window")
  map({ "n", "v" }, "<M-F3>", function() vim.cmd("close") end, "Turbo Close Window")
  map({ "n", "v" }, "<F5>", function() layout.toggle_zoom() end, "Turbo Zoom Window")
  map({ "n", "v" }, "<F6>", function() vim.cmd("wincmd w") end, "Turbo Next Window")
  map({ "n", "v" }, "<F9>", function() compiler.make_project() end, "Turbo Make Project")
  map({ "n", "v" }, "<A-F9>", function() compiler.compile_file() end, "Turbo Compile File")
  map({ "n", "v" }, "<M-F9>", function() compiler.compile_file() end, "Turbo Compile File")
  map({ "n", "v" }, "<C-F9>", function() compiler.run_current() end, "Turbo Run Current")
  map({ "n", "v" }, "<A-x>", function() vim.cmd("confirm qall") end, "Turbo Exit")
  map({ "n", "v" }, "<M-x>", function() vim.cmd("confirm qall") end, "Turbo Exit")

  -- Window resize handler
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      vim.cmd("redrawtabline")
      vim.cmd("redrawstatus")
    end,
  })

  -- User commands
  vim.api.nvim_create_user_command("TurboTheme", function(args)
    theme.set_theme(args.args)
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(theme.themes)
    end,
  })

  vim.api.nvim_create_user_command("TurboAbout", function()
    layout.show_about_dialog()
  end, {})

  vim.api.nvim_create_user_command("TurboCompile", function()
    compiler.compile_file()
  end, {})

  vim.api.nvim_create_user_command("TurboMake", function()
    compiler.make_project()
  end, {})

  vim.api.nvim_create_user_command("TurboRun", function()
    compiler.run_current()
  end, {})

  -- Initialize plugin manager in background
  pcall(function()
    require("turbo.plugins").setup()
  end)
end

return M
