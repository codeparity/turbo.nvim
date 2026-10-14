-- Core lazy-nvim / LazyVim standard keymaps with <Space> as leader

local layout = require("turbo.layout")
local compiler = require("turbo.compiler")

local M = {}

function M.setup()
  -- Ensure leader is space
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  local function map(modes, lhs, rhs, desc)
    vim.keymap.set(modes, lhs, rhs, { silent = true, desc = desc })
  end

  -- Better window navigation (lazy-nvim default)
  map("n", "<C-h>", "<C-w>h", "Go to Left Window")
  map("n", "<C-j>", "<C-w>j", "Go to Lower Window")
  map("n", "<C-k>", "<C-w>k", "Go to Upper Window")
  map("n", "<C-l>", "<C-w>l", "Go to Right Window")

  -- Resize window using <ctrl> arrow keys (lazy-nvim default)
  map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase Window Height")
  map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease Window Height")
  map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease Window Width")
  map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase Window Width")

  -- Move lines in visual mode (lazy-nvim default)
  map("v", "J", ":m '>+1<cr>gv=gv", "Move Down")
  map("v", "K", ":m '<-2<cr>gv=gv", "Move Up")

  -- Keep visual selection when indenting (lazy-nvim default)
  map("v", "<", "<gv", "Indent Left")
  map("v", ">", ">gv", "Indent Right")

  -- Buffers navigation (lazy-nvim default)
  map("n", "<S-h>", "<cmd>bprevious<cr>", "Prev Buffer")
  map("n", "<S-l>", "<cmd>bnext<cr>", "Next Buffer")
  map("n", "[b", "<cmd>bprevious<cr>", "Prev Buffer")
  map("n", "]b", "<cmd>bnext<cr>", "Next Buffer")
  map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete Buffer")
  map("n", "<leader>bb", "<cmd>buffers<cr>", "List Buffers")

  -- Files (<leader>f)
  map("n", "<leader>fn", "<cmd>enew<cr>", "New File")
  map("n", "<leader>fs", "<cmd>write<cr>", "Save File")
  map("n", "<leader>w", "<cmd>write<cr>", "Save File")
  map("n", "<leader>ff", function() layout.open_file_browser() end, "Find Files / File Browser (F3)")
  map("n", "<leader>fg", function()
    vim.ui.input({ prompt = "Grep: " }, function(input)
      if input and #input > 0 then
        vim.cmd("silent grep! " .. vim.fn.fnameescape(input))
        vim.cmd("copen")
      end
    end)
  end, "Live Grep")
  map("n", "<leader>/", function()
    vim.api.nvim_feedkeys("/", "n", false)
  end, "Search in File")
  map("n", "<leader>e", function() layout.open_dir_explorer() end, "File Explorer")
  map("n", "<leader>fe", function() layout.open_dir_explorer() end, "File Explorer")

  -- Package Management
  map("n", "<leader>l", "<cmd>Lazy<cr>", "Open Lazy")
  map("n", "<leader>L", "<cmd>Lazy<cr>", "Open Lazy")
  map("n", "<leader>m", "<cmd>Mason<cr>", "Open Mason")
  map("n", "<leader>cm", "<cmd>Mason<cr>", "Open Mason")

  -- Quit & Windows (<leader>q / <leader>w)
  map("n", "<leader>qq", "<cmd>confirm qall<cr>", "Quit All")
  map("n", "<leader>q", "<cmd>close<cr>", "Close Window")
  map("n", "<leader>wd", "<cmd>close<cr>", "Delete Window")
  map("n", "<leader>wm", function() layout.toggle_zoom() end, "Toggle Maximize Window")
  map("n", "<leader>ww", "<cmd>wincmd w<cr>", "Next Window")
  map("n", "<leader>ws", "<cmd>split<cr>", "Split Horizontal")
  map("n", "<leader>wv", "<cmd>vsplit<cr>", "Split Vertical")
  map("n", "<leader>-", "<cmd>split<cr>", "Split Horizontal")
  map("n", "<leader>|", "<cmd>vsplit<cr>", "Split Vertical")

  -- LSP & Diagnostics
  map("n", "gd", function() vim.lsp.buf.definition() end, "Goto Definition")
  map("n", "gD", function() vim.lsp.buf.declaration() end, "Goto Declaration")
  map("n", "gr", function() vim.lsp.buf.references() end, "Goto References")
  map("n", "K", function() vim.lsp.buf.hover() end, "Hover Documentation")
  map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, "Code Action")
  map("n", "<leader>cr", function() vim.lsp.buf.rename() end, "Rename Symbol")
  map("n", "<leader>cd", function() vim.lsp.buf.definition() end, "Goto Definition")
  map("n", "<leader>xx", function() compiler.toggle_message_win() end, "Toggle Diagnostics / Message Window")
  map("n", "[d", function() vim.diagnostic.goto_prev() end, "Prev Diagnostic")
  map("n", "]d", function() vim.diagnostic.goto_next() end, "Next Diagnostic")

  -- UI & Themes (<leader>u)
  map("n", "<leader>uC", function() layout.open_theme_selector() end, "Colors / Themes")
  map("n", "<leader>th", function() layout.open_theme_selector() end, "Colors / Themes")
  map("n", "<leader>un", function() vim.wo.number = not vim.wo.number end, "Toggle Line Numbers")
  map("n", "<leader>ur", function() vim.wo.relativenumber = not vim.wo.relativenumber end, "Toggle Relative Numbers")
  map("n", "<leader>uw", function() vim.wo.wrap = not vim.wo.wrap end, "Toggle Wrap")

  -- Clear search highlight on ESC (lazy-nvim default)
  map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", "Escape and Clear hlsearch")
end

return M
