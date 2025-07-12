-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Clear search highlighting on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Quarto keybinds
vim.keymap.set("n", "<m-i>", "i```{python}<cr>```<esc>O", { desc = "[I]nsert code chunk" })
vim.keymap.set("n", "<leader>ci", ":split term://ipython<cr>", { desc = "[C]ode repl [i]python" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows
-- See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Better indenting (prevents from losing visual selection upon indenting)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- TODO-Portal integration keymaps
local todo_portals = require("config.todo-portals")

vim.keymap.set("n", "<leader>pt", todo_portals.create_buffer_todo_portals, { desc = "Portal: TODOs in buffer" })

vim.keymap.set("n", "<leader>pT", function()
  todo_portals.create_project_todo_portals()
end, { desc = "Portal: TODOs in project" })

vim.keymap.set("n", "]t", todo_portals.next_todo, { desc = "Next TODO" })
vim.keymap.set("n", "[t", todo_portals.prev_todo, { desc = "Previous TODO" })
