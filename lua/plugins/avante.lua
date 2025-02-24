local avante_code_readability_analysis = [[
  You must identify any readability issues in the code snippet.
  Some readability issues to consider:
  - Unclear naming
  - Unclear purpose
  - Redundant or obvious comments
  - Lack of comments
  - Long or complex one liners
  - Too much nesting
  - Long variable names
  - Inconsistent naming and code style.
  - Code repetition
  You may identify additional problems. The user submits a small section of code from a larger file.
  Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>
  If there's no issues with code respond with only: <OK>
]]
local avante_optimize_code = "Optimize the following code"
local avante_summarize = "Summarize the following text"
local avante_explain_code = "Explain the following code"
local avante_fix_bugs = "Fix the bugs inside the following codes if any"
local avante_add_tests = "Implement tests for the following code"
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  opts = {
    provider = "copilot",
    -- rag_service = {
    --   enabled = true,
    -- },
    cursor_applying_provider = "copilot",
    copilot = {
      endpoint = "https://api.githubcopilot.com",
      model = "claude-3.5-sonnet",
      proxy = nil,
      allow_insecure = false,
      timeout = 30000,
      temperature = 0,
      max_tokens = 32768,
    },
    suggestion = {
      debounce = 600,
      throttle = 600,
    },
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,
      enable_token_counting = true,
      enable_cursor_planning_mode = true,
    },
    mappings = {
      --- @class AvanteConflictMappings
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "zbirenbaum/copilot.lua", -- for providers='copilot'
  },
  keys = {
    {
      "<leader>al",
      function()
        require("avante.api").ask({ question = avante_code_readability_analysis })
      end,
      desc = "Code Readability Analysis",
      mode = { "n", "v" },
    },
    {
      "<leader>ao",
      function()
        require("avante.api").ask({ question = avante_optimize_code })
      end,
      mode = { "n", "v" },
      desc = "Optimize Code",
    },
    {
      "<leader>am",
      function()
        require("avante.api").ask({ question = avante_summarize })
      end,
      mode = { "n", "v" },
      desc = "Summarize text",
    },
    {
      "<leader>ax",
      function()
        require("avante.api").ask({ question = avante_explain_code })
      end,
      mode = { "n", "v" },
      desc = "Explain Code",
    },
    {
      "<leader>ab",
      function()
        require("avante.api").ask({ question = avante_fix_bugs })
      end,
      mode = { "n", "v" },
      desc = "Fix Bugs",
    },
    {
      "<leader>au",
      function()
        require("avante.api").ask({ question = avante_add_tests })
      end,
      mode = { "n", "v" },
      desc = "Add Tests",
    },
  },
}
