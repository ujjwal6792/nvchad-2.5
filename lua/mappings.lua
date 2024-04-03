require "nvchad.mappings"

-- add yours here
local g = vim.g
local api = vim.api
local map = vim.keymap.set

local function opts_to_id(id)
  for _, opts in pairs(g.nvchad_terms) do
    if opts.id == id then
      return opts
    end
  end
end

map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- nvimtree
map("n", "<leader>e", "<cmd> NvimTreeFocus<CR>", { desc = "Focus nvimtree" })
map("n", "<leader>we", "<cmd> NvimTreeRefresh<CR>", { desc = "Refresh nvimtree" })
map("n", "<leader>ww", "<cmd> NvimTreeToggle<CR>", { desc = "Toggle nvimtree" })

-- term toggle
map("n", "<leader>h", function()
  vim.cmd "NvimTreeClose"
  require("nvchad.term").new { pos = "sp", size = 0.4 }
end, { desc = "Terminal New horizontal term" })

map("n", "<leader>v", function()
  vim.cmd "NvimTreeClose"
  require("nvchad.term").new { pos = "vsp", size = 0.4 }
end, { desc = "Terminal New vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  if g.nvchad_terms then
    for _, opts in pairs(g.nvchad_terms) do
      if opts.id == "htoggleTerm" then
        local x = opts_to_id(opts.id)
        if x or api.nvim_buf_is_valid(x.buf) then
          local buf = vim.fn.getbufinfo(x.buf)[1]
          if buf then
            if buf.hidden ~= 1 then
              api.nvim_win_close(x.win, true)
            end
          end
        end
      end
    end
  end
  vim.cmd "wincmd l"
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm", size = 0.4 }
end, { desc = "Terminal Toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  if g.nvchad_terms then
    for _, opts in pairs(g.nvchad_terms) do
      if opts.id == "vtoggleTerm" then
        local x = opts_to_id(opts.id)
        if x or api.nvim_buf_is_valid(x.buf) then
          local buf = vim.fn.getbufinfo(x.buf)[1]
          if buf then
            if buf.hidden ~= 1 then
              api.nvim_win_close(x.win, true)
            end
          end
        end
      end
    end
  end
  vim.cmd "wincmd l"
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm", size = 0.4 }
end, { desc = "Terminal New horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal Toggle Floating term" })

map("t", "<ESC>", function()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(win, true)
end, { desc = "Terminal Close term in terminal mode" })

-- custom
map("n", "<C-d>", "Find Under")
map("n", "<leader>fp", "<cmd> ProjectMgr<CR>", { desc = "Open Projects" })
map("n", "gt", "<cmd> :LazyGit<CR>", { desc = "open lazygit" })
map("n", "<leader>gf", "<cmd> :LazyGitFilter<CR>", { desc = "lazygit commits" })
map("n", "gG", "<cmd> :LazyGitCurrentFile<CR>", { desc = "open lazygit for current" })
map("n", "<leader>gF", "<cmd> :LazyGitFilter<CR>", { desc = "lazygit commits for current" })
map("n", "<leader>db", "<cmd> DapToggleBreakpoint<CR>", { desc = "debugger toggle breakpoints" })
map("n", "<leader>gt", function()
  require("telescope").extensions.lazygit.lazygit()
end, { desc = "open lazygit telescope" })
map("n", "<leader>dus", function()
  local widgets = require "dap.ui.widgets"
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end, { desc = "Open debugging sidebar" })
