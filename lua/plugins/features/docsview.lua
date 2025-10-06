return {
  "amrbashir/nvim-docs-view",
  lazy = false,
  keys = { { "<leader>dd", "<cmd>DocsViewToggle<cr>", desc = "DocsView toggle" } },
  config = function()
    require("docs-view").setup {
      position = "right",
      width = 60,
    }
  end,
}
