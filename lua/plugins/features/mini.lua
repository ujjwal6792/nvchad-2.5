return {
  "echasnovski/mini.nvim",
  lazy = false,
  version = "*",
  config = function()
    require("mini.ai").setup {
      n_lines = 1000,
    }
    require("mini.move").setup {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = "<M-a>",
        right = "<M-d>",
        down = "<M-s>",
        up = "<M-w>",

        -- Move current line in Normal mode
        line_left = "<M-a>",
        line_right = "<M-d>",
        line_down = "<M-s>",
        line_up = "<M-w>",
      },
    }
    --[[     require("mini.surround").setup { ]]
    --[[       mappings = { ]]
    --[[         add = "sa", -- Add surrounding in Normal and Visual modes ]]
    --[[         delete = "sd", -- Delete surrounding ]]
    --[[         find = "sf", -- Find surrounding (to the right) ]]
    --[[         find_left = "sF", -- Find surrounding (to the left) ]]
    --[[         highlight = "sh", -- Highlight surrounding ]]
    --[[         replace = "sr", -- Replace surrounding ]]
    --[[         update_n_lines = "sn", -- Update `n_lines` ]]
    --[[]]
    --[[         suffix_last = "l", -- Suffix to search with "prev" method ]]
    --[[         suffix_next = "n", -- Suffix to search with "next" method ]]
    --[[       }, ]]
    --[[     } ]]
  end,
}
