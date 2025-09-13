-- [[ Quarto and Jupyter Support ]]
-- Data science notebook support with Python integration

return {
  {
    "quarto-dev/quarto-nvim",
    opts = {
      lspFeatures = {
        enabled = true,
        languages = { "r", "python", "julia", "bash", "html" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" }
        }
      }
    },
    dependencies = {
      "jmbuhr/otter.nvim",
      opts = {},
    },
  },

  {
    "jpalardy/vim-slime",
    init = function()
      vim.g.slime_target = "neovim"
      vim.g.slime_python_ipython = 0  -- Disable global IPython mode
      vim.g.slime_dispatch_ipython_pause = 100
      vim.g.slime_cell_delimiter = "#\\s\\=%%"
      -- vim.g.slime_bracketed_paste = 1
      vim.cmd([[
        function! _EscapeText_quarto(text)
          if slime#config#resolve("python_ipython") && len(split(a:text,"\n")) > 1
            return ["%cpaste -q\n", slime#config#resolve("dispatch_ipython_pause"), a:text, "--\n"]
          else
            let empty_lines_pat = '\(^\|\n\)\zs\(\s*\n\+\)\+'
            let no_empty_lines = substitute(a:text, empty_lines_pat, "", "g")
            let dedent_pat = '\(^\|\n\)\zs'.matchstr(no_empty_lines, '^\s*')
            let dedented_lines = substitute(no_empty_lines, dedent_pat, "", "g")
            let except_pat = '\(elif\|else\|except\|finally\)\@!'
            let add_eol_pat = '\n\s[^\n]\+\n\zs\ze\('.except_pat.'\S\|$\)'
            return substitute(dedented_lines, add_eol_pat, "\n", "g")
          end
        endfunction
      ]])
    end,
    config = function()
      vim.keymap.set({ "n", "i" }, "<leader>xc", function()
        vim.cmd([[ call slime#send_cell() ]])
      end, { desc = "E[x]ecute [c]ell" })
      vim.keymap.set({ "n", "i" }, "<leader>xl", ":SlimeSendCurrentLine<cr>", { desc = "E[x]ecute [l]ine" })
      vim.keymap.set("v", "<leader>xl", ":SlimeSend<cr>", { desc = "E[x]ecute selected [l]ines" })
      
      -- Language-specific REPL keybinds with IPython mode setting
      vim.keymap.set("n", "<leader>cp", function()
        vim.g.slime_python_ipython = 1  -- Enable IPython mode for Python
        vim.cmd("split term://ipython")
      end, { desc = "[C]ode repl [p]ython" })
      
      vim.keymap.set("n", "<leader>cr", function()
        vim.g.slime_python_ipython = 0  -- Disable IPython mode for R
        vim.cmd("split term://poetry run radian")
      end, { desc = "[C]ode repl [r]" })
      
      -- Quarto runner integration
      local runner = require("quarto.runner")
      vim.keymap.set("n", "<localleader>ra", function()
        runner.run_all(true)
      end, { desc = "[R]un [a]ll cells" })
    end,
  },
}
