-- Função para verificar se há buffers abertos
local function show_bufferline()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers > 0 then
    vim.cmd("set showtabline=2") -- Mostra a barra de buffers
  else
    vim.cmd("set showtabline=0") -- Esconde a barra de buffers
  end
end

-- Função para garantir que o comando BuffetSetCustomColors seja executado apenas após o plugin estar carregado
local function set_custom_colors()
  if vim.fn.exists(":BuffetSetCustomColors") == 2 then
    vim.cmd [[call BuffetSetCustomColors()]]
  else
    print("BuffetSetCustomColors command not available")
  end
end

-- Função para abrir um buffer vazio
local function open_empty_buffer()
  -- Cria um novo buffer
  vim.cmd('enew')
  -- Define o buffer como não editável
  vim.bo.buflisted = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.bufhidden = 'wipe' -- Mude 'wipe' para 'hide' para garantir que o buffer não seja excluído
  -- Desabilita edição no buffer
  vim.cmd('setlocal nomodifiable')
end

-- Função recursiva para mesclar tabelas
local function merge_tables(tbl1, tbl2)
  for k, v in pairs(tbl2) do
    if type(v) == "table" then
      if not tbl1[k] then
        tbl1[k] = {}
      end
      merge_tables(tbl1[k], v) -- Chamada recursiva
    else
      tbl1[k] = v
    end
  end
end

-- Função auxiliar para lidar com navegação e expansão de snippets
local cmp = pcall(require, 'cmp')
local luasnip = pcall(require, 'luasnip')

local function handle_tab(fallback, direction)
  if cmp.visible() then
    if direction == 'next' then
      cmp.mapping.select_next_item()(fallback)
    elseif direction == 'prev' then
      cmp.mapping.select_prev_item()(fallback)
    end
  elseif direction == 'next' and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif direction == 'prev' and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

local function set_keymaps(keymaps)
  for mode, mappings in pairs(keymaps) do
    for lhs, map in pairs(mappings) do
      local rhs = map.rhs
      local desc = map.desc
      local opts = map.opts or {}
      opts.desc = desc
      -- Adiciona uma verificação para garantir que rhs não seja nil
      if rhs then
        vim.keymap.set(mode, lhs, rhs, opts)
      else
        print("Erro: rhs é nil para o mapeamento " .. lhs .. " em modo " .. mode)
      end
    end
  end
end

local function format_keymaps(maps)
  local formatted_maps = {}
  for key, map in pairs(maps) do
    local cmd, desc = map[1], map[2]
    local mode = map.mode or "n"
    -- Formata a descrição com o modo
    formatted_maps[key] = {
      cmd,
      string.format("%s %s - %s", mode, key, desc)
    }
  end
  return formatted_maps
end

local function get_process_id(cmd)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  local pid = result:match("%d+")
  return pid
end

local function update_nvim()
  -- Sincronize os plugins
  vim.cmd('Lazy sync')

  -- Recarregue o arquivo de configuração
  vim.cmd('source $MYVIMRC')

  -- Recarregue LSPs se necessário (opcional)
  -- local lsp = require('lspconfig')
  -- lsp.update()

  print("CodeNvim atualizado com sucesso!")
end

local function close_nvim_tree()
  local api = require('nvim-tree.api')
  if api.tree.is_visible() then
    vim.defer_fn(function()
      api.tree.close()
    end, 200) -- Ajuste o atraso se necessário
  end
end

local function ensure_no_buffers()
  -- Criar um novo buffer vazio se não houver buffers abertos
  vim.cmd('enew')
end

local function uninstall_plugins()
  -- Fechar o nvim-tree com atraso
  ensure_no_buffers()
  close_nvim_tree()

  -- Aguarde até que o nvim-tree esteja realmente fechado
  vim.wait(300, function()
    -- Remover diretórios de plugins
    local lazy_dir = vim.fn.expand('~/.local/share/nvim/lazy')
    if vim.fn.isdirectory(lazy_dir) == 1 then
      local handle = io.popen('rm -rf ' .. lazy_dir)
      handle:close()
    else
      vim.notify("O diretório de plugins não existe.", vim.log.levels.WARN)
    end

    local cache_dir = vim.fn.expand('~/.local/share/nvim/lazy_cache')
    if vim.fn.isdirectory(cache_dir) == 1 then
      local cache_handle = io.popen('rm -rf ' .. cache_dir)
      cache_handle:close()
    end

    vim.notify("Plugins removidos com sucesso!", vim.log.levels.INFO)
  end, 300)
