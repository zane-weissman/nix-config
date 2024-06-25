-------
-- if tab contains a value equal to element, remove that
-- OR
-- if tab contains a table whose first value is element, remove that table
-- OR
-- if cannot find any matches, return null
local icons = require("lazyvim.config").icons
local remove_component = function(tab, element)
  for i, v in ipairs(tab) do
    if v == element or v[1] == element then
      return table.remove(tab, i)
    end
  end
  return {}
end
local my_filetype = { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } }
local my_diagnostics = {
  "diagnostics",
  symbols = {
    error = icons.diagnostics.Error,
    warn = icons.diagnostics.Warn,
    info = icons.diagnostics.Info,
    hint = icons.diagnostics.Hint,
  },
}
local my_diff = {
  "diff",
  symbols = {
    added = icons.git.added,
    modified = icons.git.modified,
    removed = icons.git.removed,
  },
  source = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end,
}
local my_progress = { "progress", separator = " ", padding = { left = 1, right = 0 } }
local my_location = { "location", padding = { left = 0, right = 1 } }
return {
  "nvim-lualine/lualine.nvim",
  -- event = "VeryLazy",
  --requires = "SmiteshP/nvim-navic",

  opts = function()
    -- : we don't need this lualine require madness 🤷
    -- local lualine_require = require("lualine_require")
    -- lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },

      -- winbars

      winbar = {
        lualine_a = {
          my_diagnostics,
        },
        lualine_b = {
          "filename",
        },
        lualine_c = {
          my_filetype,
        },
        lualine_x = {
          my_diff,
        },
        lualine_y = {
          my_progress,
          my_location,
        },
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {
          --my_diagnostics,
        },
        lualine_b = {
          "filename",
        },
        lualine_c = {
          my_filetype,
        },
        lualine_x = {
          my_diff,
        },
        lualine_y = {
          --my_progress,
          --my_location,
        },
        lualine_z = {},
      },
      --- main
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        lualine_c = {
          LazyVim.lualine.root_dir(),
          { LazyVim.lualine.pretty_path() },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = LazyVim.ui.fg("Statement"),
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = LazyVim.ui.fg("Constant"),
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = LazyVim.ui.fg("Debug"),
          },
        },
        lualine_y = {
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = LazyVim.ui.fg("Special"),
          },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
-- {
--   opts = function(_, opts)
--     --local navic = require("nvim-navic")
--
--     -- winbar
--     require("lualine").setup({
--       winbar = {
--         lualine_a = {
--           --table.remove(opts.sections.lualine_c, 3), -- filetype icon
--           remove_component(opts.sections.lualine_c, "filetype"),
--           "filename",
--           remove_component(opts.sections.lualine_c, "diagnostics"), -- diagnostic symbols
--         },
--         lualine_b = {},
--         lualine_c = {},
--         lualine_x = {
--           remove_component(opts.sections.lualine_x, "diff"),
--         },
--         lualine_y = {
--           remove_component(opts.sections.lualine_y, "progress"),
--           remove_component(opts.sections.lualine_y, "location"),
--         },
--         lualine_z = {},
--       },
--       inactive_winbar = {
--         lualine_a = {},
--         lualine_b = {},
--         lualine_c = {},
--         lualine_x = { "filename" },
--         lualine_y = {},
--         lualine_z = {},
--       },
--     })
--
--     --  buffer count/modified icons
--     table.insert(opts.sections.lualine_c, {
--       function()
--         local buf_modified = 0
--         local buf_count = 0
--         local buf_icon = ""
--         local mod_icon = " "
--         local nomod_icon = " "
--         for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--           -- if vim.api.nvim_buf_is_loaded(buf) and
--           if vim.api.nvim_buf_get_option(buf, "buflisted") then
--             buf_count = buf_count + 1
--             if vim.api.nvim_buf_get_option(buf, "modified") then
--               buf_modified = 1
--             end
--           end
--         end
--         if buf_modified == 0 then
--           if buf_count < 2 then
--             return ""
--           else
--             return buf_icon .. tostring(buf_count) .. nomod_icon
--           end
--         else
--           if buf_count < 2 then
--             return mod_icon
--           else
--             return buf_icon .. tostring(buf_count) .. mod_icon
--           end
--         end
--       end,
--
--       color = function()
--         local modified_color = LazyVim.ui.fg("MatchParen")
--         local unmod_color = nil --LazyVim.ui.fg("")
--         for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--           if vim.api.nvim_buf_get_option(buf, "modified") then
--             return modified_color
--           end
--         end
--         return unmod_color
--       end,
--     })
--
--     -- table.insert(opts.sections.lualine_c, {
--     --   function()
--     --     local buf_count
--     --     local buf_modified
--     --     local str = " "
--     --     for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--     --       --if vim.api.nvim_buf_is_loaded(buf) then
--     --       buf_count = buf_count + 1
--     --       if vim.api.nvim_buf_get_option(buf, "modified") then
--     --         buf_modified = 1
--     --         --return "buf modified"
--     --       end
--     --       --end
--     --     end
--     --     if buf_count < 2 and buf_modified == 0 then
--     --       return ""
--     --     end
--     --     if buf_modified == 1 then
--     --       str = str .. "+"
--     --     else
--     --       str = str .. " "
--     --     end
--     --     if buf_count >= 2 then
--     --       str = str .. tostring(buf_count)
--     --     end
--     --     return str
--     --   end,
--     -- })
--     table.insert(opts.sections.lualine_c, function()
--       local buf_count = 0
--       local buf_modified = 0
--       local modified_color = LazyVim.ui.fg("MatchParen")
--       local unmod_color = LazyVim.ui.fg("Bold")
--       local str = nil
--       local retval = {}
--       for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--         if vim.api.nvim_buf_is_loaded(buf) then
--           buf_count = buf_count + 1
--           if vim.api.nvim_buf_get_option(buf, "buf_modified") then
--             buf_modified = 1
--           end
--         end
--       end
--
--       -- exit immediately if only 1 buf and not modified
--       if buf_count == 1 and not buf_modified then
--         return nil
--       end
--
--       if buf_modified then
--         if buf_count > 1 then
--           str = { " +" .. tostring(buf_count) }
--         else
--           str = { "+" }
--         end
--       else
--         str = { "  " .. tostring(buf_count) }
--       end
--
--       retval = {
--         str,
--         color = unmod_color,
--       }
--       -- if not modified return just number in boring color
--       if buf_modified then
--         retval.color = modified_color
--       end
--
--       return retval
--     end)
--   end,
-- }
