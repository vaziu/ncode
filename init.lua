-- ~/.config/nvim/init.lua

-- Adicione o caminho 'lua' ao runtime path
--vim.cmd('set runtimepath+=~/.config/nvim/lua')

-- Carregue a configuração dos plugins
require('lazy_setup')
require('reset')
require('file_history')
require('lsps')
require('diagnostics')
require('keymaps')
require('autocmds.init')


vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineTab", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineTabSelected", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineTabClose", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineSeparator", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineModified", { bg = "none" })
vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { bg = "none" })