end

-- Função fábrica para criar um objeto de registro e repetição de comandos
-- Função fábrica para criar um objeto de registro e repetição de comandos
local function commander_creator()
  local last_command = ""
  local last_command_type = ""
  local last_command_time = 0 -- Marca o tempo do último comando registrado
  local last_dot_time = 0     -- Marca o tempo do último comando executado pelo operador "."

  -- Função para registrar e executar o comando
  local function register(command)
    -- Armazena o comando, seu tipo e o tempo de execução
    last_command = command
    last_command_type = command:match("<Plug>") and "plug" or "cmd"
    last_command_time = os.time() -- Atualiza a marcação de tempo

    -- Executa o comando registrado imediatamente
    if last_command_type == "plug" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(command, true, false, true), 'n', true)
    else
      local clean_command = command:gsub("<Cmd>", ""):gsub("</Cmd>", "")
      vim.api.nvim_command(clean_command)
    end

    -- Atualiza a marcação de tempo para o operador "."
    last_dot_time = 0 -- Reseta o tempo do operador "." para evitar conflito
  end

  -- Função para repetir o último comando registrado
  local function repeat_last()
    local current_dot_command = vim.fn.getreg('1') -- O comando mais recente associado ao operador "."
    local current_time = os.time()

    -- Verifica se o operador "." foi usado mais recentemente que o último comando registrado
    if last_dot_time > last_command_time then
      -- Executa o comando do operador "."
      vim.api.nvim_feedkeys('.', 'n', true)

      -- Atualiza last_command com o comando do operador "."
      last_command = current_dot_command
      last_command_type = "dot"
      last_command_time = last_dot_time
    elseif last_command ~= "" then
      -- Executa o último comando registrado pelo commander_creator
      if last_command_type == "plug" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(last_command, true, false, true), 'n', true)
      else
        local clean_command = last_command:gsub("<Cmd>", ""):gsub("</Cmd>", "")
        vim.api.nvim_command(clean_command)
      end
    else
      print("No command to repeat")
    end
  end

  -- Função para atualizar a marcação de tempo do operador "."
  local function update_dot_time()
    last_dot_time = os.time()
  end

  return {
    register = register,
    repeat_last = repeat_last,
    update_dot_time = update_dot_time
  }
end

