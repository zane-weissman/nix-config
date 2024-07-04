return {
  -- Correctly setup lspconfig for Nix 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        rnix = {},
      },
      settings = {
        rnix = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "alejandra", "nixfmt", "nixpkgs_fmt" },
      },
    },
  },

  --  {
  --    "nvimtools/none-ls.nvim",
  --    opts = function(_, opts)
  --      local nls = require("null-ls")
  --      if type(opts.sources) == "table" then
  --        vim.list_extend(opts.sources, {
  --          nls.builtins.code_actions.statix,
  --          nls.builtins.formatting.alejandra,
  --          nls.builtins.diagnostics.deadnix,
  --        })
  --      end
  --    end,
  --  },
  {
    "calops/hmts.nvim",
    ft = "nix",
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts_)
      opts_.config.center[5] = nil
      opts_.config.center[5] = {
        action = 'lua LazyVim.pick("files", { cwd = "~/nix-config/home/cli/nvim/"}) ()',
        desc = " Config" .. string.rep(" ", 43 - 7),
        icon = " ",
        key = "c",
        key_format = "  %s",
      }
    end,
  },
}
