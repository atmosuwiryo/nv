local avante_prompts = {
  readability_analysis = [[
  Analyze the code snippet for readability issues and assign a severity level (Minor/Moderate/Major) to each issue.
  Consider these aspects:
  - Naming clarity (variables, functions, classes)
  - Purpose clarity and intuitive design
  - Comment quality (missing important comments, redundant/obvious comments)
  - Line complexity (overly long or nested statements)
  - Nesting depth
  - Naming conventions (length, consistency, style)
  - Code duplication or repetitive patterns
  - Separation of concerns

  Format your response as:
  <line_num>|<issue description and specific suggested improvement>

  Prioritize the most severe issues first. List no more than 5 issues unless there are multiple critical problems.
  If no issues found, respond with only: <OK>
  Note: This is a section from a larger file, so focus only on what's visible.
]],

  optimize_code = [[
  Optimize the following code for:
  1. Performance - Identify and fix inefficient algorithms, redundant operations, or resource-heavy usage.
  2. Maintainability - Improve code for future updates and debugging.
  3. Readability - Enhance naming, structure, and overall clarity.
  4. Complexity - Reduce cognitive load and simplify overly complex sections.

  Response Format:
  - Issue:
  - Line(s):
  - Explanation:
  - Optimized Code:
  - Improvement: <How the new code improves performance, maintainability, etc.>

  Focus on meaningful improvements rather than stylistic preferences.
]],

  summarize = [[
  Summarize the following text concisely while retaining all key points and important details.
  Organize the summary in a clear structure with headings if appropriate.
  Highlight any critical information, decisions, or action items.
  Keep your response under 300 words unless the complexity requires more detail.
]],

  explain_code = [[
  Explain the following code comprehensively:

  1. Purpose: Describe the problem this code solves.
  2. Functionality: Provide a step-by-step walkthrough.
  3. Key components: Highlight main functions/classes and their roles.
  4. Control flow: Explain execution order and conditional logic.
  5. Algorithms/patterns: Notable design patterns used.
  6. Dependencies: External libraries or systems it interacts with.
  7. Context: Consider the file name and surrounding code when explaining purpose.

  Response Format:
  - Purpose
  - Key Components
  - Code Walkthrough
  - Design Patterns Identified

  Use clear, plain language accessible to someone with programming knowledge but new to this specific codebase.
  Include concrete examples where helpful.
]],

  fix_bugs = [[
  Fix bugs in the following code by analyzing for:

  1. Runtime errors - null references, type errors, exceptions
  2. Logical issues - incorrect calculations, flawed conditionals
  3. Edge cases - empty inputs, boundary values, unexpected formats
  4. Concurrency problems - race conditions, deadlocks
  5. Memory issues - leaks, inefficient usage

  Response Format:
  • Issue: <Bug Type (Runtime/Logic/etc.)>
  • Severity: <Critical/Major/Minor>
  • Line(s):
  • Explanation:
  • Before:
  • Fixed Code:
  • Why This Fix Works:
]],

  refactor = [[
  Refactor this code to improve its design while preserving functionality. Focus on:

  1. Modularity - Break down complex functions/classes into smaller, focused components
  2. Reusability - Make code components more generic and reusable where appropriate
  3. Maintainability - Improve structure for easier future modifications
  4. SOLID principles - Apply appropriate software design principles
  5. Readability - Enhance clarity without sacrificing functionality

  For your refactoring:
  - Present the refactored code
  - Explain your design decisions and their benefits
  - Highlight what specific problems your refactoring addresses
  - Note any potential trade-offs
]],

  code_review = [[
  Conduct a professional code review addressing:

  1. Functionality - Does the code work as intended? Are there edge cases not handled?
  2. Bugs & Errors - Are there logical errors, potential exceptions, or undefined behaviors?
  3. Performance - Are there inefficient algorithms or operations that could be optimized?
  4. Maintainability - Is the code structured for easy maintenance and extension?
  5. Readability - Is the code clear and well-documented?
  6. Style & Conventions - Does the code follow standard practices for its language?
  7. Security - Are there potential vulnerabilities or unsafe practices?

  For each issue:
  - Reference specific line numbers
  - Rate severity (Critical/Major/Minor)
  - Provide constructive improvement suggestions
  - Include example code where helpful

  Balance critique with positive observations about what works well.
]],

  architecture_suggestion = [[
  Analyze this code architecture and suggest structural improvements:

  1. Design patterns - Identify applicable patterns that could improve the design
  2. Component structure - Suggest better organization of modules/classes
  3. Separation of concerns - Recommend ways to better isolate responsibilities
  4. Coupling & cohesion - Address tight coupling or poor cohesion issues
  5. Scalability - Identify potential bottlenecks for growth
  6. Technologies - Suggest appropriate libraries, frameworks, or tools

  For each recommendation:
  - Explain the specific architectural issue
  - Describe your proposed solution with concrete examples
  - Outline the benefits of implementing your suggestion
  - Note any migration challenges or considerations

  Focus on architectural-level concerns rather than implementation details.
]],

  add_tests = [[
  Implement comprehensive tests for the following code:

  1. Unit tests - For individual functions/methods
  2. Integration tests - For component interactions
  3. Edge cases - Tests for boundary conditions and error handling
  4. Mocking - Where external dependencies should be isolated

  For each test:
  - Create descriptive test names that explain the test's purpose
  - Set up appropriate test fixtures and dependencies
  - Write clear assertions with meaningful error messages
  - Follow testing best practices for the language/framework

  Ensure tests are thorough but maintainable, focusing on behavior rather than implementation details.
]],

  security_review = [[
  Perform a comprehensive security review of this code:

  1. Vulnerabilities - Identify injection attacks, validation issues, insecure defaults
  2. API security - Detect unsafe methods, functions, or improper API usage
  3. Data protection - Highlight potential leaks or exposure of sensitive information
  4. Access control - Identify authentication/authorization weaknesses
  5. Secrets management - Check for hardcoded credentials or tokens
  6. Input validation - Evaluate sanitization and validation practices
  7. Output encoding - Check for proper output encoding to prevent XSS and similar attacks
  8. Dependencies - Note any potentially vulnerable dependencies or libraries

Response Format:
	•	Issue:
	•	Severity: <Critical/High/Medium/Low>
	•	Line(s):
	•	Explanation:
	•	Recommended Fix:
	•	OWASP Reference(if applicable):
]],

  language_specific = {
    lua = [[
    Optimize this Lua code for Neovim:

    1. Reduce performance overhead and memory usage
    2. Use Neovim-specific APIs effectively
    3. Apply Lua idioms appropriate for Neovim plugins
    4. Improve startup and runtime performance
    5. Follow Neovim Lua style conventions

    For each change, show:
    - Before: <original code snippet>
    - After: <improved code snippet>
    - Why: <explanation of how this makes the code more Pythonic>

    Focus on the most impactful changes first.
    Highlight what makes your optimizations specific to the Neovim environment.
    ]],

    python = [[
    Improve this Python code following Pythonic principles:

    1. Use Python's built-in functions, comprehensions, and generators
    2. Apply appropriate data structures (collections, dataclasses)
    3. Follow PEP 8 style conventions
    4. Leverage modern Python features (walrus operator, match statements, etc.)
    5. Optimize for readability and performance

    For each change, show:
    - Before: <original code snippet>
    - After: <improved code snippet>
    - Why:

    Focus on the most impactful changes first.
    ]],

    javascript = [[
    Modernize this JavaScript code:

    1. Replace older patterns with modern ES6+ features
    2. Use appropriate array methods, destructuring, and async patterns
    3. Apply current best practices for performance and maintainability
    4. Address potential browser compatibility concerns
    5. Improve error handling and type safety

    For each change, show:
    - Before: <original code snippet>
    - After: <improved code snippet>
    - Why:

    Focus on the most impactful changes first.
    ]],

    typescript = [[
    Enhance TypeScript type safety in this code:

    1. Improve type definitions and interfaces
    2. Add/refine generic types where appropriate
    3. Use union types, intersection types, and utility types effectively
    4. Leverage TypeScript's advanced features (conditional types, mapped types)
    5. Eliminate 'any' types and type assertions where possible
    6. Implement proper error handling with type checking

    For each change, show:
    - Before: <original code snippet>
    - After: <improved code snippet>
    - Why:

    Focus on the most impactful changes first.
    ]],

    rust = [[
    Refactor this Rust code for idiomatic patterns and safety:

    1. OWNERSHIP & LIFETIMES
       - Apply proper ownership, borrowing, and lifetime practices
       - Use smart pointers (Box, Rc, Arc) appropriately
       - Implement RAII pattern for safe resource management
       - Apply newtype pattern for type safety when appropriate

    2. RUST IDIOMS
       - Use Option/Result for nullable values and error handling
       - Apply the ? operator for concise error propagation
       - Leverage iterators, combinators, and functional approaches
       - Implement traits for abstraction and polymorphism
       - Use proper interior mutability patterns (Cell, RefCell, Mutex)

    3. DESIGN PATTERNS
       - Apply builder pattern for complex object construction
       - Use factory methods with traits for abstraction
       - Implement dependency injection over global state
       - Apply repository pattern for data access layers
       - Consider actor model for concurrent state management

    4. CONCURRENCY
       - Use message passing with channels for thread communication
       - Leverage async/await with proper runtime selection
       - Apply thread pooling over unbounded thread spawning
       - Use scoped threads for borrowed data in threads

    5. ARCHITECTURE
       - Organize code with clear module boundaries
       - Separate business logic from framework specifics
       - Structure error types for better error handling
       - Apply proper patterns for database interactions

•	Response Format:
	•	Issue:
	•	Line(s):
	•	Suggested Fix:
	•	Why This Fix Works:
    ]],
  },

  rust_design_review = [[
    Perform a comprehensive design pattern review of this Rust code:

    1. OBJECT-ORIENTED PATTERNS
       - Global state: Is state managed safely with OnceCell/lazy_static or proper dependency injection?
       - Factory methods: Are object creation concerns properly abstracted?
       - Builder pattern: Is complex initialization handled through builders?
       - Dependency injection: Are dependencies passed explicitly rather than accessed globally?
       - Observer pattern: Are event notifications implemented with channels or callbacks?

    2. RUST-SPECIFIC PATTERNS
       - RAII: Are resources automatically cleaned up using ownership and Drop?
       - Newtype pattern: Are domain values properly wrapped for type safety?
       - Interior mutability: Is shared mutability handled with appropriate primitives?
       - Smart pointers: Are Box, Rc, Arc, and Weak used correctly for ownership management?
       - Lifetimes: Are lifetimes used effectively to ensure safe borrowing?

    3. CONCURRENCY PATTERNS
       - Actor model: Is state isolation maintained through message passing?
       - Thread pooling: Are async runtimes or libraries used for thread management?
       - Message passing: Is inter-thread communication implemented with channels?
       - Scoped threads: Are threads borrowing data managed with proper scoping?

    4. ARCHITECTURAL CONSIDERATIONS
       - Error handling: Are errors managed consistently with Result/Option and ?
       - Trait-based design: Are interfaces clearly defined with traits?
       - State management: Is application state organized efficiently?
       - Modular organization: Is the code properly structured with clear separation of concerns?
       - Database integration: Are database operations abstracted with proper patterns?
       - API design: Are web interfaces implemented with appropriate frameworks and patterns?

    For each issue:
    - Provide the specific line numbers or code sections
    - Explain the current implementation's limitations
    - Offer concrete refactoring suggestions with example code
    - Highlight safety, performance, or maintainability benefits

    Prioritize feedback on issues that could impact correctness, safety, or performance.
  ]],
}

