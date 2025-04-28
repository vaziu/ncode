-- ~/.config/nvim/lua/plugins/snippets.lua
return {
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require('luasnip').setup({})
    end,
  },
}

