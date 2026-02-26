-- LaTeX-specific configuration
-- This file runs whenever a .tex file is opened

-- Set LaTeX-specific options
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 1 -- Enable concealment for cleaner LaTeX view
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'

-- LaTeX-specific keymaps
local map = vim.keymap.set
local opts = { buffer = true, silent = true }

-- VimTeX keymaps
map('n', '<localleader>ll', '<cmd>VimtexCompile<cr>', vim.tbl_extend('force', opts, { desc = 'VimTeX: Compile' }))
map('n', '<localleader>lv', '<cmd>VimtexView<cr>', vim.tbl_extend('force', opts, { desc = 'VimTeX: View PDF' }))
map('n', '<localleader>ls', '<cmd>VimtexStop<cr>', vim.tbl_extend('force', opts, { desc = 'VimTeX: Stop compilation' }))
map('n', '<localleader>lc', '<cmd>VimtexClean<cr>', vim.tbl_extend('force', opts, { desc = 'VimTeX: Clean auxiliary files' }))
map('n', '<localleader>le', '<cmd>VimtexErrors<cr>', vim.tbl_extend('force', opts, { desc = 'VimTeX: Show errors' }))
map('n', '<localleader>lt', '<cmd>VimtexTocToggle<cr>', vim.tbl_extend('force', opts, { desc = 'VimTeX: Toggle TOC' }))
map('n', '<localleader>lk', '<cmd>VimtexStopAll<cr>', vim.tbl_extend('force', opts, { desc = 'VimTeX: Stop all compilation' }))

-- BibTeX search via mini.pick
map('n', '<leader>lb', function()
  -- Find .bib files: check vimtex context or fall back to glob
  local bib_files = {}
  if vim.b.vimtex and vim.b.vimtex.bib then
    bib_files = vim.b.vimtex.bib
  end
  if #bib_files == 0 then
    bib_files = vim.fn.glob(vim.fn.getcwd() .. '/**/*.bib', false, true)
  end
  if #bib_files == 0 then
    vim.notify('No .bib files found', vim.log.levels.WARN)
    return
  end

  -- Parse BibTeX entries from all files
  local items = {}
  for _, bib_file in ipairs(bib_files) do
    local lines = vim.fn.readfile(bib_file)
    for _, line in ipairs(lines) do
      local key = line:match('^@%w+{(.+),$')
      if key then
        table.insert(items, { text = key, path = bib_file })
      end
    end
  end

  if #items == 0 then
    vim.notify('No BibTeX entries found', vim.log.levels.WARN)
    return
  end

  MiniPick.start({
    source = {
      name = 'BibTeX',
      items = items,
      choose = function(item)
        if item then
          vim.api.nvim_put({ '\\autocite{' .. item.text .. '}' }, 'c', true, true)
        end
      end,
    },
  })
end, vim.tbl_extend('force', opts, { desc = '[L]aTeX [B]ibliography search' }))

-- Text objects for LaTeX
map({'x', 'o'}, 'ie', '<Plug>(vimtex-ie)', { desc = 'LaTeX environment text object (inner)' })
map({'x', 'o'}, 'ae', '<Plug>(vimtex-ae)', { desc = 'LaTeX environment text object (around)' })
map({'x', 'o'}, 'i$', '<Plug>(vimtex-i$)', { desc = 'LaTeX math text object (inner)' })
map({'x', 'o'}, 'a$', '<Plug>(vimtex-a$)', { desc = 'LaTeX math text object (around)' })
map({'x', 'o'}, 'id', '<Plug>(vimtex-id)', { desc = 'LaTeX delimited text object (inner)' })
map({'x', 'o'}, 'ad', '<Plug>(vimtex-ad)', { desc = 'LaTeX delimited text object (around)' })

-- LaTeX-specific abbreviations for common commands
-- Removed abbreviations due to encoding issues with Unicode characters

-- Set local leader for LaTeX-specific commands
vim.g.maplocalleader = ','