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
    defaults = { lazy = true },
    ui = {
      border = "double",
      title = " Turbo C++ Package Manager (Lazy) ",
    },
    performance = {
      rtp = {
        reset = false,
      },
    },
  })
end

return M
