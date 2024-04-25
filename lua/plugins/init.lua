return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
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
        -- rust stuff
        "rust-analyzer",
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
    enable_autocmd = false,
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
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
        close_on_exit = true,
      },
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
    -- keys = {
    --   { "gcc", mode = "n", desc = "Comment toggle current line" },
    --   { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
    --   { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
    --   { "gbc", mode = "n", desc = "Comment toggle current block" },
    --   { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
    --   { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    -- },
    -- init = function()
    --   require("core.utils").load_mappings "comment"
    -- end,
    config = function(_)
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require "leap"
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },

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
    config = function()
      require("nvim-ts-autotag").setup {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = false,
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
          enabled = true,
          command = "git pull --ff-only > .git/fastforward.log 2>&1",
        },
        session = { enabled = true, file = ".git/Session.vim" },
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
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    config = function(_)
      require("rust-tools").setup {
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(_, bufnr)
            vim.keymap.set(
              "n",
              "<Leader>k",
              require("rust-tools").hover_actions.hover_actions,
              { buffer = bufnr, desc = "rust-tools hover actions" }
            )
            vim.keymap.set(
              "n",
              "<Leader>a",
              require("rust-tools").code_action_group.code_action_group,
              { buffer = bufnr, desc = "rust-tools code actions" }
            )
          end,
        },
        tools = {
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
          checkOnSave = {
            command = "clippy",
          },
          inlayHints = { locationLinks = false },
          diagnostics = {
            enable = true,
            experimental = {
              enable = true,
            },
          },
        },
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
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      require("cmp").setup.buffer {
        sources = { { name = "crates" } },
      }
      crates.show()
      require("core.utils").load_mappings "crates"
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
    "folke/trouble.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "<leader>tt", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble Lsp screen" } },
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
    ft = { "js", "jsx", "json", "svg", "rust", "ts", "tsx", "go", "javascript", "typescript", "lua", "markdown" },
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },

  {
    "ellisonleao/glow.nvim",
    ft = { "markdown", "mdx", "md" },
    config = function()
      require("glow").setup {
        style = "dark",
        width = 120,
      }
    end,
    cmd = "Glow",
    keys = { { "<leader>mm", "<cmd>Glow<cr>", desc = "Preview markdown" } },
  },

  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    lazy = false,
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("tailwindcss-colorizer-cmp").setup {
        color_square_width = 2,
      }
      require("cmp").config.formatting = {
        format = require("tailwindcss-colorizer-cmp").formatter,
      }
    end,
  },
}
