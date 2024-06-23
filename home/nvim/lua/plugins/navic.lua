return {}

-- return {
--   "SmiteshP/nvim-navic",
--   requires = "neovim/nvim-lspconfig",
--   opts = function(_, opts)
--     local navic = require("nvim-navic")
--     -- local on_attach = function(client, bufnr)
--     --   if client.server_capabilities.documentSymbolProvider then
--     --     navic.attach(client, bufnr)
--     --   end
--     -- end
--
--     --require("lspconfig").lua_ls.setup({ on_attach = on_attach })
--     require("nvim-navic").setup({
--       lsp = { auto_attach = true },
--     })
--   end,
-- }
