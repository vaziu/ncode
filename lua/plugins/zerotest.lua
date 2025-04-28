-- ~/.config/nvim/lua/plugins/zerotest.lua

return {
  dir = "~/Projetos/zerotest-neovim-plugin", -- caminho absoluto até o plugin local
  name = "zerotest",
  lazy = false,
  config = function()
    local settings = dofile(vim.fn.stdpath("config") .. "/settings.lua")

    require("zerotest").setup(settings.zerotest)

    vim.keymap.set("v", "<leader>ai", function()
      local lines = vim.fn.getline("'<", "'>")
      require("zerotest").ask(table.concat(lines, "\n"))
    end, { noremap = true, silent = true, desc = "Ask AI (seleção visual)" })
  end,
}
