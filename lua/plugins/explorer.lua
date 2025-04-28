return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local nvimtree = require("nvim-tree")
      nvimtree.setup({
        filters = {
          custom = { "\\~$", "\\.git$" }
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        view = {
          adaptive_size = true,
          width = 30, -- Define a largura da árvore de arquivos
          side = "left",
        },
        diagnostics = {
          enable = true,
          show_on_dirs = false,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        renderer = {
          root_folder_modifier = ":t",
          indent_markers = {
            enable = true,
            icons = {
              corner = "└ ",
              edge = "│ ",
              item = "│ ",
              none = "  ",
            },
          },
          icons = {
            webdev_colors = false,
            show = {
              file = false,
              folder = true,
              folder_arrow = false,
              git = true
            },
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "", -- 
                staged = "",
                unmerged = "",
                renamed = "➜",
                untracked = "",
                deleted = "",
                ignored = "◌",
              },
            },
          }
        }

      })
    end
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            ".git", "node_modules", ".cache", "dist"
          },
          hidden = true,
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end
  },
}
