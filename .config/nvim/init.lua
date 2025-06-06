-- init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    { 
      "catppuccin/nvim",
      lazy = false,
      name = "catppuccin",
      priority = 1000
    },
    { 
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 
      "nvim-treesitter/nvim-treesitter", 
      build = ":TSUpdate" 
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- Treesitter
local config = require("nvim-treesitter.configs")
config.setup({
    ensure_installed = { "lua", "python", "c", "cpp", "glsl", "json", "yaml", "toml", "markdown" },
    highlight = { enable = true },
    indent = { enable = true },
})

-- Color theme
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
