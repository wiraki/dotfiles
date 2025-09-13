-- R-specific vim-slime configuration
vim.b.slime_cell_delimiter = "```"
vim.b.slime_bracketed_paste = 0  -- Disable bracketed paste for R multi-line support

-- Optional: Add paragraph sending for logical R code blocks
vim.keymap.set("n", "<localleader>sp", "<Plug>SlimeParagraphSend", { buffer = true, desc = "Send [p]aragraph" })