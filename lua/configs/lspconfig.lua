-- Replace the old lspconfig require with the native vim.lsp API
-- local lspconfig = require "lspconfig"

-- This is still valid if you are using NvChad's helper functions
local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- You will likely want to reduce updatetime which affects CursorHold
-- Note: this setting is global and should be set only once
vim.o.updatetime = 100
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Diagnostic symbols in the sign column (gutter)
-- Diagnostic configuration is not affected by the lspconfig API change
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
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
        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
      end,
    })
  end

  -- attach keymaps if needed
end

-- Use vim.lsp.config for servers that require custom settings
vim.lsp.config("ts_ls", {
  on_attach = on_attach,
  filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "javascript.jsx", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities,
})
vim.lsp.enable "ts_ls"

vim.lsp.config("marksman", {
  on_attach = on_attach,
  filetypes = { "markdown", "markdown.mdx", "markdown.md" },
  cmd = { "marksman", "server" },
})

vim.lsp.enable "marksman"

vim.lsp.config("svelte", {
  on_attach = on_attach_svelte,
  capabilities = capabilities,
  filetypes = { "svelte" },
  cmd = { "svelteserver", "--stdio" },
})

vim.lsp.enable "svelte"

vim.lsp.config("astro", {
  init_options = {
    configuration = {},
    typescript = {
      serverPath = vim.fs.normalize "~/.nvm/versions/node/v19.9.0/lib/node_modules/typescript/lib/tsserverlibrary.js",
    },
  },
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.enable "astro"

vim.lsp.config("tailwindcss", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "typescriptreact",
    "javascriptreact",
    "javascript.jsx",
    "typescript.tsx",
    "css",
    "html",
    "svelte",
    "astro",
  },
  -- Note: The filetypes for tailwindcss are generally detected automatically.
  -- filetypes = { ... },
})

vim.lsp.enable "tailwindcss"

vim.lsp.config("prismals", {
  -- Adjust these paths based on your installation
  cmd = { "prisma-language-server", "--stdio" },
  settings = {
    prisma = {
      enable = true,
    },
  },
})

vim.lsp.enable "prismals"

vim.lsp.config("gopls", {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = vim.fs.root(0, { ".git", "go.mod" }),
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
})

vim.lsp.enable "gopls"

-- Use vim.lsp.enable for servers that can use the default configuration
local servers = { "html", "cssls", "clangd", "dockerls", "docker_compose_language_service" }
for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "docker-compose*.yml", "docker-compose*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml.docker-compose"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "tsconfig*.json" },
  callback = function()
    vim.bo.filetype = "jsonc"
  end,
})
