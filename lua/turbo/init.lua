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

local target_tabline = "%!v:lua.require('turbo.ui.menubar').render()"

function M.setup(opts)
  opts = opts or {}
  M.opts = vim.tbl_deep_extend("force", {
    theme = nil,                  -- nil = respect user's active colorscheme without imposing themes!
    enable_tabline = true,        -- Top nostalgic menubar (Row 0)
    enable_winbar = true,         -- Buffer tabs below menubar (Row 1)
    enable_statusline = true,     -- Bottom Borland statusline
    enable_keymaps = true,        -- Alt+<Key> accelerators and F1-F10 keys
    enable_lazy_keys = false,     -- Off by default for existing setups so it won't conflict with host leader keys
    enable_mouse = nil,           -- nil means preserve user's existing vim.opt.mouse
  }, opts)

  -- Adapt to user's active colorscheme (or apply explicit theme if requested)
  if M.opts.theme then
    theme.set_theme(M.opts.theme)
  else
    theme.adapt_user_colorscheme()
  end

  -- Listen for colorscheme changes so Turbo adapts dynamically to whatever colorscheme the user selects
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      if not M.opts.theme then
        theme.adapt_user_colorscheme()
      end
    end,
  })

  -- Only setup core lazy keymaps if explicitly requested (e.g. standalone mode)
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
    if args.args == "auto" or args.args == "default" or #args.args == 0 then
      M.opts.theme = nil
      theme.adapt_user_colorscheme()
      vim.notify("Turbo UI adapted to active colorscheme", vim.log.levels.INFO)
    else
      theme.set_theme(args.args)
    end
  end, {
    nargs = "?",
    complete = function()
      local list = vim.tbl_keys(theme.themes)
      table.insert(list, "auto")
      return list
    end,
    desc = "Switch Turbo UI theme or adapt to colorscheme (auto)",
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

  -- Function to strictly enforce menubar visibility regardless of Snacks or bufferline toggles
  local function enforce_menubar()
    if M.enabled and (M.opts.enable_tabline ~= false) then
      if vim.o.showtabline ~= 2 then
        vim.o.showtabline = 2
      end
      if vim.o.tabline ~= target_tabline then
        vim.o.tabline = target_tabline
      end
    end
  end

  -- Top Menubar (Row 0)
  if opts.enable_tabline ~= false then
    enforce_menubar()

    local group = vim.api.nvim_create_augroup("TurboTablineGuard", { clear = true })
    vim.api.nvim_create_autocmd({
      "VimEnter",
      "UIEnter",
      "BufEnter",
      "BufWinEnter",
      "WinEnter",
      "TabEnter",
      "BufReadPost",
      "BufNewFile",
    }, {
      group = group,
      callback = function()
        enforce_menubar()
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = { "VeryLazy", "SnacksDashboardOpened", "SnacksDashboardClosed" },
      group = group,
      callback = function()
        vim.schedule(function()
          enforce_menubar()
          vim.cmd("redrawtabline")
        end)
      end,
    })

    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = { "tabline", "showtabline" },
      group = group,
      callback = function()
        if M.enabled and (M.opts.enable_tabline ~= false) then
          vim.schedule(function()
            enforce_menubar()
            vim.cmd("redrawtabline")
          end)
        end
      end,
    })
  end

  -- Row 1: Buffer tabs / frame below the menubar
  if opts.enable_winbar ~= false then
    vim.o.winbar = "%!v:lua.require('turbo.layout').render_winbar()"
  end

  -- Bottom Statusline
  if opts.enable_statusline ~= false then
    vim.o.laststatus = 3
    vim.o.statusline = "%!v:lua.require('turbo.ui.statusline').render()"
  end

  if opts.enable_mouse ~= nil then
    vim.o.mouse = opts.enable_mouse and "a" or ""
  end

  -- Borland Keymaps (Alt+<Key> and F1-F10)
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

  -- Clear tabline guard augroup
  pcall(vim.api.nvim_del_augroup_by_name, "TurboTablineGuard")

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
