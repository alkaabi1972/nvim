--Btstrap lazy.nvim
vim.opt.number = true
--vim.opt.relativenumber = true
--vim.wo.relativenumber = true
vim.cmd.colorscheme("habamax")
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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
	-- LSP Configuration
  -- Other useful completion sources
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-path"},
  -- Snippet plugin and source (optional but recommended)
  {"L3MON4D3/LuaSnip"},
  {"saadparwaiz1/cmp_luasnip"},
  -- ... other plugins ...
  { "neovim/nvim-lspconfig" },
  -- Optional: For easier installation of language servers
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  -- Optional: For completion
  { "hrsh7th/nvim-cmp" },
  -- ...

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Set up nvim-cmp
local cmp = require('cmp')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- requires luasnip
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger completion
  }),
  --sources = cmp.source.list({
    --{ name = 'nvim_lsp' },
    --{ name = 'luasnip' }, -- requires luasnip
    --{ name = 'buffer' },
    --{ name = 'path' },
  --})
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- Primary source for LSP (clangd) suggestions
    { name = 'buffer' }, -- Source for current buffer words
    { name = 'luasnip' },
    { name = 'path' },
  })
})

-- Set up lspconfig for clangd
local lspconfig = require('lspconfig')


-- Enable the clangd language server

-- In ~/.config/nvim/lua/configs/clangd.lua (or directly in your main lsp setup file)
vim.lsp.config("clangd",{
  cmd = {
    "clangd",
    "--background-index",      -- Enable background indexing
    "--clang-tidy",            -- Enable clang-tidy diagnostics
    "--header-insertion=iwyu", -- Use include-what-you-use style header insertion
    "--completion-style=detailed", -- Detailed completion suggestions
    "--function-arg-placeholders", -- Show placeholders for function arguments
    "--fallback-style=llvm",   -- Use LLVM coding style as a fallback
    "--all-scopes-completion",
  },
  -- Ensures clangd properly handles file paths
  capabilities = {
    offsetEncoding = { "utf-16" }
  },
  -- Additional configuration options can be added here
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
})

