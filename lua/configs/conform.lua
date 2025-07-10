local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    json = { "prettierd", "jq" },
    jsonc = { "prettierd", "jq" },
    yaml = { "prettierd", "yamlfmt" },
    toml = { "taplo" },
    markdown = { "prettierd" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
    quiet = true,
  },
}

require("conform").setup(options)
