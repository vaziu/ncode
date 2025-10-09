-- ~/.config/nvim/lua/plugins/buffers.lua

return {
  {
    'j-morano/buffer_manager.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("buffer_manager").setup({
        select_menu_item_commands = {
          v = {
            key = "<C-v>",
            command = "vsplit"
          },
          h = {
            key = "<C-h>",
            command = "split"
          }
        },
        focus_alternate_buffer = true,
        loop_nav = true,
        highlight = 'Normal:BufferManagerBorder',
        win_extra_options = {
          winhighlight = 'Normal:BufferManagerNormal',
        },
      })
    end
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('bufferline').setup {
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,

          buffer_close_icon = '✖',
          modified_icon = "● ",
          close_icon = '✖',
          left_trunc_marker = " ",
          right_trunc_marker = " ",

          -- Opcional: define se a barra de buffers deve sempre ser exibida
          always_show_bufferline = true, -- define como false para ocultar quando houver um único buffer

          -- Outras configurações
          max_name_length = 30,
          max_prefix_length = 20,
          tab_size = 0,
          diagnostics = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            }
          },
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          separator_style = 'none',
          enforce_regular_tabs = false,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' }
          },
          sort_by = 'insert_after_current',

        },

      }
    end,
  },
}
