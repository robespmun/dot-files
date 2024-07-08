-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set

map({ "n", "x", "i", "v" }, "<A-CR>", "<cmd>Lspsaga code_action<cr>")
map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<cr>")
