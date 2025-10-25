return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Certifique-se de que o devicons está incluído
    config = function()
      local devicons = require('nvim-web-devicons')

      -- Função para obter o ícone do arquivo
      local function file_icon()
        local filename = vim.fn.expand('%:t')
        local filetype = vim.fn.expand('%:e')
        local icon, _ = devicons.get_icon(filename, filetype, { default = true })
        return icon or ''
      end
      -- ‹
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'catppuccin', -- ou o tema que você estiver usando
          component_separators = { left = '‹', right = '›' }, -- Usando setas Unicode
          section_separators = { left = '', right = '' }, -- Usando setas Unicode
          disabled_filetypes = { "toggleterm" },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { 'mode' },

          lualine_b = { 'branch' },
          lualine_c = {
            {
              file_icon, -- Adiciona o ícone do arquivo
              'filename',
              file_status = true,
              newfile_status = true,
              symbols = {
                modified = '⏺',
                readonly = '🛇',
                unnamed = 'New',
              }
            }
          },
          lualine_x = {
            'encoding',
            'fileformat',
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = {
                error = devicons.get_icon('error', 'DiagnosticError') or '',
                warn = devicons.get_icon('warning', 'DiagnosticWarn') or '󰗖',
                info = devicons.get_icon('info', 'DiagnosticInfo') or '',
                hint = devicons.get_icon('hint', 'DiagnosticHint') or '󱩎',
              }
            },
            'filetype'
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      }
    end,
  },
}
