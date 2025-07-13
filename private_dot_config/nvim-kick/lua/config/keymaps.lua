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

-- TODO Telescope keymaps
vim.keymap.set("n", "<leader>sq", function()
  local conf = require("telescope.config").values
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")

  local current_file = vim.fn.expand("%:p")

  -- Get todo-comments configuration
  local todo_config = require("todo-comments.config").options
  local keywords = vim.tbl_keys(todo_config.keywords)

  -- Also check for alt keywords (like FIXME is alt for FIX)
  local all_keywords = {}
  for kw, config in pairs(todo_config.keywords) do
    table.insert(all_keywords, kw)
    if config.alt then
      -- Add alternative keywords
      for _, alt in ipairs(config.alt) do
        table.insert(all_keywords, alt)
      end
    end
  end

  -- Build the search pattern (same as todo-comments does)
  local pattern = [[\b(]] .. table.concat(all_keywords, "|") .. [[)\b(\s*:|\s+)]]

  local opts = {
    prompt_title = "Todo Comments (Current Buffer)",
  }

  local vimgrep_arguments = vim.tbl_flatten({
    conf.vimgrep_arguments,
    "-e",
    pattern,
    "--",
    current_file,
  })

  pickers
    .new(opts, {
      prompt_title = opts.prompt_title,
      layout_strategy = "vertical",
      layout_config = {
        vertical = { preview_cutoff = 20, preview_height = 0.65 },
      },
      finder = finders.new_oneshot_job(vimgrep_arguments, {
        entry_maker = function(line)
          -- Parse the line (format: filename:line:col:text)
          local filename, lnum, col, text = line:match("([^:]+):(%d+):(%d+):(.*)")

          if filename then
            -- Create modified line without the path and filename
            local modified_line = string.format("%s:%s:%s", lnum, col, text)

            -- Create custom entry
            local entry = {
              value = line, -- Keep original for actions
              ordinal = text, -- For filtering
              display = modified_line, -- Display in Telescope
              filename = current_file, -- For preview
              lnum = tonumber(lnum), -- Line number
              col = tonumber(col), -- Column number
              text = text,
            }

            -- Add path for preview to work
            entry.path = current_file

            -- Apply todo-comments highlighting
            entry.display = function()
              -- Find which keyword matches for highlights and where it is
              local keyword_found = nil
              local keyword_start, keyword_end = nil, nil
              local hl_group = nil

              -- Check all keywords
              for _, kw in ipairs(all_keywords) do
                local start_pos, end_pos = text:find("%f[%w]" .. kw .. "%f[%W]")
                if start_pos then
                  keyword_found = kw
                  keyword_start = start_pos
                  keyword_end = end_pos

                  -- Find the highlight group for this keyword
                  -- Check if it's a main keyword
                  local kw_config = todo_config.keywords[kw]
                  if kw_config then
                    hl_group = "TodoBg" .. kw
                  else
                    -- It might be an alt keyword, find its parent
                    for main_kw, config in pairs(todo_config.keywords) do
                      if config.alt then
                        for _, alt in ipairs(config.alt) do
                          if alt == kw then
                            hl_group = "TodoBg" .. main_kw
                            break
                          end
                        end
                      end
                      if hl_group then
                        break
                      end
                    end
                  end
                  break
                end
              end

              -- Build the display with virtual text highlighting
              local display_str = lnum .. ":" .. col .. " " .. text
              local highlights = {}

              -- Highlight line:col
              table.insert(highlights, {
                { 0, #(lnum .. ":" .. col) },
                "TelescopeResultsLineNr",
              })

              -- Highlight only the keyword if found
              if keyword_found and keyword_start then
                local offset = #(lnum .. ":" .. col .. " ")
                table.insert(highlights, {
                  { offset + keyword_start - 1, offset + keyword_end },
                  hl_group or "Comment",
                })
              end

              return display_str, highlights
            end

            return entry
          end
        end,
      }),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(_, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        actions.select_default:replace(function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(prompt_bufnr)
            -- jump to the selected position
            vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
          end
        end)

        return true
      end,
    })
    :find()
end, { desc = "Search todo comments in current buffer" })
vim.keymap.set("n", "<leader>sQ", "<cmd>TodoTelescope<CR>", { desc = "[S]earch TODOs in project ([Q]uickfix)" })
