return {
  {
    'jmbuhr/otter.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local otter = require('otter')
      otter.setup({
        filetypes = {
          typescript = {
            embedded_languages = {
              html = true,
              javascript = true,
              mdx = true,
              jsx = true,
              tsx = true,
              css = true,
            },
          },
          custom_syntax = {
            ["css`"] = "css",
            ["jsx`"] = "jsx",
            ["tsx`"] = "tsx",
            ["html`"] = "tsx",
          },
        },
      })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.ts" },
        callback = function()
          otter.activate({ filetype = "typescript" })
          vim.notify("otter activate")
        end,
      })
    end
  },
  {
    'maxmellon/vim-jsx-pretty',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    config = function()
      vim.g.vim_jsx_pretty_template_tags = { 'html', 'jsx', 'tsx', 'mdx' }
      vim.g.vim_jsx_pretty_disable_js = 0
      vim.g.vim_jsx_pretty_disable_tsx = 0
      vim.g.vim_jsx_pretty_colorful_config = 1
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ts_config = require("nvim-treesitter.configs")
      ts_config.setup({
        ensure_installed = {
          "typescript",
          "javascript",
          "tsx",
          "html",
          "css",
          "scss",
          "angular",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
        },
        autotag = {
          enable = false,
        },
        playground = {
          enable = true,
        },
      })
    end,
  },
}
