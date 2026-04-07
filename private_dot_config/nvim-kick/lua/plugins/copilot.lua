-- [[ GitHub Copilot Integration ]]
-- AI-powered code completion using GitHub Copilot
-- This plugin provides the core Copilot functionality

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- Disable suggestion and panel modules to prevent conflicts with blink.cmp
        -- The blink-cmp-copilot plugin will handle completions instead
        suggestion = { enabled = false },
        panel = { enabled = false },

        -- Optional: Configure filetypes where Copilot should be enabled
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },

        copilot_node_command = vim.fn.expand("~/.local/share/mise/shims/node"),
      })
    end,
  },
}
