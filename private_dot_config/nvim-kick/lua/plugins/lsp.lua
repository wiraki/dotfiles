-- [[ LSP Configuration & Plugins ]]
-- Language Server Protocol configuration

return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },

      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  To jump back, press <C-t>.
          map("gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          map("gI", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          map("<leader>D", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          map("<leader>ds", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          map("<leader>ws", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, "[T]oggle Inlay [H]ints")
          end
          if client and client.name == "basedpyright" then
            -- Check if we're in a Python project with pyproject.toml
            if vim.fn.filereadable("pyproject.toml") == 1 then
              local python_path = nil
              
              -- Try uv first (check for .venv directory)
              if vim.fn.isdirectory(".venv") == 1 then
                python_path = vim.fn.getcwd() .. "/.venv/bin/python"
                if vim.fn.filereadable(python_path) == 1 then
                  print("Detected uv environment: " .. python_path)
                else
                  python_path = nil
                end
              end
              
              -- Fallback to Poetry if uv environment not found
              if not python_path then
                local handle = io.popen("poetry env info --path 2>/dev/null")
                if handle then
                  local poetry_venv = handle:read("*a"):gsub("%s+", "")
                  handle:close()

                  if poetry_venv and poetry_venv ~= "" then
                    python_path = poetry_venv .. "/bin/python"
                    print("Detected Poetry environment: " .. poetry_venv)
                  end
                end
              end
              
              -- Apply the detected Python path
              if python_path then
                client.config.settings.python.pythonPath = python_path
                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
              end
            end
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      vim.lsp.config("texlab", {
        capabilities = capabilities,
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              onSave = false,
            },
            forwardSearch = {
              executable = "zathura",
              args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            chktex = {
              onOpenAndSave = false,
            },
          },
        },
      })

      vim.lsp.config("basedpyright", {
        capabilities = capabilities,
        root_markers = { "pyproject.toml", "setup.py", ".git" },
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("ruff", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            format = {
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
            diagnostics = { disable = { "missing-fields" } },
          },
        },
      })

      vim.lsp.enable({ "texlab", "basedpyright", "ruff", "lua_ls" })

      require("mason").setup()

      require("mason-tool-installer").setup({
        ensure_installed = {
          "texlab",
          "basedpyright",
          "ruff",
          "lua_ls",
          "stylua",
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "texlab", "basedpyright", "ruff", "lua_ls" },
      })
    end,
  },
}
