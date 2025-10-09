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
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('fzf-lua').setup({
        -- Procurar arquivos usando ripgrep
        files = {
          cmd =
          "rg --files --hidden --glob '!.git/*' --glob '!node_modules/*' --glob '!.cache/*' --glob '!dist/*' --glob '!build/*'",
          previewer = "bat", -- preview com destaque de sintaxe
          actions = {
            ["default"] = require("fzf-lua.actions").file_edit,
            ["ctrl-s"] = require("fzf-lua.actions").file_split,
            ["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
          },
        },

        -- Procurar termos dentro de arquivos
        grep = {
          cmd = "rg --vimgrep --hidden --glob '!{.git,node_modules,.cache,dist,build}/*'",
          previewer = "bat", -- preview com destaque de sintaxe
          actions = {
            ["default"] = require("fzf-lua.actions").file_edit,
            ["ctrl-s"] = require("fzf-lua.actions").file_split,
            ["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
          },
        },

        -- Ícones para arquivos
        devicons = {
          enable = true,
        },

        -- Outras configurações gerais do FZF
        fzf_opts = {
          ["--ansi"] = "",
          ["--prompt"] = "> ",
          ["--info"] = "inline",
          ["--height"] = "100%",
        },
      })
    end
  }

}
