local vimgrep_arguments = { unpack(require("telescope.config").values.vimgrep_arguments) }
table.insert(vimgrep_arguments, "--hidden") -- view . files
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/") -- exclude .git
table.insert(vimgrep_arguments, "-L") -- follow symlinks

return {
  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          --["<C-y>"] = "<Esc>0lly$",
          --["<C-p>"] = "<C-r>0",
          ["<C-n>"] = function()
            vim.cmd.edit(require("telescope.actions").state.get_current_line())
          end,
        },
      },
      vimgrep_arguments = vimgrep_arguments,
    },
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "-L" },
      },
    },
  }),
}
