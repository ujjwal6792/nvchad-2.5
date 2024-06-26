local on_attach = require("nvchad.configs.lspconfig").on_attach
-- local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"
--local util = require "lspconfig/util"
-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "clangd" }

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 100
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = true,
  float = {
    source = true, -- Or "if_many"
  },
}

-- svelte lsp + neovim 0.9 issue fix
local on_attach_svelte = function(client)
  if client.name == "svelte" then
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
      callback = function(ctx)
        -- Here use ctx.match instead of ctx.file
        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
      end,
    })
  end

  -- attach keymaps if needed
end
--

lspconfig.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "javascript.jsx", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities,
}
lspconfig.marksman.setup {
  on_attach = on_attach,
  filetypes = { "markdown", "markdown.mdx", "markdown.md" },
  cmd = { "marksman", "server" },
}

require("lspconfig").svelte.setup {
  on_attach = on_attach_svelte,
  capabilities = capabilities,
  filetypes = { "svelte" },
  cmd = { "svelteserver", "--stdio" },
}

lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  -- filetypes = {" astro, astro-markdown, html, html-eex, mdx, css, less, postcss, sass, scss, javascript, javascriptreact, typescript, typescriptreact, svelte"}
}
lspconfig.astro.setup {
  init_options = {
    configuration = {},
    on_attach = on_attach,
    capabilities = capabilities,
    typescript = {
      serverPath = vim.fs.normalize "~/.nvm/versions/node/v19.9.0/lib/node_modules/typescript/lib/tsserverlibrary.js",
    },
  },
}

lspconfig.prismals.setup {
  -- Adjust these paths based on your installation
  cmd = { "prisma-language-server", "--stdio" },
  settings = {
    prisma = {
      enable = true,
    },
  },
}

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    gopls = {
      gofumpt = true,
      experimentalPostfixCompletions = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
}

-- lspconfig.golangci_lint_ls.setup {
--   on_attach = on_attach,
--   cmd = { "golangci-lint-langserver" },
--   filetypes = { "go", "gomod", "gosum", "gowork" },
--   init_options = {
--     command = { "golangci-lint", "run", "--out-format", "json" },
--   },
-- }

-- if not lspconfig.golangcilsp then
--       local configs = require "lspconfig/configs"
--
--       configs.golangcilsp = {
--          default_config = {
--             cmd = { "golangci-lint-langserver" },
--             root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
--             init_options = {
--                command = { "golangci-lint", "run", "--out-format", "json" },
--             },
--          },
--       }
--    end

-- lspconfig.golangcilsp.setup {
-- filetypes = { "go" },
-- }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

--
-- lspconfig.pyright.setup { blabla}
