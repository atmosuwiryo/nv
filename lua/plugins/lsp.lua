local icons = {
  error = " ",
  warn = " ",
  info = "",
  hint = " ",
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      virtual_text = false,
      underline = false,
      signs = {
        active = true,
        text = {
          [vim.diagnostic.severity.ERROR] = icons.error,
          [vim.diagnostic.severity.WARN] = icons.warn,
          [vim.diagnostic.severity.INFO] = icons.info,
          [vim.diagnostic.severity.HINT] = icons.hint,
        },
        values = {
          { name = "DiagnosticSignError", text = icons.error },
          { name = "DiagnosticSignWarn", text = icons.warn },
          { name = "DiagnosticSignInfo", text = icons.info },
          { name = "DiagnosticSignHint", text = icons.hint },
        },
      },
    },
    codelens = {
      enabled = false,
    },
  },
}
