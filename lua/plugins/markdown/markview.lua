return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  preview = {
    icon_provider = "devicons", -- "mini" or "devicons"
  },
  keys = {
    { "<leader>mc", "<cmd>Checkbox toggle<cr>", desc = "markdown checkbox toggle" },
    { "<leader>mh-", "<cmd>Heading decrease<cr>", desc = "markdown heading decrease" },
    { "<leader>mh=", "<cmd>Heading increase<cr>", desc = "markdown heading increase" },
  },
  config = function()
    require("markview.extras.checkboxes").setup()
    require("markview.extras.editor").setup()
    require("markview.extras.headings").setup()
  end,
}
