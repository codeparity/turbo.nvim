local M = {}

function M.setup()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    -- Try cloning lazy.nvim if git is available
    local repo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
    if vim.v.shell_error ~= 0 then
      -- Offline mode or clone failed - proceed without lazy
      return
    end
  end
  vim.opt.rtp:prepend(lazypath)

  local ok, lazy = pcall(require, "lazy")
  if not ok then return end

  lazy.setup({
    -- Which-Key (standard in lazy-nvim)
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        preset = "classic",
        win = {
          border = "double",
        },
      },
      config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.add({
          { "<leader>f", group = "file/find" },
          { "<leader>w", group = "windows" },
          { "<leader>q", group = "quit/session" },
          { "<leader>c", group = "code/compile" },
          { "<leader>u", group = "ui/themes" },
          { "<leader>b", group = "buffer" },
        })
      end,
    },
    -- Core Treesitter for syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        pcall(function()
          require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent = { enable = true },
          })
        end)
      end,
    },
    -- LSP & Tooling
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      config = function()
        pcall(function()
          require("mason").setup()
          require("mason-lspconfig").setup({
            ensure_installed = {},
          })
        end)
      end,
    },
  }, {
    root = vim.fn.stdpath("data") .. "/lazy",
    defaults = { lazy = false },
    ui = {
      border = "double",
      title = " Package Manager (Lazy) ",
    },
    performance = {
      rtp = {
        reset = false,
      },
    },
  })
end

return M
