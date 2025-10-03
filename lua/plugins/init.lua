return {
  "nvzone/volt",
  { "nvzone/minty", cmd = { "Huefy", "Shades" } },
  {
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
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",
        -- web dev stuff
        "jq",
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "prettier",
        "prettierd",
        "tailwindcss-language-server",
        "vale",
        "cssmodules-language-server",
        "css-lsp",
        "eslint-lsp",
        "eslint_d",
        "prismals",
        "svelte",
        -- docker
        "dockerls",
        "docker_compose_language_service",
        --yaml
        "yamlfmt",
        -- toml
        "taplo",
        -- go stuff
        "gopls",
        "golangci-lint",
        -- c/cpp stuff
        "clangd",
        "clang-format",
        -- markdown
        "marksman",
      },
    },
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    main = "ts_context_commentstring",
    opts = {
      enable_autocmd = false,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "scss",
        "svelte",
        "vim",
        "lua",
        "html",
        "css",
        "json",
        "javascript",
        "typescript",
        "tsx",
        "prisma",
        "go",
        -- "gofumpt",
        "c",
        "rust",
        "markdown",
        "markdown_inline",
      },
      highlight = {
        enable = true,
        disable = {},
      },
      -- autotag = {
      --   enable = true,
      --   enable_rename = true,
      --   enable_close = true,
      --   enable_close_on_slash = true,
      --   close_on_exit = true,
      -- },
      indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
      },
      context_commentstring = {
        enable_autocmd = false,
        enable = true,
      },
    },
  },

  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup {
        pre_hook = function(ctx)
          local U = require "Comment.utils"
          local utils = require "ts_context_commentstring.utils"
          local internal = require "ts_context_commentstring.internal"

          local location = nil
          if ctx.ctype == U.ctype.block then
            location = utils.get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = utils.get_visual_start_location()
          end

          return internal.calculate_commentstring {
            key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
            location = location,
          }
        end,
      }
    end,
  },

  --[[ { ]]
  --[[   "ggandor/leap.nvim", ]]
  --[[   keys = { ]]
  --[[     { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" }, ]]
  --[[     { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" }, ]]
  --[[     { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" }, ]]
  --[[   }, ]]
  --[[   config = function(_, opts) ]]
  --[[     local leap = require "leap" ]]
  --[[     for k, v in pairs(opts) do ]]
  --[[       leap.opts[k] = v ]]
  --[[     end ]]
  --[[     leap.add_default_mappings(true) ]]
  --[[     vim.keymap.del({ "x", "o" }, "x") ]]
  --[[     vim.keymap.del({ "x", "o" }, "X") ]]
  --[[   end, ]]
  --[[ }, ]]
  --[[]]
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>fr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  {
    "dsznajder/vscode-es7-javascript-react-snippets",
    run = "yarn install --frozen-lockfile && yarn compile",
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue", "astro" },
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
        },
      }
    end,
    lazy = true,
    event = "VeryLazy",
  },

  {
    "charludo/projectmgr.nvim",
    lazy = false, -- important!
    config = function()
      require("projectmgr").setup {
        autogit = {
          enabled = false,
          command = "git pull --ff-only > .git/fastforward.log 2>&1",
        },
        reopen = false,
        session = { enabled = false, file = "../../Session.vim" },
      }
    end,
  },

  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension "lazygit"
    end,
  },

  -- rust plugins
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(_, bufnr)
            -- you can also put keymaps in here
            vim.keymap.set("n", "<leader>ra", function()
              vim.lsp.buf.codeAction()
              -- vim.cmd.RustLsp "codeAction" -- supports rust-analyzer's grouping
              -- or vim.lsp.buf.codeAction() if you don't want grouping.
            end, { silent = true, buffer = bufnr, desc = "rust lsp actions" })

            vim.keymap.set(
              "n",
              "<leader>rs",
              ":RustAnalyzer restart<CR>",
              { silent = true, buffer = bufnr, desc = "rust lsp restart" }
            )
            vim.keymap.set("n", "<leader>re", function()
              vim.cmd.RustLsp "explainError"
            end, { silent = true, buffer = bufnr, desc = "rust explain errors" })
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              hover_actions = {
                auto_focus = true,
              },
              assist = {
                importEnforceGranularity = true,
                importPrefix = "crate",
              },
              cargo = {
                allFeatures = true,
              },
              inlayHints = { locationLinks = false },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
              },
            },
          },
        },
        -- DAP configuration
        dap = {},
      }
    end,
  },

  {
    "mfussenegger/nvim-dap",
    init = function()
      -- require("core.utils").load_mappings "dap"
    end,
  },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      require("cmp").setup.buffer {
        sources = { { name = "crates" } },
      }
      crates.show()
    end,
  },

  {
    "RRethy/vim-illuminate",
    lazy = false,
  },

  -- TEST PLUGINS
  {
    "amrbashir/nvim-docs-view",
    lazy = false,
    keys = { { "<leader>dd", "<cmd>DocsViewToggle<cr>", desc = "DocsView toggle" } },
    config = function()
      require("docs-view").setup {
        position = "right",
        width = 60,
      }
    end,
  },

  {
    "karb94/neoscroll.nvim",
    lazy = false,
    config = function()
      require("neoscroll").setup {}
    end,
  },

  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = { "json" },
    config = function()
      require("package-info").setup {
        hide_unstable_versions = true,
        -- hide_up_to_date = true,
      }
    end,
  },

  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {},
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    ft = {
      "js",
      "jsx",
      "json",
      "svg",
      "rust",
      "ts",
      "tsx",
      "go",
      "javascript",
      "typescript",
      "lua",
      "markdown",
      "yaml",
      "env",
    },
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },

  --[[ {
    "ellisonleao/glow.nvim",
    ft = { "markdown", "mdx", "md" },
    config = function()
      require("glow").setup {
        style = "dark",
        width = 120,
      }
    end,
    cmd = "Glow",
    keys = { { "<leader>mg", "<cmd>Glow<cr>", desc = "Preview markdown using glow" } },
  }, ]]
  {
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
  },
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup {
            ensure_installed = { "markdown" },
            highlight = { enable = true },
          }
        end,
      },
    },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      kitty_method = "normal",
    },
  },

  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { "<leader>sr", "<cmd>SessionSearch<CR>", desc = "Session search" },
      { "<leader>ss", "<cmd>SessionSave<CR>", desc = "Save session" },
      { "<leader>sa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    --[[ ---@type AutoSession.Config ]]
    opts = {
      -- ⚠️ This will only work if Telescope.nvim is installed
      -- The following are already the default values, no need to provide them if these are already the settings you want.
      session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = true,
        previewer = false,
        mappings = {
          -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
          delete_session = { "i", "<C-D>" },
          alternate_session = { "i", "<C-S>" },
          copy_session = { "i", "<C-Y>" },
        },
        -- Can also set some Telescope picker options
        -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
        theme_conf = {
          border = true,
          -- layout_config = {
          --   width = 0.8, -- Can set width and height as percent of window
          --   height = 0.5,
          -- },
        },
      },
    },
  },

  {
    "echasnovski/mini.nvim",
    lazy = false,
    version = "*",
    config = function()
      require("mini.ai").setup()
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
  },
}
