-- ~/.config/nvim/lua/diagnostics.lua

return {
  settings = {
    enable_linting = true,
    format_on_save = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
    signs = {
      { name = "DiagnosticSignError", text = "", texthl = "DiagnosticSignError" },
      { name = "DiagnosticSignWarn", text = "󰗖", texthl = "DiagnosticSignWarn" },
      { name = "DiagnosticSignInfo", text = "", texthl = "DiagnosticSignInfo" },
      { name = "DiagnosticSignHint", text = "󱩎", texthl = "DiagnosticSignHint" },
    },
  },
  languages = {
    javascript = {
      linter = { "biome" },
      formatter = { "biome" },
    },
    typescript = {
      linter = { "biome" },
      formatter = { "biome" },
    },
    javascriptreact = {
      linter = { "biome" },
      formatter = { "biome" },
    },
    typescriptreact = {
      linter = { "biome" },
      formatter = { "biome" },
    },
    html = {
      linter = { "htmlhint" },
      formatter = { "prettier" },
    },
    css = {
      linter = { "stylelint" },
      formatter = { "prettier" },
    },
    lua = {
      linter = { "stylua" },
      formatter = { "stylua" }
    }
  },
}
