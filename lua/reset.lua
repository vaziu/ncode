-- ~/.config/nvim/lua/settings.lua

-- Definir a tecla líder
vim.g.mapleader = " "      -- Definir a tecla líder como espaço
vim.g.maplocalleader = "," -- Definir a tecla líder local como vírgula (opcional)

-- Aparência e Layout
vim.opt.number = true          -- Mostrar números de linha
vim.opt.relativenumber = false -- Números de linha relativos
vim.opt.signcolumn = "yes"     -- Mostrar coluna de sinais
vim.opt.colorcolumn = "80"     -- Linha vertical para largura de código
vim.opt.cursorline = true      -- Destacar a linha do cursor

-- Identação e Formatação
vim.opt.tabstop = 2        -- Número de espaços para uma tabulação
vim.opt.shiftwidth = 2     -- Número de espaços para auto indentação
vim.opt.expandtab = true   -- Usar espaços ao invés de tabs
vim.opt.smartindent = true -- Indentação inteligente
vim.opt.smarttab = true    -- Ajustar o tabstop ao número de espaços da indentação

--vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
vim.opt.linebreak = true

-- Pesquisa e Substituição
vim.opt.ignorecase = true -- Ignorar maiúsculas/minúsculas em pesquisas
vim.opt.smartcase = true  -- Sensível a maiúsculas/minúsculas em pesquisas quando maiúsculas são usadas
vim.opt.incsearch = true  -- Pesquisa incremental
vim.opt.hlsearch = true   -- Destacar pesquisas

-- Janelas e Buffers
vim.opt.splitbelow = true -- Dividir janelas horizontalmente abaixo
vim.opt.splitright = true -- Dividir janelas verticalmente à direita
vim.opt.scrolloff = 8     -- Manter 8 linhas visíveis acima e abaixo do cursor
vim.opt.sidescrolloff = 8 -- Manter 8 colunas visíveis à esquerda e à direita do cursor
vim.opt.hidden = true     -- Permitir alternar entre buffers sem salvar
vim.opt.swapfile = true   -- Desativar arquivos de swap
vim.opt.backup = true     -- Desativar arquivos de backup
vim.opt.undofile = true   -- Habilitar undo em arquivos

-- Undo e Redo
vim.opt.undolevels = 1000  -- Número máximo de versões do undo
vim.opt.undoreload = 10000 -- Número de linhas para recarregar o undo
vim.opt.undofile = true    -- Usar arquivo de undo

-- Cursor e Mouse
vim.opt.mouse = "a"          -- Habilitar o uso do mouse em todos os modos
vim.opt.cursorcolumn = false -- Não destacar a coluna do cursor

-- Completação e Menu
vim.opt.pumheight = 10                   -- Altura do menu de completamento
vim.opt.completeopt = "menuone,noselect" -- Configurar opções de completamento

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Conceito Visual
vim.opt.termguicolors = true -- Suporte a cores True Color
vim.opt.background = "dark"  -- Configurar fundo escuro

-- Configura o tema do vim-airline
vim.g.airline_theme = "luna"

-- Ativa fontes do Powerline para o vim-airline
vim.g.airline_powerline_fonts = 1

-- Configuração do vim-buffet
vim.g.buffet_always_show_tabline = 0  -- 0 para mostrar apenas se houver mais de um buffer
vim.g.buffet_powerline_separators = 1 -- Ajuste se você deseja separadores
vim.g.buffet_use_devicons = 1         -- 1 para usar ícones do vim-devicons se disponível

-- Configura o delay de (500 milissegundos) para keymaps acionar comandos
vim.o.timeoutlen = 500

vim.o.winblend = 10
vim.o.pumblend = 10
vim.o.pumheight = 15
