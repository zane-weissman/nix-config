-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local send_normal = function(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end
local cmd = function(name)
  return function()
    vim.cmd(name)
  end
end

-- ctrl-c = escape always
map("", "<C-c>", "<Esc>")
-- when in visual selection mode, use s like c
map("v", "s", "c", { desc = "Change selection", remap = true }) -- remap not needed?
-- in normal mode s = change char
map("n", "s", "cl", { desc = "Change character", remap = true }) -- remap not needed?

map("n", "<leader>n", cmd("noh"), { desc = "Clear highlight" })

-- write all open buffers, open lazygit, add all, commit
map("n", "<leader>g<leader>", ":wa<cr><space>ggac", { desc = "Quick add and commit", remap = true })

-- more vim-like tab maps
map("n", "<leader><tab>g", cmd("tabfirst"), { desc = "First tab" })
map("n", "<leader><tab>G", cmd("tablast"), { desc = "Last tab" })
map("n", "<leader><tab>j", cmd("tabnext"), { desc = "Next tab" })
map("n", "<leader><tab>k", cmd("tabNext"), { desc = "Previous tab" })
map("n", "<leader>j", cmd("tabnext"), { desc = "Next tab" })
map("n", "<leader>k", cmd("tabNext"), { desc = "Previous tab" })

-- misc saved macros
local wk = require("which-key")
wk.add({ { "<leader>m", group = "Saved macros" } })

-- splitAttrSet: going from
-- foo.bar = baz; to
-- foo = {
--   bar = baz;
--   |   # <-- your cursor here
-- }
-- or,
-- foo.bar = {
--   baz = enable;
-- };
-- to
-- foo = {
--   bar = {
--     baz = enable;
--   };
--   |   # <- your cursor here
-- };
-- works with [], (), but not function definitions or strings enclosed in ''
local splitAttrSet = function()
  -- if char under cursors is not '.', seek backwards for .
  local _, col = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local char = line[col]
  -- if not hovering over a ., break at the last . in the line
  if char ~= "." then
    send_normal("$F.")
  end
  -- substitute . with " = {" and line break
  send_normal("s = {<cr><Esc>")
  -- if original line contained "{" (or "["), skip ahead to matching "}" and fix indent
  if string.find(line, "{") or string.find(line, "%[") or string.find(line, "%(") then
    send_normal("%V%j><Esc>k%")
  end
  -- closing }; and start writing to above line
  send_normal("o};<Esc>O")
end
map(
  "n",
  "<leader>mx",
  splitAttrSet,
  --"s = {<cr><Esc>%o};<Esc>O",
  { desc = "Split Nix attribute set" }
)

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
