local M = {}

local Path = require "plenary.path"
local scan = require "plenary.scandir"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"

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

local function is_date_filename(name)
  return name:match "^%d%d%d%d%-%d%d%-%d%d%-%d%d%-%d%d%-%d%d%.md$"
end

local function list_notes(cwd)
  ensure_notes_dir()
  cwd = cwd or notes_dir
  local files = scan.scan_dir(cwd, { hidden = false, add_dirs = true, depth = 1 })
  local entries = {}
  for _, file in ipairs(files) do
    local stat = vim.loop.fs_stat(file)
    if stat and (file:match "%.md$" or stat.type == "directory") then
      local created = os.date("%Y-%m-%d %H:%M", stat.ctime.sec)
      table.insert(entries, {
        file = file,
        display = Path:new(file):make_relative(cwd),
        created = created,
        is_dir = (stat.type == "directory"),
      })
    end
  end
  return entries
end

--------------------------------------------------
-- Telescope picker
--------------------------------------------------
function M.open_notes(cwd)
  ensure_notes_dir()
  vim.cmd("lcd " .. notes_dir)
  cwd = cwd or notes_dir
  local entries = list_notes(cwd)

  pickers
    .new({}, {
      prompt_title = "Notes",
      finder = finders.new_table {
        results = entries,
        entry_maker = function(e)
          return {
            value = e,
            display = (e.is_dir and "  " or "  ") .. e.display .. "  [" .. e.created .. "]",
            ordinal = e.display,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = previewers.new_buffer_previewer {
        define_preview = function(self, entry)
          local buf = self.state.bufnr
          if entry.value.is_dir then
            -- Show folder contents
            local children = scan.scan_dir(entry.value.file, { hidden = false, depth = 1, add_dirs = true })
            local lines = { "📂 " .. Path:new(entry.value.file):make_relative(notes_dir), string.rep("=", 40), "" }
            for _, child in ipairs(children) do
              local name = Path:new(child):make_relative(entry.value.file)
              if vim.loop.fs_stat(child).type == "directory" then
                table.insert(lines, "  " .. name .. "/")
              else
                table.insert(lines, "  " .. name)
              end
            end
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].modifiable = false
          else
            -- Render markdown file content in buffer
            local lines = vim.fn.readfile(entry.value.file)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].filetype = "markdown"
            vim.bo[buf].modifiable = false
          end
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        local function open_file()
          local selection = action_state.get_selected_entry().value
          actions.close(prompt_bufnr)
          if selection.is_dir then
            M.open_notes(selection.file)
          else
            vim.cmd("edit " .. selection.file)
          end
        end

        local function create_note()
          local fname = vim.fn.input "Note name (blank = date): "
          if fname == "" then
            fname = os.date "%Y-%m-%d-%H-%M-%S" .. ".md"
          elseif not fname:match "%.md$" then
            fname = fname .. ".md"
          end
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
          M.open_notes(cwd)
        end

        local function rename_file()
          local selection = action_state.get_selected_entry().value
          local new_name = vim.fn.input("New name: ", vim.fn.fnamemodify(selection.file, ":t"))
          if new_name ~= "" then
            os.rename(selection.file, Path:new(cwd .. "/" .. new_name):absolute())
          end
          M.open_notes(cwd)
        end

        local function delete_file()
          local selection = action_state.get_selected_entry().value
          local confirm = vim.fn.input("Delete " .. selection.display .. "? (y/n) ")
          if confirm:lower() == "y" then
            vim.fn.delete(selection.file, "rf")
            print("Deleted: " .. selection.file)
          else
            print "Cancelled"
          end
          M.open_notes(cwd)
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
  local basename = vim.fn.fnamemodify(fname, ":t")

  if not fname:match(notes_dir) or not fname:match "%.md$" then
    return
  end

  -- Only rename if filename is in date format
  if not is_date_filename(basename) then
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
