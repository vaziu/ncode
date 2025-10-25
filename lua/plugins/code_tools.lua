-- ~/.config/nvim/lua/plugins/code_tools.lua

local custom_settings_path = vim.fn.stdpath("config") .. "/settings.lua"
local custom_settings = loadfile(custom_settings_path)() or {}
local default_diagnostics = require("diagnostics")
local default_lsps = require("lsps")
local utils = require("utils")

local lsps_config = vim.deepcopy(default_lsps)
utils.merge_tables(lsps_config, custom_settings.lsps or {})

-- Mescla configurações padrão e do usuário
local diagnostics_config = vim.deepcopy(default_diagnostics)
utils.merge_tables(diagnostics_config, custom_settings.diagnostics or {})

local function apply_config(server, opts)
  -- NÃO use require('lspconfig') aqui; v0.11 recomenda a API nativa:
  -- vim.lsp.config() + vim.lsp.enable()

  local server_opts = lsps_config.settings and lsps_config.settings[server] or {}

  -- 1) mescla configs do servidor com as 'opts' passadas
  local merged_opts = vim.deepcopy(server_opts)
  utils.merge_tables(merged_opts, opts or {})

  -- 2) capabilities (ex.: cmp + foldingRange para nvim-ufo)
  local capabilities
  local ok_cmp, cmp_caps = pcall(function()
    return require("cmp_nvim_lsp").default_capabilities()
  end)
  capabilities = ok_cmp and cmp_caps or vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
  merged_opts.capabilities = vim.tbl_deep_extend("force", capabilities, merged_opts.capabilities or {})

  -- 3) preserve on_attach anterior e anexar navbuddy com segurança
  local previous_on_attach = merged_opts.on_attach
  merged_opts.on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      local ok_nav, navbuddy = pcall(require, "nvim-navbuddy")
      if ok_nav then navbuddy.attach(client, bufnr) end
    end
    if type(previous_on_attach) == "function" then
      pcall(previous_on_attach, client, bufnr)
    end
  end

  -- 4) registra (config) e habilita (enable) o server pela API nova
  -- OBS: o nvim-lspconfig fornece os defaults via arquivos em runtimepath.
  vim.lsp.config(server, merged_opts)  -- estende a config default do server
  vim.lsp.enable(server)               -- habilita para os seus filetypes
end

-- Função para aplicar configurações gerais de diagnósticos
local function apply_diagnostics_settings()
  local settings = vim.tbl_extend('force', default_diagnostics.settings, custom_settings.diagnostics)
  --print(vim.inspect(settings))
  --
  for _, sign in ipairs(settings.signs) do
    vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.texthl })
  end

  vim.diagnostic.config(settings)
end


-- Obtém todos os built-ins do null-ls
local function get_all_builtins()
  local null_ls = require("null-ls")
  return {
    diagnostics = vim.tbl_keys(null_ls.builtins.diagnostics),
    formatting = vim.tbl_keys(null_ls.builtins.formatting)
  }
end

-- Obtém ferramentas integradas baseadas na configuração e nos built-ins
local function get_integrated_tools(diagnostics_config, builtins)
  local integrated_tools = {
    diagnostics = {},
    formatting = {}
  }

  for filetype, tools in pairs(diagnostics_config.languages) do
    for _, linter in ipairs(tools.linter or {}) do
      if vim.tbl_contains(builtins.diagnostics, linter) then
        table.insert(integrated_tools.diagnostics, linter)
      end
    end
    for _, formatter in ipairs(tools.formatter or {}) do
      if vim.tbl_contains(builtins.formatting, formatter) then
        table.insert(integrated_tools.formatting, formatter)
      end
    end
  end

  return integrated_tools
end

local function get_unavailable_tools(diagnostics_config)
  local builtins = get_all_builtins()
  local unavailable_tools = {}

  for filetype, tools in pairs(diagnostics_config.languages) do
    for _, linter in ipairs(tools.linter or {}) do
      if not vim.tbl_contains(builtins.diagnostics, linter) then
        table.insert(unavailable_tools, linter)
      end
    end
    for _, formatter in ipairs(tools.formatter or {}) do
      if not vim.tbl_contains(builtins.formatting, formatter) then
        table.insert(unavailable_tools, formatter)
      end
    end
  end

  return unavailable_tools
end

