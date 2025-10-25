-- ~/.config/nvim/lua/setup_temp_files.lua
-- esse é apenas um test

-- toggle global
if vim.g.tempfiles == nil then
  vim.g.tempfiles = true
end

-- caminhos
local data  = vim.fn.stdpath("data")
local state = vim.fn.stdpath("state")
local cache = vim.fn.stdpath("cache")

local dirs = {
  backup = data  .. "/backup//",
  swap   = state .. "/swap//",
  undo   = state .. "/undo//",
  cache  = cache .. "/", -- conveniência para plugins
}

-- se tempfiles = true → garante diretórios + aplica opts
if vim.g.tempfiles then
  for _, d in pairs(dirs) do
    if vim.fn.isdirectory(d) == 0 then
      vim.fn.mkdir(d, "p")
    end
  end

  vim.opt.backup      = true
  vim.opt.writebackup = true
  vim.opt.swapfile    = true
  vim.opt.undofile    = true
  vim.opt.backupdir   = dirs.backup
  vim.opt.directory   = dirs.swap
  vim.opt.undodir     = dirs.undo
else
  -- senão, desativa tudo
  vim.opt.backup      = false
  vim.opt.writebackup = false
  vim.opt.swapfile    = false
  vim.opt.undofile    = false
end

-- roda depois do boot, assíncrono, 1x por dia
local dirs = { vim.opt.backupdir:get()[1], vim.opt.directory:get()[1], vim.opt.undodir:get()[1] }

local function prune(days)
  for _, d in ipairs(dirs) do
    if d and #d > 0 then
      -- nvim 0.10+:
      vim.system({ "find", d, "-type", "f", "-mtime", "+"..days, "-delete" }, { text = true }, function(_) end)
      -- se estiver em 0.9, use:
      -- vim.fn.jobstart({ "find", d, "-type", "f", "-mtime", "+"..days, "-delete" })
    end
  end
end

-- não roda no exato VimEnter: atrasa 1500ms
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function() prune(7) end, 1500)
  end,
})

