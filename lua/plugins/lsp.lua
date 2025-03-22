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
    -- opts.servers = opts.servers or {}
    local pylance_bundle = vim.fn.expand("~/.pylance/extension/dist/server.bundle.js", false, true)
    if vim.fn.empty(pylance_bundle) == 0 then
      local root_files = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
      }

      local function exepath(expr)
        local ep = vim.fn.exepath(expr)
        return ep ~= "" and ep or nil
      end
      local configs = require("lspconfig.configs")
      configs.pylance = {
        default_config = {
          before_init = function(_, config)
            if not config.settings.python then
              config.settings.python = {}
            end
            if not config.settings.python.pythonPath then
              config.settings.python.pythonPath = exepath("python3") or exepath("python") or "python"
            end
          end,
          cmd = {
            "node",
            pylance_bundle[1],
            "--stdio",
          },
          filetypes = { "python" },
          single_file_support = true,
          root_dir = require("lspconfig.util").root_pattern(unpack(root_files)),
          settings = {
            python = {
              analysis = {
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = false,
                  callArgumentNames = true,
                  pytestParameters = true,
                },
              },
            },
          },
        },
      }
      require("lspconfig").pylance.setup({})
    end
  end,
}
