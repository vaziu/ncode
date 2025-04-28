local cmp = require("cmp")
local wk = require("which-key")
local utils = require("utils")

local commander = utils.commander_creator()
local terminal = utils.create_terminal()
-- Armazene a instância no global para fácil acesso
_G.commander = commander

wk.register({
  ["o"] = { function() require("functions").create_file() end, "Create file" },
  ["k"] = { ':lua require("telescope.builtin").keymaps()<CR>', "Show keymaps" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["q"] = { "<cmd>qa!<CR>", "Close all without save" },
  ["c"] = { "<cmd>lua require('notify').dismiss()<CR>", "Close notifications" },
  ["n"] = { "<cmd>enew<CR>", "Create new buffer" },
  ["a"] = { function() require("nvim-window").pick() end, "Windows navigation" },
  ["f"] = {
    function()
      vim.lsp.buf.format()
    end,
    "Format (LSP)",
  },
}, {
  mode = "n",             -- Modo normal
  prefix = "<header>k",   -- Prefixo específico
  name = "Basic Keymaps", -- Nome do grupo
})

wk.register({
  s = {
    name = "Split Windows",
    ["v"] = { ":vsp<CR>", "Vertical split" },
    ["h"] = { ":sp<CR>", "Horizontal split" },
  },
  r = {
    name = "Resize Windows",
    ["h"] = { ":WinShiftResizeLeft<CR>", "Resize window left" },
    ["j"] = { ":WinShiftResizeDown<CR>", "Resize window down" },
    ["k"] = { ":WinShiftResizeUp<CR>", "Resize window up" },
    ["l"] = { ":WinShiftResizeRight<CR>", "Resize window right" },
  },
  m = {
    name = "Move Windows",
    ["h"] = { "<cmd>WinShiftLeft<CR>", "Move window left" },
    ["j"] = { "<cmd>WinShiftDown<CR>", "Move window down" },
    ["k"] = { "<cmd>WinShiftUp<CR>", "Move window up" },
    ["l"] = { "<cmd>WinShiftRight<CR>", "Move window right" },
  },
  ["n"] = { function() require("nvim-window").pick() end, "Windows navigation" },

}, {
  mode = "n",               -- Modo normal
  prefix = "<leader>w",     -- Prefixo específico
  name = "Windows Manager", -- Nome do grupo
})

wk.register({

  s = {
    name = "Save",
    f = { function() require("functions").save_buffer_to_directory() end, "Save to directory" },
  },

  c = {
    name = "Closing Buffers",
    ["q"] = { "<cmd>bd!<CR>", "Close current buffer" },
    ["o"] = { "<cmd>BufferLineCloseOthers<CR>", "Close other buffers" },
    ["p"] = { "<cmd>BufferLinePickClose<CR>", "Pick and close buffer" },
  },

  n = {
    name = "Buffer Navigation",
    b = { function() require("buffer_manager.ui").toggle_quick_menu() end, "Escolher Buffer" },
    j = { function() require('buffer_manage.ui').next_buffer() end, "Próximo Buffer" },
    k = { function() require('buffer_manager.ui').prev_buffer() end, "Buffer Anterior" },
    ["p"] = { "<cmd>BufferLinePick<CR>", "Pick buffer and enter" },
    ["l"] = { "<cmd>BufferLineCycleNext<CR>", "Next buffer" },
    ["h"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous buffer" },
  },
}, {
  mode = "n",              -- Modo normal
  prefix = "<leader>b",    -- Prefixo específico
  name = "Buffer Manager", -- Nome do grupo
})

-- Certifique-se de ter o which-key instalado e carregado

-- Registra as teclas de atalho
wk.register({
    ["r"] = {
      function()
        local word = vim.fn.expand("<cword>")                               -- Obtém a palavra sob o cursor
        local replacement = vim.fn.input("Replace '" .. word .. "' with: ") -- Solicita o novo valor
        if replacement ~= "" then                                           -- Verifica se o usuário forneceu um valor
          local cmd = string.format("%%s/%s/%s/gc", vim.fn.escape(word, "/"), vim.fn.escape(replacement, "/"))
          vim.cmd(cmd)                                                      -- Executa o comando de substituição com confirmação
        end
      end,
      "Replace local occurrences"
    },
    ["g"] = {
      "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Search for > ') })<CR>",
      "Find global references"
    },
    ["c"] = {
      "<cmd>noh<CR>", "Clear highlights"
    },
    ["s"] = {
      function()
        vim.fn.feedkeys("/") -- Simula a tecla `/` para iniciar a pesquisa
      end,
      "Start search"
    },
    ["b"] = {
      function()
        vim.fn.feedkeys("?") -- Simula a tecla `?` para iniciar a pesquisa para trás
      end,
      "Start backward search"
    },
    ["n"] = {
      "n", "Next search result"
    }, -- Navega para o próximo resultado da pesquisa
    ["p"] = {
      "N", "Previous search result"
    }, -- Navega para o resultado anterior da pesquisa
  },
  {
    mode = "n",                -- Modo normal
    prefix = "<leader>s",      -- Prefixo específico
    name = "Search & Replace", -- Nome do grupo
  })


wk.register({
  ["t"] = { "<cmd>NvimTreeToggle<CR>", "Toggle explorer" },
}, {
  mode = "n",              -- Modo normal
  prefix = "<leader>e",    -- Prefixo específico
  name = "Files Explorer", -- Nome do grupo
})

wk.register({
  ["f"] = { function() require("telescope.builtin").find_files() end, "Find files" },
  ["g"] = { function() require("telescope.builtin").live_grep() end, "Live grep" },
  ["b"] = { function() require("telescope.builtin").buffers() end, "Display open buffers" },
  ["h"] = { function() require("telescope.builtin").help_tags() end, "Help tags" },

  ["c"] = { function() require("functions").create_file() end, "Create files" },
}, {
  mode = "n",             -- Modo normal
  prefix = "<leader>f",   -- Prefixo específico
  name = "Files Manager", -- Nome do grupo
})

wk.register({
  ["x"] = { "<cmd>Trouble diagnostics toggle<CR>", "Toggle diagnostics" },
  ["t"] = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint" },
  ["r"] = { "<cmd>lua require'dap'.repl.open()<CR>", "Open REPL" },
  ["l"] = { "<cmd>lua require'dap'.run_last()<CR>", "Run last" },
  ["b"] = {
    "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    "Set conditional breakpoint",
  },
  ["p"] = { "<cmd>lua require'dap'.pause()<CR>", "Pause debugging" },
  ["f"] = { "<cmd>lua require'dap'.terminate()<CR>", "Finish debugging" },
  ["<F5>"] = { "<cmd>lua require('dap_ui').select_dap_config()<CR>", "Start debugging" },
  ["<F10>"] = { "<cmd>lua require'dap'.step_over()<CR>", "Step over" },
  ["<F11>"] = { "<cmd>lua require'dap'.step_into()<CR>", "Step into" },
  ["<F12>"] = { "<cmd>lua require'dap'.step_out()<CR>", "Step out" },
}, {
  mode = "n",           -- Modo normal
  prefix = "<leader>d", -- Prefixo específico
  name = "Debugger",    -- Nome do grupo
})

wk.register({
  ["h"] = { "<Cmd>Lspsaga hover_doc<CR>", "Hover documentation" },
  ["p"] = { "<Cmd>Lspsaga preview_definition<CR>", "Preview definition" },
  ["a"] = { "<Cmd>Lspsaga code_action<CR>", "Code action" },
  ["r"] = { "<Cmd>Lspsaga rename<CR>", "Rename" },
  ["f"] = { "<Cmd>Lspsaga lsp_finder<CR>", "Find LSP references" },
  ["e"] = { "<Cmd>Lspsaga show_line_diagnostics<CR>", "Show line diagnostics" },
  ["j"] = { "<Cmd>Lspsaga diagnostic_jump_next<CR>", "Jump to next diagnostic" },
  ["k"] = { "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Jump to previous diagnostic" },
  ["d"] = { "<Cmd>Lspsaga goto_definition<CR>", "Go to definition" },
  ["o"] = { "<Cmd>Lspsaga outline<CR>", "Show outline" },
  ["l"] = {
    "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
    "Toggle line comment",
  },
  ["b"] = {
    "<cmd>lua require('Comment.api').toggle.blockwise()<CR>",
    "Toggle block comment",
  },
  ["i"] = {
    function()
      vim.lsp.buf.implementation()
    end,
    "Go to implementation (LSP)",
  },
}, {
  mode = "n",               -- Modo normal
  prefix = "<leader>c",     -- Prefixo específico
  name = "Code Operations", -- Nome do grupo
})

wk.register({
  ["l"] = {
    "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
    "Toggle line comment",
  },
  ["b"] = {
    "<cmd>lua require('Comment.api').toggle.blockwise()<CR>",
    "Toggle block comment",
  },
  ["f"] = {
    function()
      vim.lsp.buf.format()
    end,
    "Format (LSP)",
  },
}, {
  mode = "v",               -- Modo normal
  prefix = "<leader>c",     -- Prefixo específico
  name = "Code Operations", -- Nome do grupo
})

wk.register({
  ["<C-k>"] = { cmp.mapping.scroll_docs(-4), "Scroll docs up" },
  ["<C-j>"] = { cmp.mapping.scroll_docs(4), "Scroll docs down" },
  ["<C-Space>"] = { cmp.mapping.complete(), "Trigger completion" },
  ["<C-e>"] = { cmp.mapping.abort(), "Abort completion" },
  ["<C-y>"] = { cmp.mapping.confirm({ select = true }), "Confirm completion" },
  ["<C-n>"] = {
    function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    "Select next item or expand/jump snippet",
  },
  ["<C-p>"] = {
    function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
    "Select previous item or jump back in snippet",
  },
}, {
  mode = { "i", "s" },   -- Modos inserção e substituição
  prefix = "<leader>a",  -- Prefixo específico
  name = "Autocomplete", -- Nome do grupo
})


wk.register({
  -- Mapeamentos padrão do plugin easycolor.nvim
  p = {
    "<cmd>EasyColor<cr>",
    "Color Picker",                                                       -- Atalho para abrir o seletor de cores
  },
  q = { "<cmd>EasyColorClose<cr>", "Close Picker" },                      -- Fechar o seletor de cores
  j = { "<cmd>EasyColorMoveCursorDown<cr>", "Move Cursor Down" },         -- Mover cursor para baixo
  k = { "<cmd>EasyColorMoveCursorUp<cr>", "Move Cursor Up" },             -- Mover cursor para cima
  h = { "<cmd>EasyColorMoveCursorLeft<cr>", "Move Cursor Left" },         -- Mover cursor para a esquerda
  l = { "<cmd>EasyColorMoveCursorRight<cr>", "Move Cursor Right" },       -- Mover cursor para a direita
  ["<Down>"] = { "<cmd>EasyColorHueDown<cr>", "Hue Down" },               -- Diminuir a tonalidade
  ["<Up>"] = { "<cmd>EasyColorHueUp<cr>", "Hue Up" },                     -- Aumentar a tonalidade
  ["<Enter>"] = { "<cmd>EasyColorInsert<cr>", "Insert Color" },           -- Inserir a cor selecionada
  t = { "<cmd>EasyColorEditFormatting<cr>", "Edit Formatting Template" }, -- Editar o modelo de formatação
}, {
  mode = "n",
  prefix = "<leader>p",
  name = "ColorPicker",
})

-- Git normal mode

wk.register({
  -- Git Hunks
  h = {
    name = "Git Hunks",
    s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
    u = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo Stage" },
    r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
    p = { "<cmd>Gitsigns preview_hunk<CR>", "Preview Hunk" },
    d = { "<cmd>Gitsigns diffthis<CR>", "Diff This" },
    j = { "<cmd>Gitsigns next_hunk<CR>", "Next Hunk" },
    k = { "<cmd>Gitsigns prev_hunk<CR>", "Previous Hunk" },
  },
  -- Git Blame
  b = {
    name = "Git Blame",
    b = { "<cmd>GitBlameToggle<CR>", "Toggle Blame" },
    o = { "<cmd>GitBlameOpenCommitURL<CR>", "Open Commit URL" },
  },
  -- Git Diff
  d = {
    name = "Git Diff",
    l = { "<cmd>DiffviewSelectNextEntry<CR>", "Next Diff Entry" },
    h = { "<cmd>DiffviewSelectPrevEntry<CR>", "Previous Diff Entry" },
    j = { "<cmd>DiffviewNextEntry<CR>", "Next File Panel Entry" },
    k = { "<cmd>DiffviewPrevEntry<CR>", "Previous File Panel Entry" },
    q = { "<cmd>DiffviewClose<CR>", "Close Diffview" },
    o = { "<cmd>DiffviewOpen<CR>", "Open Diffview" },
  },
  -- Git All
  a = {
    name = "Git All",
    n = { "<cmd>Neogit<CR>", "Open Neogit" },
    c = { "<cmd>Neogit commit<CR>", "Open Commit Popup" },
    b = { "<cmd>Neogit branch<CR>", "Open Branch Popup" },
    p = { "<cmd>Neogit push<CR>", "Push Changes" },
    f = { "<cmd>Neogit fetch<CR>", "Fetch Changes" },
    m = { "<cmd>Neogit merge<CR>", "Open Merge Popup" },
    r = { "<cmd>Neogit rebase<CR>", "Open Rebase Popup" },
    l = { "<cmd>Neogit log<CR>", "Open Log Popup" },
    t = { "<cmd>Neogit tag<CR>", "Open Tag Popup" },
  },
}, {
  mode = "n",
  prefix = "<leader>g",
  name = "Git Tools",
})

--  Git  visual mode
wk.register({
  -- Git Hunks (Visual Mode)
  h = {
    name = "Git Hunks",
    s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
    u = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo Stage" },
    r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
    p = { "<cmd>Gitsigns preview_hunk<CR>", "Preview Hunk" },
  },
  -- Git Diff (Visual Mode)
  d = {
    name = "Git Diff",
    o = { "<cmd>DiffviewOpen<CR>", "Open Diffview" },
    q = { "<cmd>DiffviewClose<CR>", "Close Diffview" },
  },
}, {
  mode = "v",
  prefix = "<leader>g",
  name = "Git Tools",
})

wk.register({
  mode = { "v", "n" },
  name = "Plugins Manager",
  p = { function() utils.uninstall_plugins() end, "Uninstall plugins" },
}, { prefix = "<leader>u" })

wk.register({
  m = {
    name = "Move text",
    ["j"] = { function() commander.register("<Plug>GoNMLineDown") end, "Move Line Down" },
    ["k"] = { function() commander.register("<Plug>GoNMLineUp") end, "Move Line Up" },
    ["h"] = { function() commander.register("<Plug>GoNMLineLeft") end, "Move Line Left" },
    ["l"] = { function() commander.register("<Plug>GoNMLineRight") end, "Move Line Right" },
  },
  d = {
    name = "Duplicate text",
    ["j"] = { function() commander.register("<Plug>GoNDLineDown") end, "Duplicate Line Down" },
    ["k"] = { function() commander.register("<Plug>GoNDLineUp") end, "Duplicate Line Up" },
  }
}, { mode = "n", prefix = "<leader>t", name = "Text Motions" })

wk.register({
  -- Mapeamentos no modo visual
  ["<S-h>"] = { "<Plug>GoVSMLeft", "Move Left" },
  ["<S-j>"] = { "<Plug>GoVSMDown", "Move Down" },
  ["<S-k>"] = { "<Plug>GoVSMUp", "Move Up" },
  ["<S-l>"] = { "<Plug>GoVSMRight", "Move Right" },
  ["<C-h>"] = { "<Plug>GoVSDLeft", "Duplicate leftwards" },
  ["<C-j>"] = { "<Plug>GoVSDDown", "Duplicate downwards" },
  ["<C-k>"] = { "<Plug>GoVSDUp", "Duplicate upwards" },
  ["<C-l>"] = { "<Plug>GoVSDRight", "Duplicate rightwards" },
}, { mode = { "n", "x" } })
-- Mapeia a tecla para repetir o último comando
wk.register({
  function() commander.repeat_last() end, "Repeat Last Motion"
}, { mode = { "n", "x" }, prefix = ".", name = "Repeat Text Motion" })

-- Registra os keymaps para o vim-visual-multi
wk.register({
  m = {
    name = "Multi Cursor",
    ["l"] = {
      function()
        commander.register("<Plug>(VM-Find-Under)")
      end,
      "Add Cursor to Next Occurrence"
    },
    ["h"] = {
      function()
        commander.register("<Plug>(VM-Find-Subword-Under)")
      end,
      "Add Cursor to Previous Occurrence"
    },
    ["k"] = {
      function()
        commander.register("<Plug>(VM-Add-Cursor-Up)")
      end,
      "Add Cursor Up"
    },
    ["j"] = {
      function()
        commander.register("<Plug>(VM-Add-Cursor-Down)")
      end,
      "Add Cursor Down"
    },
    ["x"] = {
      function()
        commander.register("<Plug>(VM-Remove-Cursor)")
      end,
      "Remove Current Cursor"
    },
    ["n"] = {
      function()
        commander.register("<Plug>(VM-Find-Next)")
      end,
      "Find Next Occurrence"
    },
    ["p"] = {
      function()
        commander.register("<Plug>(VM-Find-Prev)")
      end,
      "Find Previous Occurrence"
    },
    ["y"] = {
      function()
        commander.register("<Plug>(VM-Select-All)")
      end,
      "Select All Lines"
    }
  }
}, { mode = { "n", "x" }, prefix = "<leader>", name = "Multi Cursor" })

-- Symbols Navigators

wk.register({
  o = {
    name = "Symbols (Sidebar)",
    ["t"] = { "<cmd>Outline<cr>", "Toggle Outline" },
  }
}, { mode = "n", prefix = "<leader>" })

local actions = require("nvim-navbuddy.actions")

wk.register({
  n = {
    name = "Symbols (Popup)",

    ["t"] = { "<cmd>lua require('nvim-navbuddy').open()<CR>", "Open Navbuddy" },

    ["<esc>"] = { actions.close, "Close Navbuddy" },
    ["q"] = { actions.close, "Close Navbuddy" },

    ["j"] = { actions.next_sibling, "Next Sibling" },
    ["k"] = { actions.previous_sibling, "Previous Sibling" },

    ["h"] = { actions.parent, "Parent" },
    ["l"] = { actions.children, "Children" },
    ["0"] = { actions.root, "Root" },

    ["v"] = { actions.visual_name, "Visual Selection of Name" },
    ["V"] = { actions.visual_scope, "Visual Selection of Scope" },

    ["y"] = { actions.yank_name, "Yank Name" },
    ["Y"] = { actions.yank_scope, "Yank Scope" },

    ["i"] = { actions.insert_name, "Insert at Start of Name" },
    ["I"] = { actions.insert_scope, "Insert at Start of Scope" },

    ["a"] = { actions.append_name, "Append to End of Name" },
    ["A"] = { actions.append_scope, "Append to End of Scope" },

    ["r"] = { actions.rename, "Rename" },

    ["d"] = { actions.delete, "Delete" },

    ["f"] = { actions.fold_create, "Create Fold" },
    ["F"] = { actions.fold_delete, "Delete Fold" },

    ["c"] = { actions.comment, "Comment Out" },

    ["<enter>"] = { actions.select, "Select" },
    ["o"] = { actions.select, "Select" },

    ["J"] = { actions.move_down, "Move Down" },
    ["K"] = { actions.move_up, "Move Up" },

    ["s"] = { actions.toggle_preview, "Toggle Preview" },

    ["<C-v>"] = { actions.vsplit, "Vertical Split" },
    ["<C-s>"] = { actions.hsplit, "Horizontal Split" },

    ["p"] = {
      function()
        actions.telescope({
          layout_config = {
            height = 0.60,
            width = 0.60,
            prompt_position = "top",
            preview_width = 0.50,
          },
          layout_strategy = "vertical",
        })
      end,
      "Telescope",
    },

    ["g?"] = { actions.help, "Help" },
  },
}, {
  mode = "n",          -- Normal mode
  prefix = "<leader>", -- Prefix
  name = "",           -- Group name
})

wk.register({
  z = {
    name = "Terminal",
    f = { function() terminal.create_floating_terminal() end, "Floating Terminal" },
    v = { function() terminal.create_vertical_terminal() end, "Vertical Terminal" },
    h = { function() terminal.create_horizontal_terminal() end, "Horizontal Terminal" },
    t = { function() terminal.create_tab_terminal() end, "Tab Terminal" },
    n = { function() terminal.switch_next_terminal() end, "Next Terminal" },
    p = { function() terminal.switch_previous_terminal() end, "Previous Terminal" },
    H = { function() terminal.hide_all_terminals() end, "Hide All Terminals" },
    S = { function() terminal.show_all_terminals() end, "Show All Terminals" },
  }
}, { prefix = "<leader>" })

-- Adicionar a seção de keymaps para ZeroTest
-- Adicionar no keymaps.lua existente do ncode

-- Registrar keymaps do ZeroTest

wk.register({
  ["<leader>a"] = {
    name = "AI Assistant",
    c = { ":lua require('zerotest').chat()<CR>", "Abrir Chat com IA" },
    u = { ":lua require('zerotest').test_unit()<CR>", "Gerar Testes Unitários" },
    i = { ":lua require('zerotest').test_integration()<CR>", "Gerar Testes de Integração" },
    e = { ":lua require('zerotest').test_e2e()<CR>", "Gerar Testes End-to-End" },
    a = { ":lua require('zerotest').ask('Olá, IA!')<CR>", "Perguntar à IA (Prompt Personalizado)" },
  }
}, { mode = "n" })
