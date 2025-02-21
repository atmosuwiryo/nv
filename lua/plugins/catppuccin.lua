return {
  "catppuccin",
  optional = true,
  opts = {
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    integrations = {
      blink_cmp = true,
      overseer = true,
      neotest = true,
      telescope = true,
      treesitter = true,
      mason = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = {},
          warnings = { "italic" },
          information = {},
        },
        underlines = {
          errors = { "undercurl" },
          hints = {},
          warnings = { "undercurl" },
          information = {},
        },
      },
      dap = {
        enabled = true,
        enable_ui = true,
      },
    },
    term_colors = false,
    styles = {
      comments = {},
      keywords = { "italic" },
    },
    compile = {
      enabled = true,
      path = vim.fn.stdpath("cache") .. "/catppuccin",
    },
    dim_inactive = {
      enabled = true,
      shade = "dark",
      percentage = 0.15,
    },
    highlight_overrides = {
      mocha = {
        NormalFloat = { fg = "#CDD6F4", bg = "#151521" },
        CmpItemKindEnum = { fg = "#B4BEFE" },
        CmpItemKindEnumMember = { fg = "#F5C2E7" },
        CmpItemMenu = { fg = "#7F849C" },
        CmpItemAbbr = { fg = "#BAC2DE" },
        ColorColumn = { bg = "#181825" },
        Cursor = { fg = "#1e1e2e", bg = "#d9e0ee" },
        ["@constant.builtin"] = { fg = "#EBA0AC" },
        TSConstBuiltin = { fg = "#EBA0AC" },
        rainbow1 = { fg = "#f38ba8", bg = "#302D41" },
        rainbow2 = { fg = "#fab387", bg = "#302D41" },
        rainbow3 = { fg = "#f9e2af", bg = "#302D41" },
        rainbow4 = { fg = "#a6e3a1", bg = "#302D41" },
        rainbow5 = { fg = "#74c7ec", bg = "#302D41" },
        rainbow6 = { fg = "#b4befe", bg = "#302D41" },
      },
    },
  },
}
