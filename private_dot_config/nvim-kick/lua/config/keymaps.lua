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

-- TODO search keymaps
vim.keymap.set("n", "<leader>sq", function()
  local current_file = vim.fn.expand("%:p")
  local todo_config = require("todo-comments.config").options

  local all_keywords = {}
  for kw, kw_conf in pairs(todo_config.keywords) do
    table.insert(all_keywords, kw)
    if kw_conf.alt then
      for _, alt in ipairs(kw_conf.alt) do
        table.insert(all_keywords, alt)
      end
    end
  end

  local pattern = [[\b(]] .. table.concat(all_keywords, "|") .. [[)\b(\s*:|\s+)]]
  local cmd = { "rg", "--vimgrep", "-e", pattern, "--", current_file }

  local handle = io.popen(table.concat(cmd, " ") .. " 2>/dev/null")
  if not handle then return end
  local output = handle:read("*a")
  handle:close()

  local items = {}
  for line in output:gmatch("[^\n]+") do
    local filename, lnum, col, text = line:match("([^:]+):(%d+):(%d+):(.*)")
    if filename then
      table.insert(items, {
        path = current_file,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = lnum .. ":" .. col .. " " .. text,
      })
    end
  end

  if #items == 0 then
    vim.notify("No TODO comments in current buffer", vim.log.levels.INFO)
    return
  end

  MiniPick.start({
    source = {
      name = "TODO (current buffer)",
      items = items,
      show = function(buf_id, items_to_show, query)
        MiniPick.default_show(buf_id, items_to_show, query)
      end,
      choose = function(item)
        if item then
          vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
        end
      end,
    },
  })
end, { desc = "Search todo comments in current buffer" })

vim.keymap.set("n", "<leader>sQ", "<cmd>TodoQuickFix<CR>", { desc = "[S]earch TODOs in project ([Q]uickfix)" })

-- Word wrap toggle
vim.keymap.set("n", "<leader>tw", function()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
  print("Word wrap " .. (vim.opt_local.wrap:get() and "enabled" or "disabled"))
end, { desc = "[T]oggle [W]ord wrap" })

-- Neominimap controls
vim.keymap.set("n", "<leader>mm", "<cmd>Neominimap Toggle<cr>", { desc = "Toggle [M]ini[m]ap" })
vim.keymap.set("n", "<leader>mo", "<cmd>Neominimap Enable<cr>", { desc = "[M]inimap [O]n" })
vim.keymap.set("n", "<leader>mc", "<cmd>Neominimap Disable<cr>", { desc = "[M]inimap [C]lose" })
vim.keymap.set("n", "<leader>mr", "<cmd>Neominimap Refresh<cr>", { desc = "[M]inimap [R]efresh" })
