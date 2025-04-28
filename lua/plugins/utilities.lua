-- ~/.config/nvim/lua/plugins/utilities.lua

local utils = require "utils"
return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      local toggleterm = require('toggleterm')

      toggleterm.setup {
        size = 30,
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        shading_factor = 10,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = 'vertical', -- Default direction, can be overridden per terminal
        display_name = "",
        close_on_exit = true,
        border = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        zindex = 20,
        float_opts = {
          border = 'curved',
          width = 80,
          height = 20,
          row = 10,
          col = 10,
          winblend = 3,
          zindex = 10,
          title_pos = 'center',
          display_name = "",
        },

        winbar = {
          enabled = true,                 -- Disables the winbar (title bar) display
          name_formatter = function(term) --  term: Terminal
            return ""
          end,

        },


      }
    end
  },
  {
    'danilamihailov/beacon.nvim',
    config = function()
      require('beacon').setup({
        enabled = true,                                --- (boolean | fun():boolean) check if enabled
        speed = 2,                                     --- integer speed at wich animation goes
        width = 40,                                    --- integer width of the beacon window
        winblend = 70,                                 --- integer starting transparency of beacon window :h winblend
        fps = 60,                                      --- integer how smooth the animation going to be
        min_jump = 10,                                 --- integer what is considered a jump. Number of lines
        cursor_events = { 'CursorMoved' },             -- table<string> what events trigger check for cursor moves
        window_events = { 'WinEnter', 'FocusGained' }, -- table<string> what events trigger cursor highlight
        highlight = { bg = 'white', ctermbg = 15 },    -- vim.api.keyset.highlight table passed to vim.api.nvim_set_hl
      })
      vim.api.nvim_set_hl(0, 'Beacon', { bg = 'white' })
    end
  },
  {
    "gen740/SmoothCursor.nvim",
    config = function()
      require('smoothcursor').setup({
        autostart = true,
        fancy = {
          enable = true,
          head = { cursor = "", texthl = "SmoothCursor", linehl = nil, type = "exp" },
          body = {
            { cursor = "", texthl = "SmoothCursorRed" },
            { cursor = "", texthl = "SmoothCursorOrange" },
            { cursor = "●", texthl = "SmoothCursorYellow" },
            { cursor = "●", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
        },
        speed = 25, -- Velocidade da animação (valor menor = mais rápido)
      })
    end
  },
  { 'mg979/vim-visual-multi' },
  {
    'booperlv/nvim-gomove',
    config = function()
      require('gomove').setup {
        -- Suas configurações aqui (opcional)
        map_defaults = false,      -- desativa os mapeamentos padrão para criar os seus próprios
        reindent = true,           -- reindenta as linhas movidas
        undojoin = true,           -- mantém o histórico de desfazer em uma única ação
        move_past_end_col = false, -- evita mover blocos para além da última coluna
      }
    end,
  },
  {
    'hedyhli/outline.nvim',
    config = function()
      require('outline').setup({
        icons = {
          ["function"] = '󰊕', -- Ícone para funções
          method = '', -- Ícone para métodos
          variable = '', -- Ícone para variáveis
          class = '', -- Ícone para classes
          interface = '', -- Ícone para interfaces
          -- Adicione mais ícones conforme necessário
        },
        -- Configurações adicionais
        auto_preview = true,          -- Habilita a pré-visualização automática ao selecionar um item
        auto_refresh = true,          -- Atualiza automaticamente quando o arquivo é modificado
        show_guides = true,           -- Mostra guias para indicar a hierarquia dos símbolos
        position = 'right',           -- Posição da janela do outline (pode ser 'right', 'left', etc.)
        width = 25,                   -- Largura da janela do outline
        relative_width = false,       -- Se verdadeiro, a largura é relativa à largura da janela
        keymaps = {                   -- Mapeamentos de teclas para navegação e ações no outline
          close = { "q", "<Esc>" },   -- Fecha a janela do outline
          goto_location = "<Cr>",     -- Vai para a localização do símbolo selecionado
          focus_location = "o",       -- Foca na localização do símbolo sem fechar o outline
          hover_symbol = "<C-space>", -- Mostra mais informações sobre o símbolo
          rename_symbol = "r",        -- Renomeia o símbolo
          code_actions = "a",         -- Ações de código para o símbolo
        },
        lsp = {
          provider = "lsp", -- Define o provedor de símbolos, geralmente "lsp"
        },
      })
    end
  },
  {
    'folke/neodev.nvim',
    dependencies = { 'rcarriga/nvim-dap-ui' },
    config = function()
      require("neodev").setup({
        -- Configurações específicas
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },
  {
    "gpanders/editorconfig.nvim",
    event = "BufReadPre",
    config = function()
      vim.g.editorconfig = true
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require('colorizer').setup({
        '*',             -- Highlight all files
      }, {
        RGB = true,      -- #RGB hex codes
        RRGGBB = true,   -- #RRGGBB hex codes
        names = true,    -- "Name" codes like "red" or "blue"
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        css = true,      -- Enable all CSS features
        css_fn = true,   -- Enable all CSS features
      })
    end,
  },
  {
    "neph-iap/easycolor.nvim",
    dependencies = { "stevearc/dressing.nvim" }, -- Dependência opcional
    event = "VeryLazy",
    opts = {},
    keys = { { "<leader>b", "<cmd>EasyColor<cr>", desc = "Color Picker" } }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      -- Carregue o plugin
      local wk = require("which-key")

      -- Configure o which-key
      wk.setup({
        -- Escolha o layout (opções: "classic", "modern", "helix")
        preset = "helix",
        -- Tempo de delay antes de mostrar o popup
        delay = 200,

        -- Filtros para as mappings
        filter = function(mapping)
          return true
        end,

        -- Plugins habilitados
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = false,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },

        -- Opções da janela
        win = {
          padding = { 1, 2 },
          title = true,
          title_pos = "center",
          zindex = 1000,
        },

        -- Layout da janela
        layout = {
          width = { min = 20 },
          spacing = 3,
        },

        -- Mapeamentos de teclas
        keys = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },

        -- Ordenação dos mapeamentos
        sort = { "order" },

        -- Expansão dos grupos
        expand = 0,

        -- Substituições de ícones e formatação
        replace = {
          key = {
            function(key)
              return require("which-key.view").format(key)
            end,
          },
          desc = {
            { "<Plug>%(?(.*)%)?", "%1" },
            { "^%+",              "" },
            { "<[cC]md>",         "" },
            { "<[cC][rR]>",       "" },
            { "<[sS]ilent>",      "" },
            { "^lua%s+",          "" },
            { "^call%s+",         "" },
            { "^:%s*",            "" },
          },
        },

        -- Configurações de ícones
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
          ellipsis = "…",
          mappings = false,
          colors = true,
        },

        show_help = true,
        show_keys = true,

        -- Desabilitar WhichKey para certos tipos de buffer e arquivos
        disable = {
          ft = {},
          bt = {},
        },

        debug = false,
        notify = false,
      })
    end
  }
}
