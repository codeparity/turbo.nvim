-- Entrypoint for Turbo IDE (isolated sandboxed Neovim configuration)

local current_file = debug.getinfo(1, "S").source:sub(2)
local config_root = vim.fn.fnamemodify(current_file, ":p:h")

-- Add local lua directory to package path
local lua_dir = config_root .. "/lua"
package.path = lua_dir .. "/?.lua;" .. lua_dir .. "/?/init.lua;" .. package.path

-- Basic Neovim Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = false
vim.o.cursorline = true
vim.o.hidden = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.shortmess = "filnxtToOFI"

-- Initialize Turbo IDE
local turbo = require("turbo")
turbo.setup({
  theme = "gruvbox", -- Default theme: Gruvbox Dark (can switch to 'borland', 'monokai', 'mocha')
})

-- Welcome sample buffer if launched with no arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line2byte(vim.fn.line("$") + 1) <= 2 then
      local sample = {
        "/*",
        " *  TURBO C++ 3.0 IDE",
        " *  File: NONAME00.CPP",
        " *",
        " *  Hotkeys:",
        " *    Alt+F / F10 : File Menu (Alt+E Edit, Alt+S Search, Alt+C Compile, etc.)",
        " *    F1          : Help Index",
        " *    F2          : Save File",
        " *    F3          : Open File Dialog",
        " *    F5          : Zoom / Maximize Window",
        " *    F6          : Next Window",
        " *    F9          : Make Project",
        " *    Alt+F9      : Compile Current File",
        " *    Ctrl+F9     : Run Program",
        " *    Alt+X       : Exit",
        " *",
        " *  Themes:",
        " *    Select 'Options -> Colors' to switch between Gruvbox, Borland DOS Blue, Monokai, Mocha",
        " */",
        "",
        "#include <stdio.h>",
        "",
        "int main(void) {",
        '    printf("Hello from Turbo C++ 3.0 in Neovim!\\n");',
        "    return 0;",
        "}",
      }
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, sample)
      vim.bo[buf].filetype = "cpp"
      vim.api.nvim_buf_set_name(buf, "NONAME00.CPP")
      vim.bo[buf].modified = false
    end
  end,
})
