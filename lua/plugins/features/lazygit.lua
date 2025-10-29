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
      vim.cmd "bufdo e"
    end
    require("telescope").load_extension "lazygit"
  end,
}
