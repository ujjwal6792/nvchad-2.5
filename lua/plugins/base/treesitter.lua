return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "astro",
      "scss",
      "svelte",
      "vim",
      "lua",
      "html",
      "css",
      "json",
      "javascript",
      "typescript",
      "tsx",
      "prisma",
      "go",
      -- "gofumpt",
      "c",
      "rust",
      "markdown",
      "markdown_inline",
    },
    highlight = {
      enable = true,
      disable = {},
    },
    -- autotag = {
    --   enable = true,
    --   enable_rename = true,
    --   enable_close = true,
    --   enable_close_on_slash = true,
    --   close_on_exit = true,
    -- },
    indent = {
      enable = true,
      -- disable = {
      --   "python"
      -- },
    },
    context_commentstring = {
      enable_autocmd = false,
      enable = true,
    },
  },
}
