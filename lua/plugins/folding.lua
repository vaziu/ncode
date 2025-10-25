-- ~/.config/nvim/lua/plugins/folding.lua
return {
  -- UFO (só a lógica de folding)
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    init = function ()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
    end,
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      provider_selector = function() return { "lsp", "indent" } end,
      open_fold_hl_timeout = 0,
    },
  },

  -- StatusCol (desenha a gutter)
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    init = function()
      -- defina as opções de fold **apenas aqui**
      vim.opt.foldcolumn = "1"      -- ou "auto:1"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.opt.signcolumn = "auto:1" -- evita alargar demais a gutter
    end,
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        -- gutter: [FOLD] [NÚMERO] [SIGNS]
        segments = {
          { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
          { text = { " " } },
          { text = { builtin.lnumfunc },      click = "v:lua.ScLa" },
          { text = { " " },                   condition = { true, builtin.not_empty } },
          { text = { builtin.signcolumn },    click = "v:lua.ScSa" },
        },
      })
    end,
  },
  {
  "shellRaining/hlchunk.nvim",
  event = "BufEnter",
  opts = {
    chunk = {
      enable = true,
      style = { { fg = "Grey" } },
      delay = 0,
      use_treesitter = true,
    },
    indent = { enable = false }, -- você já tem indentmini/ibl se quiser
  },
}

}

