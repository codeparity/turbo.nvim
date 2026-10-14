local M = {}

M.items = {
  {
    title = "File",
    mnemonic = "F",
    keymap = "<A-f>",
    entries = {
      { label = "New", mnemonic = "N", desc = "Create a new file in an edit window", action = function() vim.cmd("enew") end },
      { label = "Open...", mnemonic = "O", shortcut = "F3", desc = "Open an existing file", action = function() require("turbo.layout").open_file_dialog() end },
      { label = "Save", mnemonic = "S", shortcut = "F2", desc = "Save the current file", action = function() vim.cmd("write") end },
      { label = "Save as...", mnemonic = "A", desc = "Save the file under a new name", action = function() vim.ui.input({ prompt = "Save as: " }, function(input) if input and #input > 0 then vim.cmd("write " .. vim.fn.fnameescape(input)) end end) end },
      { label = "Save all", mnemonic = "L", desc = "Save all modified files", action = function() vim.cmd("wall") end },
      { separator = true },
      { label = "Print", mnemonic = "P", desc = "Print the active window", action = function() vim.cmd("hardcopy") end },
      { separator = true },
      { label = "Exit", mnemonic = "x", shortcut = "Alt-X", desc = "Exit Turbo IDE", action = function() vim.cmd("confirm qall") end },
    },
  },
  {
    title = "Edit",
    mnemonic = "E",
    keymap = "<A-e>",
    entries = {
      { label = "Undo", mnemonic = "U", shortcut = "Alt-BkSp", desc = "Undo the last editing change", action = function() vim.cmd("undo") end },
      { label = "Redo", mnemonic = "R", desc = "Redo the last undone change", action = function() vim.cmd("redo") end },
      { separator = true },
      { label = "Cut", mnemonic = "t", shortcut = "Shift-Del", desc = "Cut selection to clipboard", action = function() vim.cmd('normal! "+x') end },
      { label = "Copy", mnemonic = "C", shortcut = "Ctrl-Ins", desc = "Copy selection to clipboard", action = function() vim.cmd('normal! "+y') end },
      { label = "Paste", mnemonic = "P", shortcut = "Shift-Ins", desc = "Paste from clipboard", action = function() vim.cmd('normal! "+p') end },
      { label = "Clear", mnemonic = "e", desc = "Delete selected text without copying", action = function() vim.cmd('normal! "_d') end },
    },
  },
  {
    title = "Search",
    mnemonic = "S",
    keymap = "<A-s>",
    entries = {
      { label = "Find...", mnemonic = "F", shortcut = "/", desc = "Search for text in file", action = function()
        vim.api.nvim_feedkeys("/", "n", false)
      end },
      { label = "Replace...", mnemonic = "R", desc = "Search and replace text", action = function()
        vim.ui.input({ prompt = "Search for: " }, function(search)
          if search and #search > 0 then
            vim.ui.input({ prompt = "Replace with: " }, function(repl)
              if repl then
                vim.cmd(string.format("%%s/%s/%s/gc", search, repl))
              end
            end)
          end
        end)
      end },
      { label = "Search in files...", mnemonic = "i", desc = "Search text across all project files", action = function()
        vim.ui.input({ prompt = "Live Grep: " }, function(input)
          if input and #input > 0 then
            vim.cmd("silent grep! " .. vim.fn.fnameescape(input))
            vim.cmd("copen")
          end
        end)
      end },
      { separator = true },
      { label = "Go to Definition", mnemonic = "D", shortcut = "gd", desc = "Jump to symbol definition (LSP)", action = function()
        vim.lsp.buf.definition()
      end },
      { label = "Find Symbols...", mnemonic = "S", desc = "Find symbols in current document", action = function()
        vim.lsp.buf.document_symbol()
      end },
    },
  },
  {
    title = "Run",
    mnemonic = "R",
    keymap = "<A-r>",
    entries = {
      { label = "Run", mnemonic = "R", shortcut = "Ctrl-F9", desc = "Build and run the current program", action = function()
        require("turbo.compiler").run_current()
      end },
      { label = "Program reset", mnemonic = "P", desc = "Reset running process / debugger", action = function()
        vim.notify("Program state reset", vim.log.levels.INFO)
      end },
      { label = "Go to cursor", mnemonic = "G", desc = "Run program to cursor position", action = function()
        vim.notify("Run to cursor executed", vim.log.levels.INFO)
      end },
    },
  },
  {
    title = "Compile",
    mnemonic = "C",
    keymap = "<A-c>",
    entries = {
      { label = "Compile", mnemonic = "C", shortcut = "Alt-F9", desc = "Compile file in current window to object", action = function()
        require("turbo.compiler").compile_file()
      end },
      { label = "Make", mnemonic = "M", shortcut = "F9", desc = "Build project executable via Makefile/compiler", action = function()
        require("turbo.compiler").make_project()
      end },
      { label = "Build all", mnemonic = "B", desc = "Rebuild all source files", action = function()
        require("turbo.compiler").build_all()
      end },
      { separator = true },
      { label = "Message window", mnemonic = "e", desc = "Toggle compiler message and diagnostic pane", action = function()
        require("turbo.compiler").toggle_message_win()
      end },
    },
  },
  {
    title = "Debug",
    mnemonic = "D",
    keymap = "<A-d>",
    entries = {
      { label = "Toggle Breakpoint", mnemonic = "T", desc = "Set or clear breakpoint at cursor", action = function()
        pcall(function() require("dap").toggle_breakpoint() end)
        vim.notify("Breakpoint toggled", vim.log.levels.INFO)
      end },
      { label = "Step over", mnemonic = "o", shortcut = "F8", desc = "Execute next statement without tracing calls", action = function()
        pcall(function() require("dap").step_over() end)
      end },
      { label = "Trace into", mnemonic = "r", shortcut = "F7", desc = "Trace execution into functions", action = function()
        pcall(function() require("dap").step_into() end)
      end },
      { label = "Evaluate expression", mnemonic = "E", desc = "Evaluate variable or expression at cursor", action = function()
        pcall(function() require("dapui").eval() end)
      end },
    },
  },
  {
    title = "Project",
    mnemonic = "P",
    keymap = "<A-p>",
    entries = {
      { label = "Directory / Tree", mnemonic = "D", desc = "Open DOS file directory tree", action = function()
        require("turbo.layout").open_dir_explorer()
      end },
      { label = "Open project...", mnemonic = "O", desc = "Load an existing project workspace", action = function()
        vim.ui.input({ prompt = "Open project dir: ", completion = "dir" }, function(dir)
          if dir and #dir > 0 then vim.cmd("cd " .. vim.fn.fnameescape(dir)) end
        end)
      end },
      { label = "Close project", mnemonic = "C", desc = "Close project files", action = function()
        vim.cmd("%bd")
      end },
    },
  },
  {
    title = "Options",
    mnemonic = "O",
    keymap = "<A-o>",
    entries = {
      { label = "Colors / Themes...", mnemonic = "C", desc = "Choose visual theme (Gruvbox, Borland, Monokai, Mocha)", action = function()
        require("turbo.layout").open_theme_selector()
      end },
      { separator = true },
      { label = "Plugins (Lazy)", mnemonic = "P", desc = "Manage and update plugins via lazy.nvim", action = function()
        pcall(vim.cmd, "Lazy")
      end },
      { label = "Tooling (Mason)", mnemonic = "T", desc = "Manage LSP servers, linters, debuggers via Mason", action = function()
        pcall(vim.cmd, "Mason")
      end },
      { separator = true },
      { label = "Toggle Line Numbers", mnemonic = "L", desc = "Toggle line numbers on/off", action = function()
        vim.wo.number = not vim.wo.number
      end },
      { label = "Toggle Wrap", mnemonic = "W", desc = "Toggle line wrapping", action = function()
        vim.wo.wrap = not vim.wo.wrap
      end },
    },
  },
  {
    title = "Window",
    mnemonic = "W",
    keymap = "<A-w>",
    entries = {
      { label = "Tile", mnemonic = "T", desc = "Tile all open edit windows equally", action = function()
        vim.cmd("wincmd =")
      end },
      { label = "Message", mnemonic = "M", desc = "Show / Hide compiler message window", action = function()
        require("turbo.compiler").toggle_message_win()
      end },
      { label = "Zoom", mnemonic = "Z", shortcut = "F5", desc = "Maximize / restore active window", action = function()
        require("turbo.layout").toggle_zoom()
      end },
      { label = "Next", mnemonic = "N", shortcut = "F6", desc = "Switch to next window", action = function()
        vim.cmd("wincmd w")
      end },
      { label = "Close", mnemonic = "C", shortcut = "Alt-F3", desc = "Close the current active window", action = function()
        vim.cmd("close")
      end },
    },
  },
  {
    title = "Help",
    mnemonic = "H",
    keymap = "<A-h>",
    entries = {
      { label = "Help Index", mnemonic = "I", shortcut = "F1", desc = "Open Neovim documentation help index", action = function()
        vim.cmd("help")
      end },
      { label = "Topic search...", mnemonic = "T", desc = "Search help topic", action = function()
        vim.ui.input({ prompt = "Help on: " }, function(h)
          if h and #h > 0 then vim.cmd("help " .. h) end
        end)
      end },
      { separator = true },
      { label = "About Turbo IDE...", mnemonic = "A", desc = "Display Borland / Turbo C++ 3.0 credits & version", action = function()
        require("turbo.layout").show_about_dialog()
      end },
    },
  },
}

return M
