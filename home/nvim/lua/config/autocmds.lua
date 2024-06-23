-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

--augroup numbertoggle
--  autocmd!
--  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
--  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
--augroup end

--local autocmd = require("vim.api").nvim_create_autocmd()
--local augroup = require("vim.api").nvim_create_augroup()
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
------ my attempt -----------
---vim.api.nvim_create_autocmd(
---  { "BufEnter", "FocusGained", "InsertLeave" },
---  { group = numbertoggle, command = "set relativenumber" }
---)
---vim.api.nvim_create_autocmd(
---  { "BufLeave", "FocusLost", "InsertEnter" },
---  { group = numbertoggle, command = "set norelativenumber" }
---)
------- https://github.com/sitiom/nvim-numbertoggle/blob/main/plugin/numbertoggle.lua ----
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd("redraw")
    end
  end,
})