-- Identifica ferramentas incompatíveis com os built-ins
local function find_unavailable_tools(diagnostics_config, builtins)
  local unavailable_tools = {
    diagnostics = {},
    formatting = {}
  }

  for filetype, tools in pairs(diagnostics_config.languages) do
    for _, linter in ipairs(tools.linter or {}) do
      if not vim.tbl_contains(builtins.diagnostics, linter) then
        table.insert(unavailable_tools.diagnostics, linter)
      end
    end
    for _, formatter in ipairs(tools.formatter or {}) do
      if not vim.tbl_contains(builtins.formatting, formatter) then
        table.insert(unavailable_tools.formatting, formatter)
      end
    end
  end

  return unavailable_tools
end

-- Instala ferramentas incompatíveis usando mason-tool-installer
local function install_unavailable_tools(unavailable_tools)
  local mason_tool_installer = require("mason-tool-installer")

  local tools_to_install = {}
  for _, tool in ipairs(unavailable_tools.diagnostics) do
    table.insert(tools_to_install, tool)
  end
  for _, tool in ipairs(unavailable_tools.formatting) do
    table.insert(tools_to_install, tool)
  end

  mason_tool_installer.setup({
    ensure_installed = tools_to_install,
    auto_update = true,
    run_on_start = true
  })
end

-- Configura ferramentas instaladas
local function setup_installed_tools()
  local mason_null_ls = require("mason-null-ls")
  mason_null_ls.setup()
end

-- Configura fontes de linters
local function configure_linters(builtins, filetype, linters)
  local sources = {}
  for _, linter in ipairs(linters) do
    local linter_source = vim.deepcopy(require("null-ls").builtins.diagnostics[linter])
    if linter_source then
      table.insert(sources, linter_source.with({
        filetypes = { filetype },
        prefer_local = "node_modules/.bin"
      }))
    end
  end
  return sources
end

-- Configura fontes de formatadores
local function configure_formatters(builtins, filetype, formatters)
  local sources = {}
  for _, formatter in ipairs(formatters) do
    local formatter_source = vim.deepcopy(require("null-ls").builtins.formatting[formatter])
    if formatter_source then
      table.insert(sources, formatter_source.with({
        filetypes = { filetype },
        prefer_local = "node_modules/.bin"
      }))
    end
  end
  return sources
end

-- Identifica ferramentas incompatíveis e as instala
local function handle_unavailable_tools(diagnostics_config, builtins)
  local unavailable_tools = find_unavailable_tools(diagnostics_config, builtins)
  install_unavailable_tools(unavailable_tools)
  setup_installed_tools()
end

-- Configura autocomandos para formatação ao salvar
local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*",
    callback = function()
      if vim.lsp.get_clients() then
        vim.lsp.buf.format({ async = false })
      end
    end,
  })
end

-- Cria a função on_attach com formatação ao salvar
local function create_on_attach(format_on_save_func)
  return function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      format_on_save_func(bufnr)
    end
  end
end

-- Configura null-ls com as fontes fornecidas
local function setup_null_ls(sources)
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = sources,
    on_attach = create_on_attach(function(bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end),
  })
end

-- Configura null-ls e realiza outras tarefas
local function configure_null_ls(diagnostics_config)
  local builtins = get_all_builtins()
  local integrated_tools = get_integrated_tools(diagnostics_config, builtins)

  -- Configura fontes de linters e formatadores
  local sources = {}
  for filetype, tools in pairs(diagnostics_config.languages) do
    local linter_sources = configure_linters(builtins, filetype, integrated_tools.diagnostics)
    local formatter_sources = configure_formatters(builtins, filetype, integrated_tools.formatting)

    vim.list_extend(sources, linter_sources)
    vim.list_extend(sources, formatter_sources)
  end

  -- Identifica e instala ferramentas incompatíveis
  handle_unavailable_tools(diagnostics_config, builtins)

  -- Configura null-ls
  setup_null_ls(sources)

  -- Aplica configurações gerais de diagnósticos
  apply_diagnostics_settings()

  -- Configura autocomandos
  --setup_autocmds()
end

