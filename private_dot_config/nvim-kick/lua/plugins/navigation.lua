-- [[ Navigation and Movement ]]
-- Plugins that enhance navigation and cursor movement

return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          -- Check the keymap assigned to the togle below, in the keys table.
          enabled = true,
        },
        -- options used when flash is activated through
        -- `f`, `F`, `t`, `T`, `;` and `,` motions
        char = {
          jump_labels = true,
          multi_line = false,
          autohide = true,
          jump = {
            autojump = true,
          },
        },
      },
    },
		-- stylua: ignore
    keys = {
            -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },

  -- [[ File Tagging and Project Navigation ]]
  {
    "cbochs/grapple.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      scope = "git",
      quick_select = "123456789",
      icons = true,
    },
    keys = {
      { "<leader>gt", "<cmd>Grapple toggle<cr>", desc = "Toggle grapple tag" },
      { "<leader>gn", "<cmd>Grapple cycle_tags next<cr>", desc = "Next tagged file" },
      { "<leader>gp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Previous tagged file" },
      { "<leader>gm", "<cmd>Grapple open_tags<cr>", desc = "Open grapple menu" },
    },
  },

  -- [[ Motion Hints ]]
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = false,
      showBlankVirtLine = true,
      highlightColor = { link = "Comment" },
      hints = {
        Caret = { text = "^", prio = 2 },
        Dollar = { text = "$", prio = 1 },
        MatchingPair = { text = "%", prio = 5 },
        Zero = { text = "0", prio = 0 },
        w = { text = "w", prio = 10 },
        b = { text = "b", prio = 9 },
        e = { text = "e", prio = 8 },
        W = { text = "W", prio = 7 },
        B = { text = "B", prio = 6 },
        E = { text = "E", prio = 6 },
      },
      targetedMotionHints = {
        enabled = false,
      },
      gutterHints = {
        G = { text = "G", prio = 10 },
        gg = { text = "gg", prio = 9 },
        PrevParagraph = { text = "{", prio = 8 },
        NextParagraph = { text = "}", prio = 8 },
      },
    },
    keys = {
      { "<leader>tp", function() require("precognition").toggle() end, desc = "[T]oggle [P]recognition" },
      { "<leader>tP", function() require("precognition").peek() end, desc = "[T]oggle [P]recognition peek" },
    },
  },

  -- [[ Visual Navigation History ]]
  {
    "cbochs/portal.nvim",
    event = "VeryLazy",
    opts = {
      labels = { "j", "k", "h", "l", "a", "s", "d", "f" },
      max_results = 10,
      lookback = 100,
      select_first = false,
    },
    keys = {
      { "<leader>j", "<cmd>Portal jumplist backward<cr>", desc = "Portal jumplist backward" },
      { "<leader>J", "<cmd>Portal jumplist forward<cr>", desc = "Portal jumplist forward" },
      { "<leader>k", "<cmd>Portal changelist backward<cr>", desc = "Portal changelist backward" },
      { "<leader>K", "<cmd>Portal changelist forward<cr>", desc = "Portal changelist forward" },
    },
  },
}
