-- [[ UI-related plugins ]]
-- Colorschemes, statuslines, and visual enhancements

return {
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Pick colorscheme`.
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme("tokyonight-moon")

      -- You can configure highlights by doing something like:
      vim.cmd.hi("Comment gui=none")
    end,
  },

  {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    opts = {
      flavour = "macchiato",
      dim_inactive = {
        enabled = false,
        percentage = 0.1,
      },
    },
    init = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
      highlight = {
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
        highlight = "LineNr",
      },
    },
  },

  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      -- render = "virtual",
      virtual_symbol_suffix = "",
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require("which-key").setup()

      -- Document existing key chains
      require("which-key").add({
        { "<leader>b", group = "[B]uffer" },
        { "<leader>b_", hidden = true },
        { "<leader>c", group = "[C]ode" },
        { "<leader>c_", hidden = true },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>d_", hidden = true },
        { "<leader>g", group = "[G]rapple" },
        { "<leader>g_", hidden = true },
        { "<leader>r", group = "[R]ename" },
        { "<leader>r_", hidden = true },
        { "<leader>s", group = "[S]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>t_", hidden = true },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>w_", hidden = true },
        { "<leader>x", group = "E[x]ecute" },
        { "<leader>x_", hidden = true },
        { "<leader>p", group = "[P]ortal" },
        { "<leader>p_", hidden = true },
        { "<leader>h", group = "Git [H]unk" },
        { "<leader>h_", hidden = true },
        {
          -- visual mode
          mode = "v",
          { "<leader>h", desc = "Git [H]unk" },
        },
      })
    end,
  },
  {
    "tadaa/vimade",
    event = "VeryLazy",
    opts = {
      ncmode = "windows",
      fadelevel = 0.6,
    },
  },

}
