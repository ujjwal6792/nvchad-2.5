return {
  "windwp/nvim-ts-autotag",
  dependencies = "nvim-treesitter/nvim-treesitter",
  ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue", "astro" },
  config = function()
    require("nvim-ts-autotag").setup {
      opts = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
      },
    }
  end,
  lazy = true,
  event = "VeryLazy",
}
