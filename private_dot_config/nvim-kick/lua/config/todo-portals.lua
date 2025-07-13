local M = {}

local function get_buffer_todos()
  local todos = {}
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local patterns = {
    "TODO",
    "FIXME",
    "HACK",
    "WARN",
    "PERF",
    "NOTE",
    "TEST",
    "BUG",
    "OPTIMIZE",
  }

  for line_num, line in ipairs(lines) do
    for _, pattern in ipairs(patterns) do
      if line:match(pattern) then
        table.insert(todos, {
          line = line_num,
          text = line:match("^%s*(.-)%s*$"),
          pattern = pattern,
          bufnr = bufnr,
        })
        break
      end
    end
  end

  return todos
end

function M.create_todo_query()
  local Content = require("portal.content")
  local Iterator = require("portal.iterator")

  return function(opts, settings)
    local todos = get_buffer_todos()

    local iter = Iterator:new(todos):map(function(todo)
      return Content:new({
        type = "todo",
        buffer = todo.bufnr,
        cursor = { row = todo.line, col = 0 },
        callback = function()
          vim.api.nvim_win_set_cursor(0, { todo.line, 0 })
          vim.cmd("normal! zz")
        end,
        extra = {
          pattern = todo.pattern,
          text = todo.text,
        },
      })
    end)

    return {
      source = iter,
    }
  end
end

function M.create_buffer_todo_portals()
  local todos = get_buffer_todos()

  if #todos == 0 then
    vim.notify("No TODO comments found in current buffer", vim.log.levels.INFO)
    return
  end

  local portal = require("portal")
  local query = M.create_todo_query()()

  portal.tunnel(query)

  vim.notify(string.format("Found %d TODO comments", #todos), vim.log.levels.INFO)
end

function M.create_project_todo_portals()
  if pcall(require, "telescope") then
    vim.cmd("TodoTelescope")
  else
    vim.notify("Telescope not available for project TODO search", vim.log.levels.WARN)
  end
end

function M.next_todo()
  local todos = get_buffer_todos()
  if #todos == 0 then
    vim.notify("No TODO comments found in current buffer", vim.log.levels.INFO)
    return
  end

  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local next_todo = nil

  for _, todo in ipairs(todos) do
    if todo.line > current_line then
      next_todo = todo
      break
    end
  end

  if not next_todo then
    next_todo = todos[1]
    vim.notify("Wrapped to first TODO", vim.log.levels.INFO)
  end

  vim.api.nvim_win_set_cursor(0, { next_todo.line, 0 })
  vim.cmd("normal! zz")
end

function M.prev_todo()
  local todos = get_buffer_todos()
  if #todos == 0 then
    vim.notify("No TODO comments found in current buffer", vim.log.levels.INFO)
    return
  end

  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local prev_todo = nil

  for i = #todos, 1, -1 do
    local todo = todos[i]
    if todo.line < current_line then
      prev_todo = todo
      break
    end
  end

  if not prev_todo then
    prev_todo = todos[#todos]
    vim.notify("Wrapped to last TODO", vim.log.levels.INFO)
  end

  vim.api.nvim_win_set_cursor(0, { prev_todo.line, 0 })
  vim.cmd("normal! zz")
end

return M