local function ask_with_context(prompt)
  return function()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand("%:t")
    local context = string.format("This is %s code from file '%s'. ", filetype, filename)
    require("avante.api").ask({ question = context .. prompt })
  end
end

local function create_avante_call(prompt, use_context)
  if use_context then
    return ask_with_context(prompt)
  else
    return function()
      require("avante.api").ask({ question = prompt })
    end
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
    opts = function()
      local opts = {
        provider = "copilot",
        rag_service = {
          enabled = false,
        },
        cursor_applying_provider = "copilot",
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-3.7-sonnet",
          proxy = nil,
          allow_insecure = false,
          timeout = 60000,
          temperature = 0,
          max_tokens = 32768,
          disable_tools = true,
          telemetry = false,
        },
        suggestion = {
          debounce = 900,
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
      }
      if vim.env.USER == "abz" then
        opts.auto_suggestions_provider = "ollama"
        opts.memory_summary_provider = "ollama"
        opts.ollama = {
          model = "llama3.1",
          endpoint = "http://127.0.0.1:11434",
          options = {
            temperature = 0,
            num_ctx = 32768,
          },
        }
        opts.cursor_applying_provider = "ollama"
        opts.rag_service = {
          enabled = true,
          host_mount = os.getenv("HOME"),
          provider = "ollama",
          llm_model = "llama3.1",
          embed_model = "nomic-embed-text",
          endpoint = "http://host.docker.internal:11434",
        }
        opts.web_search_engine = {
          provider = "tavily",
        }
      end

      return opts
    end,
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
        "<leader>ae",
        function()
          require("avante.api").edit()
        end,
        desc = "Edit",
        mode = { "n", "v" },
      },
      {
        "<leader>af",
        "<cmd>AvanteClear<cr>",
        mode = { "n", "v" },
        desc = "Clear",
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
        "<leader>ar",
        create_avante_call(avante_prompts.refactor),
        mode = { "n", "v" },
        desc = "Refactor Code",
      },
      {
        "<leader>av",
        function()
          if vim.bo.filetype == "rust" then
            create_avante_call(avante_prompts.rust_design_review)()
          else
            create_avante_call(avante_prompts.code_review)()
          end
        end,
        mode = { "n", "v" },
        desc = "Code Review",
      },
      {
        "<leader>aA",
        create_avante_call(avante_prompts.architecture_suggestion),
        mode = { "n", "v" },
        desc = "Architecture Suggestions",
      },
      {
        "<leader>al",
        create_avante_call(avante_prompts.readability_analysis),
        desc = "Code Readability Analysis",
        mode = { "n", "v" },
      },
      {
        "<leader>ao",
        create_avante_call(avante_prompts.optimize_code),
        mode = { "n", "v" },
        desc = "Optimize Code",
      },
      {
        "<leader>ax",
        create_avante_call(avante_prompts.explain_code, true),
        mode = { "n", "v" },
        desc = "Explain Code",
      },
      {
        "<leader>ab",
        create_avante_call(avante_prompts.fix_bugs, true),
        mode = { "n", "v" },
        desc = "Fix Bugs",
      },
      {
        "<leader>au",
        create_avante_call(avante_prompts.add_tests),
        mode = { "n", "v" },
        desc = "Add Tests",
      },
      {
        "<leader>az",
        create_avante_call(avante_prompts.security_review, true),
        mode = { "n", "v" },
        desc = "Security Analysis",
      },
      {
        "<leader>am",
        create_avante_call(avante_prompts.summarize),
        mode = { "n", "v" },
        desc = "Summarize text",
      },
      {
        "<leader>ap",
        function()
          local ft = vim.bo.filetype
          local prompt = avante_prompts.language_specific[ft]
            or ("Improve this code following best practices for " .. ft)
          create_avante_call(prompt)
        end,
        mode = { "n", "v" },
        desc = "Language-specific improvements",
      },
    },
  },
}
