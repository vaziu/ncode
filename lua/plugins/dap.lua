-- nvim/lua/plugins/dap.lua

-- Função para instalar e configurar plugins de depuração
local function install_debugger_plugins()
  local debuggers_config = require('debuggers')
  local plugins = {}

  -- Iterar pelos depuradores e adicionar à lista de plugins
  for _, debugger in ipairs(debuggers_config.debuggers or {}) do
    table.insert(plugins, debugger)
  end

  -- Retornar a lista de plugins para instalação
  return plugins
end

return {
  -- Plugins fixos que sempre devem ser instalados
  {
    "nvim-neotest/nvim-nio",
    dependencies = { "nvim-neotest/nvim-nio" },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'rcarriga/nvim-dap-ui' },
    config = function()
      local dap = require('dap')
      local dap_ui = require('dapui')
      local debuggers_config = require('debuggers')

      -- Configuração dos adaptadores e depuradores
      if debuggers_config.languages then
        for language, configs in pairs(debuggers_config.languages) do
          dap.configurations[language] = configs
        end
      end

      -- Configuração do dap-ui
      dap_ui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dap_ui.open({ reset = true })
      end
      dap.listeners.before.event_terminated['dapui_config'] = dap_ui.close
      dap.listeners.before.event_exited['dapui_config'] = dap_ui.close

      -- Configura keymaps
      if debuggers_config.keymaps then
        for mode, mappings in pairs(debuggers_config.keymaps) do
          for key, mapping in pairs(mappings) do
            vim.keymap.set(mode, key, mapping.rhs, { noremap = true, silent = true, desc = mapping.desc })
          end
        end
      end

      -- Configura ícones
      -- if debuggers_config.signs then
      --   for name, sign in pairs(debuggers_config.signs) do
      --    vim.fn.sign_define(name, sign)
      -- end
      -- end
    end,
  },

  -- Plugin para gerenciar adaptadores de depuração com Mason
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
    config = function()
      local mason_nvim_dap = require('mason-nvim-dap')
      local debuggers_config = require('debuggers')

      -- Configuração do mason-nvim-dap
      mason_nvim_dap.setup({
        ensure_installed = vim.tbl_map(function(d)
          return d.name
        end, debuggers_config.debuggers or {}),
        automatic_installation = true,
      })

      -- Instalar adaptadores de depuração especificados
      for _, debugger in ipairs(debuggers_config.debuggers or {}) do
        if debugger.name then
          mason_nvim_dap.ensure_installed(debugger.name)
        end
      end
    end,
  },

  -- Adiciona plugins de depuração dinamicamente
  unpack(install_debugger_plugins()),

  -- Aqui você pode adicionar outros plugins fixos ou essenciais se necessário
}
