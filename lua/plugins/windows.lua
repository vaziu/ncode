return {
  {
    "yorickpeterse/nvim-window",
    keys = {
      { "<leader>w", "<cmd>lua require('nvim-window').pick()<cr>", desc = "Pick a window" },
    },
    config = function()
      require('nvim-window').setup({
        chars = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' },
        normal_hl = 'Normal',
        hint_hl = 'Bold',
        border = 'single',
      })
    end
  },
  {
    'simeji/winresizer',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>wr', ':WinResizerStartResize<CR>', { noremap = true, silent = true })
    end
  },
  {
    'sindrets/winshift.nvim',
    config = function()
      -- require("winshift").setup({
      -- keys = {
      -- { "<leader>wm", "<cmd>WinShift<CR>", desc = "Activate WinShift" },
      -- }
      -- })
    end
  }


}