return {
    -- mason core
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 900, -- sobe cedo (antes dos que dependem dele)
    opts = {},
  },

  -- mason-null-ls (integra com null-ls) + tua configuração de null-ls
  {
    "williamboman/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    -- carrega cedo para que a lista de ferramentas já exista quando o orquestrador rodar
    event = "VeryLazy",
    config = function()
      -- tua função existente
      configure_null_ls(diagnostics_config)
    end,
  },

  -- orquestrador: instala/atualiza tudo (LSPs + null-ls + o que mais você quiser)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    config = function()
      -- LSPs declarados no teu lsps_config
      local servers = lsps_config.servers or {}

      -- Ferramentas de null-ls que NÃO são built-ins ou que precisam vir via mason
      local unavailable = get_unavailable_tools(diagnostics_config) -- { diagnostics = {...}, formatting = {...} }

      -- achata e remove duplicatas
      local to_install, seen = {}, {}
      local function add(name)
        if name and not seen[name] then
          seen[name] = true
          table.insert(to_install, name)
        end
      end

      for _, s in ipairs(servers) do add(s) end
      for _, n in ipairs(unavailable.diagnostics or {}) do add(n) end
      for _, n in ipairs(unavailable.formatting or {}) do add(n) end

      -- (opcional) adicione CLIs genéricos aqui:
      -- for _, extra in ipairs({ "stylua", "prettierd", "eslint_d", "shellcheck" }) do add(extra) end

      require("mason-tool-installer").setup({
        ensure_installed = to_install,
        auto_update = true,
        run_on_start = true,
        integrations = {
          ["mason-lspconfig"] = true,
          ["mason-null-ls"] = true,
          ["mason-nvim-dap"] = true,
        },
      })
    end,
  },

  -- mason-lspconfig (sem setup_handlers)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    event = "VeryLazy",
    opts = function()
      return {
        ensure_installed = lsps_config.servers or {},
        -- NÃO habilitamos automático para manter teu apply_config (on_attach/capabilities/navbuddy)
        automatic_installation = false, -- (mantém compat com versões antigas)
      }
    end,
    config = function(_, opts)
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = opts.ensure_installed,
        automatic_installation = opts.automatic_installation,
      })

      -- Configura cada servidor chamando tua função apply_config
      for _, server in ipairs(opts.ensure_installed or {}) do
        local sopts = lsps_config.settings and lsps_config.settings[server] or {}
        apply_config(server, sopts)
      end
    end,
  },


  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",

      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim"
    },
    opts = { lsp = { auto_attach = true } },
    config = function()
      require('nvim-navbuddy').setup({
        -- Configurações específicas do Navbuddy
        lsp = {
          auto_attach = true, -- anexa automaticamente aos servidores LSP
        },
        treesitter = {
          auto_attach = true, -- anexa automaticamente ao Treesitter
        },
        keymaps = {
          ['<leader>n'] = '<cmd>Navbuddy<cr>', -- mapeia a tecla para abrir o Navbuddy
        },
        window = {
          -- Definindo a largura de cada coluna individualmente
          sections = {
            left = {
              size = "20%", -- Coluna de símbolos (esquerda)
            },
            mid = {
              size = "20%", -- Coluna intermediária
            },
            right = {
              size = "60%", -- Coluna de preview (direita)
            },
          },
        },
      })
    end,

  },


  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons',     -- optional
    },
    after = 'nvim-lspconfig',
    config = function()
      local saga = require('lspsaga')

      saga.setup({
        finder = {
          max_height = 0.6,
          left_width = 0.3,
          right_width = 0.3,
          keys = {
            shuttle = '[w',
            toggle_or_open = 'o',
            vsplit = 'v',
            split = 'i',
            tabe = 't',
            tabnew = 'r',
            quit = 'q',
            close = '<C-c>k'
          },
          layout = 'float',
          default = 'ref+imp'
        },
        ui = {
          theme = 'round',
          border = 'rounded',
          winblend = 10,
          expand = '',
          collapse = '',
          preview = ' ',
          code_action = '💡',
          diagnostic = '🐞',
          incoming = ' ',
          outgoing = ' ',
          hover = ' ',
        },
        lightbulb = {
          enable = true,
          sign = true,
          debounce = 75,
          sign_priority = 40,
        },
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = true,
          keys = {
            quit = '<ESC>',
            exec = '<CR>',
          },
        },
        hover = {
          max_width = 0.6,
          open_link = 'gx',
          open_browser = '!chrome',
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true,
          max_width = 0.7,
          text_hl_follow = true,
          border_follow = true,
          keys = {
            exec_action = 'o',
            quit = 'q',
            go_action = 'g'
          },
        },
        rename = {
          quit = '<ESC>',
          in_select = false,
          keys = {
            exec = '<CR>',
            quit = '<ESC>',
          },
        },
        symbol_in_winbar = {
          enable = true,
          separator = ' › ',
          hide_keyword = false,
          show_file = true,
          folder_level = 1,
          color_mode = true,
          delay = 300,
        },
      })
    end,
  },


  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
    },
  }
}
