-- ~/.config/nvim/lua/files_versioning.lua
return {
  -- Git-blame.nvim
  {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
      -- your configuration comes here
      -- for example
      enabled = true, -- if you want to enable the plugin
      message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
      date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    },

  },

  -- Gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
        },
        current_line_blame = false, -- Exibe o blame na linha atual
        current_line_blame_opts = {
          delay = 500,              -- Tempo de atraso para o blame
        },
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
      })
    end,
  },

  -- Neogit
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- necessário
      "sindrets/diffview.nvim",        -- integração opcional com Diffview
      "nvim-telescope/telescope.nvim", -- integração opcional com Telescope
      "ibhagwan/fzf-lua",              -- integração opcional com FZF
    },
    config = function()
      local neogit = require('neogit')
      neogit.setup({
        integrations = {
          diffview = true,                  -- Ativa integração com Diffview
          telescope = false,                -- Desativa integração com Telescope se não for necessário
          fzf = false,                      -- Desativa integração com FZF se não for necessário
        },
        disable_commit_confirmation = true, -- Desativa confirmação para maior fluidez
        auto_refresh = true,
        commit_popup = {
          kind = 'split' -- Abre o popup de commit em uma divisão
        }
      })
    end,
  },

  -- Diffview.nvim
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('diffview').setup({
        enhanced_diff_hl = true,
        use_icons = true,
        file_panel = {
          listing_style = "tree", -- ou "list" se preferir uma lista
        },
        keymaps = {
          view = {
            ["l"] = "<cmd>DiffviewSelectNextEntry<CR>",
            ["h"] = "<cmd>DiffviewSelectPrevEntry<CR>",
            ["q"] = "<cmd>DiffviewClose<CR>",
          },
          file_panel = {
            ["j"] = "<cmd>DiffviewNextEntry<CR>",
            ["k"] = "<cmd>DiffviewPrevEntry<CR>",
            ["q"] = "<cmd>DiffviewClose<CR>",
          },
        },
      })
    end,
  },
}
