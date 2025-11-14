return {
  "kdheepak/lazygit.nvim",
  lazy = false,
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  config = function()
    vim.g.lazygit_on_exit_callback = function()
      -- Loop over all listed buffers and reload only valid file buffers
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local name = vim.api.nvim_buf_get_name(buf)
          if name ~= "" and vim.fn.filereadable(name) == 1 then
            vim.api.nvim_buf_call(buf, function()
              vim.cmd "edit"
            end)
          end
        end
      end
    end
    require("telescope").load_extension "lazygit"
  end,
}
