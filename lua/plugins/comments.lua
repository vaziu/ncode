-- ~/.config/nvim/lua/plugins/comment.lua
return {
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        -- configuracoes aqui
        toggler = {
          line = 'gcc', -- Atalho para comentar/descomentar linha
          block = 'gbc', -- Atalho para comentar/descomentar bloco
        },
        opleader = {
          line = 'gc', -- Atalho para comentar/descomentar linha em modo visual
          block = 'gb', -- Atalho para comentar/descomentar bloco em modo visual
        },
        mappings = {
          basic = true,
          extra = true,
          extended = false,
        },
      })
    end,
  },
}
