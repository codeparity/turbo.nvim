local theme = require("turbo.theme")
local menubar = require("turbo.ui.menubar")
local dropdown = require("turbo.ui.dropdown")
local statusline = require("turbo.ui.statusline")
local layout = require("turbo.layout")
local compiler = require("turbo.compiler")
local menus = require("turbo.menus")
local keymaps = require("turbo.keymaps")
local state = require("turbo.state")

local M = {}

M.orig_settings = {}
M.enabled = false

function M.setup(opts)
  opts = opts or {}
  M.opts = vim.tbl_deep_extend("force", {
    theme = "gruvbox",            -- "gruvbox" | "borland" | "monokai" | "mocha"
    enable_tabline = true,        -- Top nostalgic menubar
    enable_statusline = true,     -- Bottom Borland statusline
    enable_winbar = true,         -- Double-line ASCII window headers
    enable_keymaps = true,        -- Alt+<Key> accelerators and F1-F10 keys
    enable_lazy_keys = true,      -- Core lazy-nvim keymaps (<leader> = <Space>)
    enable_mouse = true,          -- Mouse clicking on menus & headers
  }, opts)

  -- Initialize Theme
  theme.set_theme(M.opts.theme)

  -- Setup keymaps
  if M.opts.enable_lazy_keys then
    keymaps.setup()
  end

  M.enable()

  -- Register user commands
  vim.api.nvim_create_user_command("TurboToggle", function()
    M.toggle()
  end, { desc = "Toggle Turbo Nostalgia UI on/off" })

  vim.api.nvim_create_user_command("TurboEnable", function()
    M.enable()
  end, { desc = "Enable Turbo Nostalgia UI" })

  vim.api.nvim_create_user_command("TurboDisable", function()
    M.disable()
  end, { desc = "Disable Turbo Nostalgia UI" })

  vim.api.nvim_create_user_command("TurboTheme", function(args)
    theme.set_theme(args.args)
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(theme.themes)
    end,
    desc = "Switch Turbo UI theme",
  })

  vim.api.nvim_create_user_command("TurboAbout", function()
    layout.show_about_dialog()
  end, { desc = "Show Turbo C++ About Dialog" })

  vim.api.nvim_create_user_command("TurboCompile", function()
    compiler.compile_file()
  end, { desc = "Compile current file" })

  vim.api.nvim_create_user_command("TurboMake", function()
    compiler.make_project()
  end, { desc = "Build project via make" })

  vim.api.nvim_create_user_command("TurboRun", function()
    compiler.run_current()
  end, { desc = "Run current program" })

  -- Setup lazy plugins if bootstrapping in standalone mode
  pcall(function()
    require("turbo.plugins").setup()
  end)
end

function M.enable()
  if M.enabled then return end

  -- Save original settings
  M.orig_settings = {
    showtabline = vim.o.showtabline,
    tabline = vim.o.tabline,
    laststatus = vim.o.laststatus,
    statusline = vim.o.statusline,
    winbar = vim.o.winbar,
    mouse = vim.o.mouse,
  }

  local opts = M.opts or {}

  -- Top Menubar
  if opts.enable_tabline ~= false then
    vim.o.showtabline = 2
    vim.o.tabline = "%!v:lua.require('turbo.ui.menubar').render()"
  end

  -- Bottom Statusline
  if opts.enable_statusline ~= false then
    vim.o.laststatus = 3
    vim.o.statusline = "%!v:lua.require('turbo.ui.statusline').render()"
  end

  -- Window headers (winbar)
  if opts.enable_winbar ~= false then
    vim.o.winbar = "%!v:lua.require('turbo.layout').render_winbar()"
  end

  if opts.enable_mouse ~= false then
    vim.o.mouse = "a"
  end

  -- Borland Keymaps
  if opts.enable_keymaps ~= false then
    local map = function(modes, lhs, rhs, desc)
      vim.keymap.set(modes, lhs, rhs, { silent = true, desc = desc })
    end

    -- Alt-key top menu accelerators
    for idx, m in ipairs(menus.items) do
      if m.keymap then
        map({ "n", "v" }, m.keymap, function()
          if dropdown then dropdown.open(idx) end
        end, "Turbo Menu: " .. m.title)

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

    -- Classic Function Keys
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
  end

  M.enabled = true
  vim.cmd("redrawtabline")
  vim.cmd("redrawstatus")
end

function M.disable()
  if not M.enabled then return end

  -- Close any open menu
  dropdown.close()

  -- Restore original settings
  if M.orig_settings.showtabline ~= nil then
    vim.o.showtabline = M.orig_settings.showtabline
  end
  if M.orig_settings.tabline ~= nil then
    vim.o.tabline = M.orig_settings.tabline
  end
  if M.orig_settings.laststatus ~= nil then
    vim.o.laststatus = M.orig_settings.laststatus
  end
  if M.orig_settings.statusline ~= nil then
    vim.o.statusline = M.orig_settings.statusline
  end
  if M.orig_settings.winbar ~= nil then
    vim.o.winbar = M.orig_settings.winbar
  end
  if M.orig_settings.mouse ~= nil then
    vim.o.mouse = M.orig_settings.mouse
  end

  M.enabled = false
  vim.cmd("redrawtabline")
  vim.cmd("redrawstatus")
end

function M.toggle()
  if M.enabled then
    M.disable()
    vim.notify("Turbo Nostalgia UI disabled", vim.log.levels.INFO)
  else
    M.enable()
    vim.notify("Turbo Nostalgia UI enabled", vim.log.levels.INFO)
  end
end

return M
