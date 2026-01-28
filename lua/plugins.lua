
--return {
  -- ... other plugins ...
  --{ "neovim/nvim-lspconfig" },
  -- Optional: For easier installation of language servers
  --{ "williamboman/mason.nvim" },
  --{ "williamboman/mason-lspconfig.nvim" },
  -- Optional: For completion
  --{ "hrsh7th/nvim-cmp" },
  -- ...
--}
-- Example config, adjust based on your specific setup
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",     -- buffer completions
    "hrsh7th/cmp-path",       -- path completions
    "hrsh7th/cmp-nvim-lsp",   -- LSP source
    "L3MON4D3/LuaSnip",       -- snippet engine
    "saadparwaiz1/cmp_luasnip", -- snippet source for cmp
  },
  config = fundtion()
    -- Set up nvim-cmp
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cdd.setup({
      snippet = {
        expand = function(args)
          luasnip.expand(args.body) -- expands snippets
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- manually trigger completion
        ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- accept currently selected item
        ["<C-n>"] = cmp.mapping.select_next_item(), -- navigate next
        ["<C-p>"] = cmp.mapping.select_prev_item(), -- navigate previous
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      })
    })
  end
}

-- Set up lspconfig for clangd
local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = { "clangd", "--header-insertion=never" }, -- Recommended flag to avoid auto-include issues
})

lspconfig.zls.setup({
    -- If zls is not in your PATH, provide the full path here:
    -- cmd = { "/path/to/your/zls" },
    filetypes = { "zig", "zon" },
    root_dir = lspconfig.util.root_pattern("zls.json", "build.zig", ".git"),
})
