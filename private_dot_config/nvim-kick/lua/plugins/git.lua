-- [[ Git Integration ]]
-- Git-related plugins and configurations

return {
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end, { desc = 'Next git hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end, { desc = 'Previous git hunk' })

        -- Actions
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview git hunk' })
        map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, { desc = 'Blame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end, { desc = 'Diff this ~' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
        map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Stage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Reset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
      end,
    },
  },
}
