return {
  "notes",
  lazy = false,
  dir = "~/.config/nvim/lua/notes", -- local plugin
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>mn",
      function()
        require("notes").open_notes()
      end,
      desc = "Open Notes",
    },
  },
}
