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
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
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
