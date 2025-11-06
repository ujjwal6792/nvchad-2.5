return {
  "charludo/projectmgr.nvim",
  lazy = false, -- important!
  config = function()
    require("projectmgr").setup {
      autogit = {
        enabled = false,
        command = "git pull --ff-only > .git/fastforward.log 2>&1",
      },
      reopen = false,
      session = { enabled = false, file = "~/Session.vim" },
    }
  end,
}
