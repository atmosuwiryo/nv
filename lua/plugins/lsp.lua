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
    
    -- TypeScript/Angular/NestJS configuration
    opts.servers = opts.servers or {}
    opts.servers.tsserver = {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          suggest = {
            completeFunctionCalls = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          suggest = {
            completeFunctionCalls = true,
          },
        },
      },
    }
    
    -- Angular Language Service configuration
    opts.servers.angularls = {
      filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
      root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
    }

    -- ESLint configuration
    opts.servers.eslint = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "html",
      },
      settings = {
        workingDirectory = { mode = "auto" },
        format = { enable = true },
        lint = { enable = true },
      },
    }
    
    -- HTML configuration
    opts.servers.html = {
      filetypes = { "html" },
      init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
          css = true,
          javascript = true,
        },
        provideFormatter = true,
      },
    }

    -- CSS language server
    opts.servers.cssls = {
      filetypes = { "css", "scss", "less" },
    }
    
    -- JSON language server (useful for package.json, tsconfig.json, etc.)
    opts.servers.jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    }
    
    local pylance_bundle = vim.fn.expand("~/.pylance/extension/dist/server.bundle.js")
    if vim.uv.fs_stat(pylance_bundle) then
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
      opts.servers.yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "gha", "dependabot", "yaml", "yaml.docker-compose", "yaml.gitlab" },
        root_markers = { ".git" },
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
            validate = true,
            format = {
              enable = false, -- delegate to conform.nvim
            },
          },
        },
      }
      opts.servers.dockerls = {
        cmd = { "docker-langserver", "--stdio" },
        filetypes = { "dockerfile" },
        root_markers = { "Dockerfile" },
        settings = {
          docker = {},
        },
      }
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
            pylance_bundle,
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