local function create_terminal()
  local Terminal = require('toggleterm.terminal').Terminal

  -- Contador global para nomes de terminais
  local terminal_counter = 1

  local terminals = {}
  local active_index = 0

  local function create_floating_terminal()
    local term_name = "Terminal " .. terminal_counter
    terminal_counter = terminal_counter + 1

    local term = Terminal:new({
      direction = "float",
      close_on_exit = true,
      float_opts = {
        border = 'curved', -- Ou 'single', 'double', 'shadow', conforme desejado
        width = 0.8,
        height = 0.8,
        row = 0.1, -- Ajuste conforme necessário
        col = 0.1, -- Ajuste conforme necessário
      },
    })

    -- Calcula o centro da tela
    local screen_width = vim.o.columns
    local screen_height = vim.o.lines
    local term_width = math.floor(screen_width * 0.8)
    local term_height = math.floor(screen_height * 0.8)

    term.float_opts.width = term_width
    term.float_opts.height = term_height
    term.float_opts.row = math.floor((screen_height - term_height) / 2)
    term.float_opts.col = math.floor((screen_width - term_width) / 2)

    term:toggle()
    term:open()
    table.insert(terminals, term)
    active_index = #terminals

    -- Defina o nome do terminal usando `vim.api.nvim_buf_set_name`
    vim.api.nvim_buf_set_name(term.bufnr, term_name)
  end

  local function create_vertical_terminal()
    local term_name = "Terminal " .. terminal_counter
    terminal_counter = terminal_counter + 1

    local term = Terminal:new({
      direction = "vertical",
      close_on_exit = true, -- Opcional
      -- Ajuste a configuração se necessário para minimizar a visibilidade do título
    })
    term:toggle()
    table.insert(terminals, term)
    active_index = #terminals
    -- Defina o nome do terminal usando `vim.api.nvim_buf_set_name`
    vim.api.nvim_buf_set_name(term.bufnr, term_name)
  end

  local function create_horizontal_terminal()
    local term_name = "Terminal " .. terminal_counter
    terminal_counter = terminal_counter + 1

    local term = Terminal:new({
      direction = "horizontal",
      close_on_exit = true, -- Opcional
      -- Ajuste a configuração se necessário para minimizar a visibilidade do título
    })
    term:toggle()
    table.insert(terminals, term)
    active_index = #terminals
    -- Defina o nome do terminal usando `vim.api.nvim_buf_set_name`
    vim.api.nvim_buf_set_name(term.bufnr, term_name)
  end

  local function create_tab_terminal()
    local term_name = "Terminal " .. terminal_counter
    terminal_counter = terminal_counter + 1

    local term = Terminal:new({
      direction = "tab",
      close_on_exit = true, -- Opcional
      -- Ajuste a configuração se necessário para minimizar a visibilidade do título
    })
    term:toggle()
    table.insert(terminals, term)
    active_index = #terminals
    -- Defina o nome do terminal usando `vim.api.nvim_buf_set_name`
    vim.api.nvim_buf_set_name(term.bufnr, term_name)
  end

  local function toggle_terminal_mode(direction)
    local term = Terminal:new({ direction = direction })
    term:toggle()
  end

  local function switch_next_terminal()
    if #terminals == 0 then return end
    active_index = (active_index % #terminals) + 1
    terminals[active_index]:toggle()
  end

  local function switch_previous_terminal()
    if #terminals == 0 then return end
    active_index = (active_index - 2) % #terminals + 1
    terminals[active_index]:toggle()
  end

  local function hide_terminal(term_id)
    local term = terminals[term_id]
    if term then
      term:hide()
    end
  end

  local function show_terminal(term_id)
    local term = terminals[term_id]
    if term then
      term:toggle()
    end
  end

  local function hide_all_terminals()
    for _, term in ipairs(terminals) do
      term:hide()
    end
  end

  local function show_all_terminals()
    for _, term in ipairs(terminals) do
      term:toggle()
    end
  end

  return {
    create_floating_terminal = create_floating_terminal,
    create_vertical_terminal = create_vertical_terminal,
    create_horizontal_terminal = create_horizontal_terminal,
    create_tab_terminal = create_tab_terminal,
    toggle_terminal_mode = toggle_terminal_mode,
    switch_next_terminal = switch_next_terminal,
    switch_previous_terminal = switch_previous_terminal,
    hide_terminal = hide_terminal,
    show_terminal = show_terminal,
    hide_all_terminals = hide_all_terminals,
    show_all_terminals = show_all_terminals,
  }
end

-- Função para fazer uma cópia profunda de uma tabela
function deep_copy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deep_copy(orig_key)] = deep_copy(orig_value)
    end
    setmetatable(copy, deep_copy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function apply_borders(bufnr)
  -- Obtém o ID da janela associada ao buffer
end

return {
  show_bufferline = show_bufferline,
  set_custom_colors = set_custom_colors,
  open_empty_buffer = open_empty_buffer,
  merge_tables = merge_tables,
  handle_tab = handle_tab,
  set_keymaps = set_keymaps,
  format_keymaps = format_keymaps,
  get_process_id = get_process_id,
  update_nvim = update_nvim,
  uninstall_plugins = uninstall_plugins,
  commander_creator = commander_creator,
  create_terminal = create_terminal,
  deep_copy = deep_copy,
  apply_borders = apply_borders
}
