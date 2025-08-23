return {
  -- VimTeX: The gold standard for LaTeX editing
  {
    "lervag/vimtex",
    lazy = false, -- Load on startup to ensure proper filetype detection
    ft = { "tex", "bib" },
    config = function()
      -- Set the LaTeX flavor
      vim.g.tex_flavor = "latex"

      -- VimTeX configuration
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_general_viewer = "zathura"

      -- Disable some features we don't need
      vim.g.vimtex_quickfix_mode = 0 -- Disable automatic quickfix window
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "build",
        out_dir = "build",
      }

      -- Enable folding
      vim.g.vimtex_fold_enabled = 1

      -- Concealment settings (optional - hides LaTeX commands for cleaner view)
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        cites = 1,
        fancy = 1,
        spacing = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 0,
        styles = 1,
      }
    end,
  },

  -- Enhanced LaTeX snippets for LuaSnip
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    ft = "tex",
    config = function()
      require("luasnip-latex-snippets").setup({
        use_treesitter = true,
        allow_on_markdown = false,
      })

      -- Enable autosnippets for LaTeX
      require("luasnip").config.setup({
        enable_autosnippets = true,
      })
    end,
  },

  -- Telescope integration for BibTeX
  {
    "nvim-telescope/telescope-bibtex.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    ft = "tex",
    config = function()
      require("telescope").load_extension("bibtex")
    end,
  },
}

