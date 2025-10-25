local Input = require("nui.input")
local Path = require("plenary.path")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values



-- Função para obter o diretório de trabalho atual
local function get_current_working_directory()
  return vim.fn.getcwd()
end

-- Função para verificar se um caminho é um diretório
local function is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

-- Função para verificar se um caminho é um arquivo
local function is_file(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "file"
end

-- Função para dividir o caminho e arquivos
local function splitFileAndPaths(input_str)
  local path, files_str = input_str:match("^(.-)/([^/]+)$")
  if not path then
    path = ""
    files_str = input_str
  end

  local files = vim.split(files_str, "+", { trimempty = true })

  return { path = path, files = files }
end

-- Função para gerar caminhos completos para arquivos
local function get_full_files_path(data)
  local base_path = get_current_working_directory()
  local full_paths = {}

  for _, file in ipairs(data.files) do
    local full_path = Path:new(base_path, data.path, file):absolute()
    table.insert(full_paths, full_path)
  end

  return full_paths
end

-- Função para perguntar ao usuário se deseja substituir um arquivo
local function ask_to_replace(full_path, callback)
  local popup = Input({
    position = "50%",
    size = {
      width = 40,
    },
    border = {
      style = "rounded",
      text = {
        top = "Confirm Replacement",
        top_align = "center",
      },
    },
    win_options = {
      winblend = 10,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  }, {
    prompt = "O arquivo " .. full_path .. " já existe. Deseja substituí-lo? (y/n): ",
    on_submit = function(value)
      if value:lower() == "y" then
        callback()
      else
        vim.notify("Arquivo não substituído: " .. full_path, vim.log.levels.INFO)
      end
    end,
  })

  popup:mount()
end

-- Função para criar arquivos e pastas
local function create_files_and_dirs(input_str)
  local data = splitFileAndPaths(input_str)
  local full_paths = get_full_files_path(data)

  for _, full_path in ipairs(full_paths) do
    local path_obj = Path:new(full_path)
    local parent_dir = path_obj:parent():absolute()

    -- Cria o diretório pai se necessário
    if not is_directory(parent_dir) then
      Path:new(parent_dir):mkdir({ parents = true })
    end

    -- Verifica se o caminho é um diretório ou um arquivo existente
    if is_directory(full_path) then
      vim.notify("O diretório já existe: " .. full_path, vim.log.levels.INFO)
    elseif is_file(full_path) then
      ask_to_replace(full_path, function()
        path_obj:write("", "w")
        vim.notify("Arquivo substituído: " .. full_path)
      end)
    else
      path_obj:write("", "w")
      vim.notify("Arquivo criado: " .. full_path)
    end
  end
end

-- Função para abrir o popup e capturar o input do usuário
local function create_file()
  local popup = Input({
    position = "50%",
    size = {
      width = 40,
    },
    border = {
      style = "rounded",
      text = {
        top = "Create Files/Dirs",
        top_align = "center",
      },
    },
    win_options = {
      winblend = 10,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  }, {
    prompt = "> ",
    on_submit = function(value)
      create_files_and_dirs(value)
    end,
  })

  popup:mount()

  -- unmount input by pressing `<Esc>` in normal mode
  popup:map("n", "<Esc>", function()
    popup:unmount()
  end, { noremap = true })
end

local function save_buffer_to_directory()
  local bufnr = vim.api.nvim_get_current_buf()
  local notify = require('notify')
  local Input = require("nui.input")
  local event = require("nui.utils.autocmd").event

  -- Função para salvar após selecionar o diretório
  local function save_in_dir(dir)
    -- Variável local para armazenar o popup
    local popup

    popup = Input({
      position = "50%",
      size = {
        width = 62,
      },
      border = {
        style = "rounded",
        text = {
          top = " Nome do Arquivo ",
          top_align = "center",
        },
      },
      win_options = {
        winblend = 10,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      relative = "editor",
      row = 0.4, -- Posiciona o popup um pouco acima do centro vertical
    }, {
      prompt = "> ",
      default_value = vim.fn.expand('%:t'), -- Sugere o nome do arquivo atual
      on_submit = function(filename)
        if not filename or filename == "" then
          notify("❌ Nome de arquivo inválido.", vim.log.levels.ERROR, {
            title = "Salvar Arquivo",
            timeout = 2000,
            render = "minimal"
          })
          return
        end

        local Path = require("plenary.path")
        local target_path = Path:new(dir, filename)

        -- Cria diretórios pai se não existirem
        target_path:parent():mkdir({ parents = true })

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local content = table.concat(lines, "\n")

        -- Salva o arquivo
        target_path:write(content, "w")

        -- Usa nvim-notify para feedback bonito
        notify("💾 Arquivo salvo com sucesso!", vim.log.levels.INFO, {
          title = "Salvar Arquivo",
          timeout = 3000,
          render = "default",
          stages = "slide"
        })

        -- Fecha o buffer atual
        vim.api.nvim_buf_delete(bufnr, { force = true })

        -- Abre o novo arquivo
        vim.cmd("edit " .. target_path:absolute())

        -- Fecha o popup após salvar
        if popup then
          popup:unmount()
        end
      end,
    })

    -- Monta o popup
    popup:mount()

    -- Adiciona mapeamento para fechar com ESC
    popup:map("n", "<Esc>", function()
      popup:unmount()
    end, { noremap = true })

    -- Foco automático no input
    vim.cmd("startinsert")
  end

  -- Usa Telescope para seleção de diretório com UI melhorada
  require('telescope.builtin').find_files({
    prompt_title = "📂 Selecione o diretório para salvar",
    find_command = { "fd", "--type", "d" },
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)

        if selection then
          save_in_dir(selection[1])
        else
          notify("❌ Nenhum diretório selecionado.", vim.log.levels.WARN, {
            title = "Salvar Arquivo",
            timeout = 2000
          })
        end
      end)
      return true
    end,
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.7,
      height = 0.6,
      preview_height = 0.4,
      prompt_position = "top"
    }
  })
end

return {
  create_file = create_file,
  save_buffer_to_directory = save_buffer_to_directory
}
