-- ~/.config/nvim/lua/lazy.lua

-- Verifique se lazy.nvim está instalado; senão, instale-o
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- versão estável mais recente
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Função para carregar plugins de um diretório
local function load_plugins(path)
  local plugins = {}
  local plugin_files = vim.fn.globpath(path, '*.lua', false, true)
  for _, file in ipairs(plugin_files) do
    -- print("Loading plugin: " .. file) -- Linha para depuração
    local plugin = dofile(file)
    if type(plugin) == 'table' then
      table.insert(plugins, plugin)
    else
      print("Invalid plugin specification in: " .. file)
    end
  end
  return plugins
end

-- Diretórios de plugins
local default_plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins'
local custom_plugins_dir = vim.fn.stdpath('config') .. '/setup/plugins'

-- Carregue os plugins de cada diretório
local default_plugins_loaded = load_plugins(default_plugins_dir)
local custom_plugins_loaded = load_plugins(custom_plugins_dir)

-- Combine os plugins carregados em uma única tabela
local plugins_combined = vim.list_extend(default_plugins_loaded, custom_plugins_loaded)

-- Configure lazy.nvim com a tabela combinada de plugins
--print("Configuring lazy.nvim") -- Linha para depuração
require('lazy').setup({
  spec = plugins_combined
})
