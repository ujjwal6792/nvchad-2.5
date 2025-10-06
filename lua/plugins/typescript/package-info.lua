return {
  "vuki656/package-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  ft = { "json" },
  config = function()
    require("package-info").setup {
      hide_unstable_versions = true,
      -- hide_up_to_date = true,
    }
  end,
}
