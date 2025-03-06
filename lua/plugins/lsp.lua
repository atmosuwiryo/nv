local icons = {
  error = " ",
  warn = " ",
  info = "",
  hint = " ",
}

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local Keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- stylua: ignore
    vim.list_extend(Keys, {
      { "gd", "<cmd>Trouble lsp_definitions<cr>", desc = "Goto Definition", has = "definition" },
      { "gr", "<cmd>Trouble lsp_references<cr>", desc = "References", nowait = true },
      { "gI", "<cmd>Trouble lsp_implementations<cr>", desc = "Goto Implementation", nowait = true },
      { "gy", "<cmd>Trouble lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition", nowait = true },
    })
    opts = opts or {}

    opts.diagnostics = {
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
    }
    opts.codelens = {
      enabled = false,
    }
    opts.inlay_hints = {
      enabled = false,
    }
  end,
}
