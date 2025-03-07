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
local avante_optimize_code = [[
  Optimize the following code for:
  - Improved performance
  - Better readability
  - Easier Maintainability
  - Reduced complexity
  Explain the key optimizations you made.
]]
local avante_summarize = "Summarize the following text"
local avante_explain_code = [[
  Explain the following code:
  - What is its purpose?
  - How does it work?
  - What are the key components or algorithms?
  Use plain language that would help someone new to this codebase.
]]
local avante_fix_bugs = [[
  Fix bugs in the following code:
  - Identify potential runtime errors
  - Fix logical issues
  - Address edge cases
  - Explain each fix
]]
local avante_refactor = [[
  Refactor this code to improve:
  - Modularity
  - Reusability
  - Maintainability
  Focus on good software design principles without changing core functionality.
]]
local avante_code_review = [[
  Conduct a thorough code review:
  - Identify potential bugs or edge cases
  - Suggest design improvements
  - Highlight performance concerns
  - Note any style inconsistencies
  Provide constructive feedback as if in a professional code review.
]]
local avante_architecture_suggestion = [[
  Analyze this code and suggest architectural improvements:
  - Identify any design patterns that could be applied
  - Suggest better structuring of components
  - Recommend ways to improve separation of concerns
  - Propose any libraries or techniques that might be beneficial
]]
local avante_add_tests = "Implement tests for the following code"
local avante_security_review = [[
  Perform a comprehensive security review of this code:
  - Identify potential security vulnerabilities (e.g., injection attacks, improper validation, insecure defaults)
  - Detect unsafe functions, methods, or API usage
  - Highlight potential data leaks or exposure of sensitive information
  - Identify issues with authentication, authorization, or access control
  - Check for hardcoded credentials or secrets
  - Assess input validation and sanitization
  - Evaluate secure coding practices
  
  For each issue, provide:
  1. The specific location in code
  2. The type of vulnerability
  3. Potential impact if exploited
  4. A suggested fix or mitigation strategy
  
  If no security issues are found, explain why the code appears secure based on the visible portion.
]]
local function ask_with_context(prompt)
  return function()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand("%:t")
    local context = string.format("This is %s code from file '%s'. ", filetype, filename)
    require("avante.api").ask({ question = context .. prompt })
  end
end

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        filetypes = {
          ["*"] = false,
          avante = true,
          c = true,
          cpp = true,
          go = true,
          help = true,
          html = true,
          java = true,
          javascript = true,
          javascriptreact = true,
          lua = true,
          markdown = true,
          python = true,
          rust = true,
          typescript = true,
          typescriptreact = true,
        },
      })
    end,
  },
  {
    "yetone/avante.nvim",
    -- event = "BufReadPost",
    version = false,
    opts = {
      provider = "copilot",
      -- rag_service = {
      --   enabled = true,
      -- },
      cursor_applying_provider = "copilot",
      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "claude-3.7-sonnet",
        proxy = nil,
        allow_insecure = false,
        timeout = 60000,
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
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("avante.api").ask()
        end,
        desc = "Ask",
        mode = { "n", "v" },
      },

      {
        "<leader>ar",
        function()
          require("avante.api").ask({ question = avante_refactor })
        end,
        mode = { "n", "v" },
        desc = "Refactor Code",
      },
      {
        "<leader>af",
        "<cmd>AvanteClear<cr>",
        mode = { "n", "v" },
        desc = "Clear",
      },
      {
        "<leader>av",
        function()
          require("avante.api").ask({ question = avante_code_review })
        end,
        mode = { "n", "v" },
        desc = "Code Review",
      },
      {
        "<leader>aA",
        function()
          require("avante.api").ask({ question = avante_architecture_suggestion })
        end,
        mode = { "n", "v" },
        desc = "Architecture Suggestions",
      },
      {
        "<leader>ae",
        function()
          require("avante.api").edit()
        end,
        desc = "Edit",
        mode = { "n", "v" },
      },
      {
        "<leader>a?",
        function()
          require("avante.api").select_model()
        end,
        desc = "Select model",
        mode = "n",
      },
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
        ask_with_context(avante_explain_code),
        mode = { "n", "v" },
        desc = "Explain Code",
      },
      {
        "<leader>ab",
        ask_with_context(avante_fix_bugs),
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
      {
        "<leader>az",
        ask_with_context(avante_security_review),
        mode = { "n", "v" },
        desc = "Security Analysis",
      },

      {
        "<leader>ap",
        function()
          local filetype_prompts = {
            lua = "Optimize this Lua code for Neovim performance",
            python = "Make this Python code more Pythonic and efficient",
            javascript = "Modernize this JavaScript using current best practices",
            typescript = "Improve TypeScript type safety in this code",
            rust = "Refactor this Rust code to use more idiomatic Rust patterns, be more efficient and to use more ergonomic features from recent Rust versions",
          }
          local ft = vim.bo.filetype
          local prompt = filetype_prompts[ft] or ("Improve this code following best practices for " .. ft)
          require("avante.api").ask({ question = prompt })
        end,
        mode = { "n", "v" },
        desc = "Language-specific improvements",
      },
    },
  },
}
