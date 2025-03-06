return {
  "saghen/blink.cmp",
  dependencies = {
    {
      "giuxtaposition/blink-cmp-copilot",
    },
  },
  opts = function(_, opts)
    opts.enabled = function()
      local filetype = vim.bo[0].filetype
      local excluded_filetypes = {
        "TelescopePrompt",
        "minifiles",
        "snacks_picker_input",
        "neo-tree",
        "neo-tree-popup",
      }

      for _, ft in ipairs(excluded_filetypes) do
        if filetype == ft then
          return false
        end
      end
      return true
    end
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          kind = "LSP",
          min_keyword_length = 2,
          score_offset = 90, -- the higher the number, the higher the priority
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 25,
          fallbacks = { "snippets", "buffer" },
          min_keyword_length = 3,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = "Buffer",
          enabled = true,
          max_items = 3,
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 4,
          score_offset = 15, -- the higher the number, the higher the priority
        },
        copilot = {
          name = "copilot",
          enabled = true,
          module = "blink-cmp-copilot",
          kind = "Copilot",
          min_keyword_length = 6,
          score_offset = -100, -- the higher the number, the higher the priority
          async = true,
        },
      },
    })

    opts.cmdline = {
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        if type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
      completion = { menu = { auto_show = true } },
    }

    opts.completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = false,
      },
    }
    opts.signature = { enabled = true }
    local icons = require("config.utils").kind_icons
    opts.appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
      kind_icons = icons,
    }
  end,
}
