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

-- Telescope BibTeX integration
map('n', '<leader>lb', '<cmd>Telescope bibtex<cr>', vim.tbl_extend('force', opts, { desc = '[L]aTeX [B]ibliography search' }))

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