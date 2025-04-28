-- Função para converter a tabela de depuradores em itens de menu
local function generate_menu_items(languages, Menu)
  local items = {}
  for lang, configs in pairs(languages) do
    for _, config in ipairs(configs) do
      table.insert(items, Menu.item(config.name, {
        config = config -- Adiciona a configuração ao item do menu
      }))
    end
  end
  return items
end

local function select_dap_config()
  local Menu = require("nui.menu")
  local event = require("nui.utils.autocmd").event
  local dap = require('dap')
  local dap_settings = require('debuggers')
  local items = generate_menu_items(dap_settings.languages, Menu) 

  local menu = Menu({
    position = "50%",
    size = {
      width = 25,
      height = 5,
    },
    border = {
      style = "single",
      text = {
        top = "Select a debugger",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = items,
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_change = function(item, menu)
    end,
    on_submit = function(item)
      dap.run(item.config)
    end,
  })

  -- mount the component
  menu:mount()
end

return {
  select_dap_config = select_dap_config
}

