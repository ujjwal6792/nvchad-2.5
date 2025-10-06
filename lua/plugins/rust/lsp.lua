return {
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
}
