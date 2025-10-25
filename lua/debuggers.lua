local utils = require('utils')

-- Configuração do DAP
return {
  -- Dependências móveis para a configuração de depuradores
  debuggers = {
    {
      'microsoft/vscode-js-debug',
      version = '1.x',
      build = 'npm i && npm run compile vsDebugServerBundle && mv dist out',
    },
    { 
      "mxsdev/nvim-dap-vscode-js",
      config = function()
        require("dap-vscode-js").setup({
          debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
          adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        })
      end
    },
    -- Adicione outros plugins aqui
  },

  -- Configurações de depuração por linguagem
  languages = {
    javascript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "JS Launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
        protocol = "https",
        port = 3000,
        hostname = "192.168.18.22",
        webRoot = "${workspaceFolder}",
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'JS Attach',
        processId = utils.get_process_id('ps -ax | grep node | grep -v grep'),
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = 9229, -- Porta do modo de inspeção do Node.js
        restart = true,
        outFiles = { "${workspaceFolder}/dist/**/*.js" }
      }
    },
    typescript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "TS Launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        protocol = "https",
        port = 3000,
        hostname = "192.168.18.22",
        webRoot = "${workspaceFolder}",
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'TS Attach',
        processId = utils.get_process_id('ps -ax | grep node | grep -v grep'),
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = 9229, -- Porta do modo de inspeção do Node.js
        restart = true,
        outFiles = { "${workspaceFolder}/dist/**/*.js" }
      }
    },
    python = {
      {
        type = "python",
        request = "launch",
        name = "Launch Python File",
        program = "${file}",
        console = "integratedTerminal",
      }
    }
    -- Adicione outras linguagens e configurações aqui
  },

  -- Configurações de ícones
  signs = {
    DapBreakpoint = { text = '🟥', texthl = 'DiagnosticError', linehl = '', numhl = '' },
    DapStopped = { text = '▶️', texthl = 'DiagnosticInfo', linehl = '', numhl = '' },
  },

  -- Configurações de keymaps
  keymaps = {
    n = {  -- Modo normal
      ["<F5>"] = { rhs = ":lua require('dap_ui').select_dap_config()<CR>", desc = "Select and start debugging" },
      ["<F10>"] = { rhs = "<cmd>lua require'dap'.step_over()<CR>", desc = "Step over" },
      ["<F11>"] = { rhs = "<cmd>lua require'dap'.step_into()<CR>", desc = "Step into" },
      ["<F12>"] = { rhs = "<cmd>lua require'dap'.step_out()<CR>", desc = "Step out" },
      ["<Leader>dtb"] = { rhs = "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
      ["<Leader>dro"] = { rhs = "<cmd>lua require'dap'.repl.open()<CR>", desc = "Open REPL" },
      ["<Leader>drl"] = { rhs = "<cmd>lua require'dap'.run_last()<CR>", desc = "Run last" },
      ["<Leader>dsb"] = { rhs = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", desc = "Set conditional breakpoint" },
      ["<Leader>dp"] = { rhs = "<cmd>lua require'dap'.pause()<CR>", desc = "Pause" },
      ["<Leader>df"] = { rhs = "<cmd>lua require'dap'.terminate()<CR>", desc = "Terminate" },
    }
  },
}

