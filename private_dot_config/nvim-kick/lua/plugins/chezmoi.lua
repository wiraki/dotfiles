local chezmoi_source = vim.fn.expand("~") .. "/.local/share/chezmoi"

return {
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre " .. chezmoi_source .. "/*" },
    cmd = { "ChezmoiEdit", "ChezmoiList" },
    config = function()
      require("chezmoi").setup({
        edit = { watch = false, force = false },
        notification = {
          on_open = true,
          on_apply = true,
          on_watch = false,
        },
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = chezmoi_source .. "/*",
        callback = function(ev)
          vim.schedule(function()
            require("chezmoi.commands.__edit").watch(ev.buf)
          end)
        end,
      })
    end,
  },
}
