local M = {}

local Path = require "plenary.path"
local scan = require "plenary.scandir"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local devicons = require "nvim-web-devicons"

local notes_root = vim.fn.expand "~/notes"
local clipboard = nil -- { mode = "cut"|"copy", source = "path" }

--------------------------------------------------
-- Helpers
--------------------------------------------------
local function ensure_dir(dir)
  if not vim.loop.fs_stat(dir) then
    vim.fn.mkdir(dir, "p")
  end
end

local function slugify(str)
  return str:lower():gsub("[^a-z0-9]+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
end

local function list_entries(dir)
  ensure_dir(dir)
  local files = scan.scan_dir(dir, { hidden = false, add_dirs = true })
  local entries = {}
  for _, file in ipairs(files) do
    if file:match "%.md$" or vim.loop.fs_stat(file).type == "directory" then
      local stat = vim.loop.fs_stat(file)
      local created = os.date("%Y-%m-%d %H:%M", stat.ctime.sec)
      local rel = Path:new(file):make_relative(notes_root)
      local icon, icon_hl = devicons.get_icon(file, nil, { default = true })
      table.insert(entries, {
        file = file,
        display = icon .. " " .. rel .. " [" .. created .. "]",
        ordinal = rel,
        is_dir = (stat.type == "directory"),
      })
    end
  end
  return entries
end

--------------------------------------------------
-- Picker
--------------------------------------------------
local function open_picker(cwd)
  cwd = cwd or notes_root
  local entries = list_entries(cwd)

  pickers
    .new({}, {
      prompt_title = "Notes: " .. Path:new(cwd):make_relative(notes_root),
      finder = finders.new_table {
        results = entries,
        entry_maker = function(e)
          return e
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local function refresh()
          actions.close(prompt_bufnr)
          open_picker(cwd)
        end

        local function open_entry()
          local selection = action_state.get_selected_entry()
          if selection.is_dir then
            actions.close(prompt_bufnr)
            open_picker(selection.file)
          else
            actions.close(prompt_bufnr)
            vim.cmd("edit " .. selection.file)
          end
        end

        local function go_up()
          if cwd ~= notes_root then
            actions.close(prompt_bufnr)
            open_picker(Path:new(cwd):parent():absolute())
          else
            actions.close(prompt_bufnr)
          end
        end

        local function create_note()
          local fname = os.date "%Y-%m-%d" .. ".md"
          local path = Path:new(cwd .. "/" .. fname)
          if not path:exists() then
            path:touch { parents = true }
          end
          actions.close(prompt_bufnr)
          vim.cmd("edit " .. path:absolute())
        end

        local function create_folder()
          local folder_name = vim.fn.input "Folder name: "
          if folder_name ~= "" then
            vim.fn.mkdir(cwd .. "/" .. folder_name, "p")
          end
          refresh()
        end

        local function rename_entry()
          local selection = action_state.get_selected_entry()
          local new_name = vim.fn.input("New name: ", vim.fn.fnamemodify(selection.file, ":t"))
          if new_name ~= "" then
            os.rename(selection.file, Path:new(cwd .. "/" .. new_name):absolute())
          end
          refresh()
        end

        local function delete_entry()
          local selection = action_state.get_selected_entry()
          vim.fn.delete(selection.file, "rf")
          refresh()
        end

        local function cut_entry()
          local selection = action_state.get_selected_entry()
          clipboard = { mode = "cut", source = selection.file }
          print("Cut: " .. selection.file)
        end

        local function copy_entry()
          local selection = action_state.get_selected_entry()
          clipboard = { mode = "copy", source = selection.file }
          print("Copied: " .. selection.file)
        end

        local function paste_entry()
          if not clipboard then
            return
          end
          local target = cwd .. "/" .. Path:new(clipboard.source):name()
          if clipboard.mode == "cut" then
            os.rename(clipboard.source, target)
            clipboard = nil
          elseif clipboard.mode == "copy" then
            vim.fn.system { "cp", "-r", clipboard.source, target }
          end
          refresh()
        end

        -- Keymaps
        map("i", "<CR>", open_entry)
        map("i", "<Esc>", go_up)
        map("i", "<C-a>", create_note)
        map("i", "<C-f>", create_folder)
        map("i", "<C-r>", rename_entry)
        map("i", "<C-d>", delete_entry)
        map("i", "<C-x>", cut_entry)
        map("i", "<C-c>", copy_entry)
        map("i", "<C-p>", paste_entry)
        map("i", "<Tab>", actions.move_selection_next)
        map("i", "<S-Tab>", actions.move_selection_previous)

        return true
      end,
    })
    :find()
end

function M.open_notes()
  ensure_dir(notes_root)
  open_picker(notes_root)
end

--------------------------------------------------
-- Auto-rename on heading change
--------------------------------------------------
local function maybe_rename_note()
  local buf = vim.api.nvim_get_current_buf()
  local fname = vim.api.nvim_buf_get_name(buf)

  if not fname:match(notes_root) or not fname:match "%.md$" then
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
  pattern = notes_root .. "/**/*.md",
  callback = maybe_rename_note,
})

return M
