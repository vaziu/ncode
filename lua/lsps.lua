-- ~/.config/nvim/lua/lsps.lua

return {
  servers = {
    "html",
    "cssls",
    "emmet_ls",
    "lua_ls",
  }, -- servidores lsp padrão
  settings = {
    html = {},
    cssls = {},
    lua_ls = {},
    emmet_ls = {
      filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "php", "angular", "vue", "svelte" }, -- Adicione ou remova conforme necessário
      init_options = {
        html = {
          options = {
            ["bem.enabled"] = true, -- Exemplo de configuração do Emmet
          },
        },
      },
    },
  },
}
