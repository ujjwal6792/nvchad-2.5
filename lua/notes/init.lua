local M = {}

local Path = require "plenary.path"
local scan = require "plenary.scandir"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local notes_dir = vim.fn.expand "~/notes"

--------------------------------------------------
-- Helpers
--------------------------------------------------
local function ensure_notes_dir()
  if not vim.loop.fs_stat(notes_dir) then
    vim.fn.mkdir(notes_dir, "p")
  end
end

local function slugify(str)
  return str:lower():gsub("[^a-z0-9]+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
end

local function list_notes()
  ensure_notes_dir()
  local files = scan.scan_dir(notes_dir, { hidden = false, add_dirs = true })
  local entries = {}
  for _, file in ipairs(files) do
    if file:match "%.md$" or vim.loop.fs_stat(file).type == "directory" then
      local stat = vim.loop.fs_stat(file)
      local created = os.date("%Y-%m-%d %H:%M", stat.ctime.sec)
      table.insert(entries, {
        file = file,
        display = Path:new(file):make_relative(notes_dir),
        created = created,
      })
    end
  end
  return entries
end

--------------------------------------------------
-- Telescope picker
--------------------------------------------------
function M.open_notes()
  ensure_notes_dir()
  local entries = list_notes()

  pickers
    .new({}, {
      prompt_title = "Notes",
      finder = finders.new_table {
        results = entries,
        entry_maker = function(e)
          return {
            value = e.file,
            display = e.display .. "  [" .. e.created .. "]",
            ordinal = e.display,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local function open_file()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if vim.loop.fs_stat(selection.value).type == "directory" then
            vim.cmd("cd " .. selection.value)
            M.open_notes()
          else
            vim.cmd("edit " .. selection.value)
          end
        end

        local function create_note()
          local fname = os.date "%Y-%m-%d" .. ".md"
          local path = Path:new(notes_dir .. "/" .. fname)
          if not path:exists() then
            path:touch { parents = true }
          end
          actions.close(prompt_bufnr)
          vim.cmd("edit " .. path:absolute())
        end

        local function create_folder()
          local folder_name = vim.fn.input "Folder name: "
          if folder_name ~= "" then
            vim.fn.mkdir(notes_dir .. "/" .. folder_name, "p")
          end
          M.open_notes()
        end

        local function rename_file()
          local selection = action_state.get_selected_entry()
          local new_name = vim.fn.input("New name: ", vim.fn.fnamemodify(selection.value, ":t"))
          if new_name ~= "" then
            os.rename(selection.value, Path:new(notes_dir .. "/" .. new_name):absolute())
          end
          M.open_notes()
        end

        local function delete_file()
          local selection = action_state.get_selected_entry()
          vim.fn.delete(selection.value, "rf")
          M.open_notes()
        end

        map("i", "<CR>", open_file)
        map("i", "<C-a>", create_note)
        map("i", "<C-f>", create_folder)
        map("i", "<C-r>", rename_file)
        map("i", "<C-d>", delete_file)
        map("i", "<Tab>", actions.move_selection_next)
        map("i", "<S-Tab>", actions.move_selection_previous)

        return true
      end,
    })
    :find()
end

--------------------------------------------------
-- Autocmd: auto-rename on heading change
--------------------------------------------------
local function maybe_rename_note()
  local buf = vim.api.nvim_get_current_buf()
  local fname = vim.api.nvim_buf_get_name(buf)

  if not fname:match(notes_dir) or not fname:match "%.md$" then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local title
  for _, line in ipairs(lines) do
    local h = line:match "^#%s+(.+)"
    if h then
      title = h
      break
    end
  end

  if not title then
    return
  end

  local new_name = slugify(title) .. ".md"
  local dir = Path:new(fname):parent():absolute()
  local new_path = dir .. "/" .. new_name

  if fname ~= new_path and not Path:new(new_path):exists() then
    vim.fn.rename(fname, new_path)
    vim.cmd("edit " .. new_path)
    print("Renamed note → " .. new_name)
  end
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = notes_dir .. "/*.md",
  callback = maybe_rename_note,
})

return M
