-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- ctrl-c = escape always
map("", "<C-c>", "<Esc>")
-- when in visual selection mode, use s like c
map("v", "s", "c", { desc = "Change selection", remap = true }) -- remap not needed?
-- in normal mode s = change char
map("n", "s", "cl", { desc = "Change character", remap = true }) -- remap not needed?

map("n", "<leader>n", vim.cmd("noh"), { desc = "Clear highlight" })

-- write all open buffers, open lazygit, add all, commit
map("n", "<leader>g<leader>", ":wa<cr><space>ggac", { desc = "Quick add and commit", remap = true })

-- more vim-like tab maps
map("n", "<leader><tab>g", vim.cmd("tabfirst"), { desc = "First tab" })
map("n", "<leader><tab>G", vim.cmd("tablast"), { desc = "Last tab" })
map("n", "<leader><tab>j", vim.cmd("tabnext"), { desc = "Next tab" })
map("n", "<leader><tab>k", vim.cmd("tabNext"), { desc = "Previous tab" })
map("n", "<leader>j", vim.cmd("tabnext"), { desc = "Next tab" })
map("n", "<leader>k", vim.cmd("tabNext"), { desc = "Previous tab" })

-- misc saved macros
local wk = require("which-key")
wk.add({ { "<leader>m", group = "Saved macros" } })
map("n", "<leader>mx", "s = {<cr><Esc>%o};<Esc>O", { desc = "Split Nix attribute set" })

-- extra telescope mappings
local telescope = require("telescope.builtin")
-- find highlights in Telescope
map("n", "<leader>fh", telescope.highlights, { desc = "Browse highlight groups" })
-- <leader><shift+,> to list recent files (not just buffers)
map("n", "<leader><", telescope.oldfiles, { desc = "Open recent files" })

-- swap j/gj, k/gk
map("n", "j", "gj")
map("n", "gj", "j")
map("n", "k", "gk")
map("n", "gk", "k")
