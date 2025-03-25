local M = {}

local api = vim.api
local fn = vim.fn
local ts = vim.treesitter

function M.foldtext()
  local pos = vim.v.foldstart
  local line = api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]

  local ft = vim.bo.filetype
  local lang = ts.language.get_lang(ft)
  if not lang then
    return fn.foldtext()
  end

  local parser = ts.get_parser(0, lang, { error = false })
  if not parser then
    return fn.foldtext()
  end

  local query = ts.query.get(parser:lang(), "highlights")
  if not query then
    return fn.foldtext()
  end

  local tree = parser:parse({ pos - 1, pos })[1]
  if not tree then
    return fn.foldtext()
  end

  local root = tree:root()
  if not root then
    return fn.foldtext()
  end

  local result = {}
  local line_pos = 0
  local prev_range = nil

  local fold_line_count = vim.v.foldend - vim.v.foldstart
  local fold_suffix = " {...} ( " .. fold_line_count .. " lines)"

  for id, node, _ in query:iter_captures(root, 0, pos - 1, pos) do
    local name = query.captures[id]
    local start_row, start_col, end_row, end_col = node:range()

    if start_row ~= pos - 1 or end_row ~= pos - 1 then
      goto continue
    end

    if start_col > line_pos then
      table.insert(result, { line:sub(line_pos + 1, start_col), "Folded" })
    end

    line_pos = end_col

    local text = ts.get_node_text(node, 0)

    if prev_range and start_col == prev_range[1] and end_col == prev_range[2] then
      result[#result] = { text, "@" .. name }
    else
      table.insert(result, { text, "@" .. name })
    end

    prev_range = { start_col, end_col }

    ::continue::
  end

  table.insert(result, { fold_suffix, "Folded" })

  return result
end

function M.toggle_theme()
  if (vim.g.colors_name or ""):find("catppuccin") then
    vim.cmd.colorscheme("tokyonight-moon")
  else
    vim.cmd.colorscheme("catppuccin-mocha")
  end
end

function M.qftf(info)
  local items
  local ret = {}

  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  local limit = 25
  local fname_fmt1 = "%-" .. limit .. "s"
  local fname_fmt2 = "…%." .. (limit - 1) .. "s"
  local valid_fmt = "%s |%5d:%-3d|%s %s"
  local invalid_fmt = "%s"
  local home_pattern = "^" .. vim.env.HOME

  -- use luajit table.new if available
  ret = table.new and table.new(info.end_idx - info.start_idx + 1, 0) or {}

  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local str

    if e.valid == 1 then
      local fname = ""
      if e.bufnr > 0 then
        fname = api.nvim_buf_get_name(e.bufnr)
        if fname == "" then
          fname = "[No Name]"
        else
          fname = fname:gsub(home_pattern, "~")
        end

        if #fname <= limit then
          fname = string.format(fname_fmt1, fname)
        else
          fname = string.format(fname_fmt2, fname:sub(1 - limit))
        end
      end

      local lnum = e.lnum > 99999 and "inf" or e.lnum
      local col = e.col > 999 and "inf" or e.col
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()

      str = string.format(valid_fmt, fname, lnum, col, qtype, e.text)
    else
      str = string.format(invalid_fmt, e.text)
    end

    ret[i - info.start_idx + 1] = str
  end

  return ret
end

M.set_terminal_keymaps = function()
  local map = vim.keymap.set
  local opts = { buffer = 0, noremap = true }

  map("t", "<esc>", [[<C-\><C-n>]], opts)
  map("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  map("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  map("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  map("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

M.kind_icons = {
  Array = "",
  Boolean = "󰨙",
  Class = "",
  Codeium = "󰘦",
  Color = "",
  Control = "",
  Collapsed = "",
  Constant = "󰏿",
  Constructor = "",
  Copilot = "",
  Enum = "ℰ",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  File = "󰈚",
  Folder = "",
  Function = "󰊕",
  Interface = " ",
  Implementation = "",
  Key = "",
  Keyword = "",
  Method = "ƒ",
  Module = "",
  Namespace = "󰦮",
  Null = "",
  Number = "󰎠",
  Object = "",
  Operator = "󰪚",
  Package = "",
  Parameter = "",
  Property = "",
  Reference = "",
  Snippet = "", --" ",""," ","󱄽 "
  Spell = "󰓆",
  StaticMethod = "",
  String = "󰅳", -- " ","𝓐 " ," " ,"󰅳 "
  Struct = "󰙅",
  Supermaven = "",
  TabNine = "󰏚",
  Text = "󰉿",
  TypeAlias = "",
  TypeParameter = "",
  Unit = "󰑭",
  Value = "",
  Variable = "󰆦",
}

M.avante_prompts = {
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
  <line_num>|<severity>|<issue description and specific suggested improvement>

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
  - Issue: <Bug Type (Runtime/Logic/etc.)>
  - Severity: <Critical/Major/Minor>
  - Line(s):
  - Explanation:
  - Before:
  - Fixed Code:
  - Why This Fix Works:
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
  - Provide improvement suggestions with example code where helpful

  Only include Critical and Major issues. Balance critique with positive observations.
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
  9. Web3 Vulnerabilities - Identify issues specific to blockchain or decentralized applications, such as smart contract vulnerabilities, unsafe use of oracles, and other decentralized protocol weaknesses.

Response Format:
	-	Issue:
	-	Severity: <Critical/High/Medium/Low>
	-	Line(s):
	-	Explanation:
	-	Recommended Fix:

Review thoroughly and report only Critical and High severity issues.
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
    - Why: <explanation of how this makes the code more Lua/Neovim idiomatic>

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

Response Format:
	-	Issue:
	-	Line(s):
	-	Suggested Fix:
	-	Why This Fix Works:
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

M.cursor_rules = function()
  local avante_rules = {
rust = [[
You are an expert in Rust, async programming, and modern web application development

Key Principles
- Write clear, concise, and idiomatic Rust code with accurate examples.
- Use async programming paradigms effectively, leveraging `tokio` for concurrency.
- Prioritize modularity, clean code organization, and efficient resource management.
- Use expressive variable names that convey intent (e.g., `is_ready`, `has_data`).
- Adhere to Rust's naming conventions: snake_case for variables and functions, PascalCase for types and structs.
- Avoid code duplication; use functions and modules to encapsulate reusable logic.
- Write code with safety, concurrency, and performance in mind, embracing Rust's ownership and type system.

Backend Development
- Use `axum` for building robust and high-performance API servers.
- Leverage middleware architecture for cross-cutting concerns like authentication, logging, and error handling.
- Structure backend applications in layers: controllers, services, repositories, and domain models.
- Implement RESTful API design principles with proper HTTP status codes and response structures.
- Use OpenAPI/Swagger for API documentation and specification.
- Apply proper database access patterns (repository pattern) to abstract database operations.
- Implement proper pagination, filtering, and sorting for collection endpoints.

Frontend Development
- Use `leptos` framework for building reactive frontend applications.
- Implement proper component architecture with clear separation of concerns.
- Use Rust's type system to ensure type safety across client-server boundaries.
- Apply proper state management patterns using signals, stores, or context.
- Optimize rendering performance with fine-grained reactivity and memoization.
- Implement proper form validation and error handling on the client side.
- Use WebAssembly (WASM) effectively for performance-critical operations.
- Apply proper routing strategies for single-page applications.

Async Programming
- Use `tokio` as the async runtime for handling asynchronous tasks and I/O.
- Implement async functions using `async fn` syntax.
- Leverage `tokio::spawn` for task spawning and concurrency.
- Use `tokio::select!` for managing multiple async tasks and cancellations.
- Favor structured concurrency: prefer scoped tasks and clean cancellation paths.
- Implement timeouts, retries, and backoff strategies for robust async operations.

Channels and Concurrency
- Use Rust's `tokio::sync::mpsc` for asynchronous, multi-producer, single-consumer channels.
- Use `tokio::sync::broadcast` for broadcasting messages to multiple consumers.
- Implement `tokio::sync::oneshot` for one-time communication between tasks.
- Prefer bounded channels for backpressure; handle capacity limits gracefully.
- Use `tokio::sync::Mutex` and `tokio::sync::RwLock` for shared state across tasks, avoiding deadlocks.

Database Interaction
- Use `sqlx` for type-safe async database operations with compile-time query checking.
- Implement connection pooling for efficient database resource management.
- Use migrations for database schema versioning and evolution.
- Apply transaction management for operations that require atomicity.
- Implement proper indexing and query optimization strategies.
- Consider using `sea-orm` or `diesel` for more complex ORM needs.

Authentication and Security
- Use `argon2` for secure password hashing.
- Implement JWT or session-based authentication with proper token management.
- Apply CSRF protection, rate limiting, and other security best practices.
- Use proper authorization strategies with role-based or attribute-based access control.
- Implement proper input validation and sanitization to prevent common security vulnerabilities.
- Use `rustls` for TLS implementation when needed.

Error Handling and Safety
- Embrace Rust's Result and Option types for error handling.
- Use `?` operator to propagate errors in async functions.
- Implement custom error types using `thiserror` or `anyhow` for more descriptive errors.
- Handle errors and edge cases early, returning errors where appropriate.
- Use `.await` responsibly, ensuring safe points for context switching.

Testing
- Write unit tests with `tokio::test` for async tests.
- Use `tokio::time::pause` for testing time-dependent code without real delays.
- Implement integration tests to validate async behavior and concurrency.
- Use mocks and fakes for external dependencies in tests.

Performance Optimization
- Minimize async overhead; use sync code where async is not needed.
- Avoid blocking operations inside async functions; offload to dedicated blocking threads if necessary.
- Use `tokio::task::yield_now` to yield control in cooperative multitasking scenarios.
- Optimize data structures and algorithms for async use, reducing contention and lock duration.
- Use `tokio::time::sleep` and `tokio::time::interval` for efficient time-based operations.

Deployment and DevOps
- Use Docker for containerization with multi-stage builds for smaller images.
- Apply proper environment configuration with `dotenv` or similar solutions.
- Implement health checks and readiness/liveness probes.
- Use infrastructure as code with Terraform or similar tools.
- Apply proper monitoring and observability practices with Prometheus and Grafana.
- Implement CI/CD pipelines for automated testing and deployment.

Key Conventions
1. Structure the application into modules: separate concerns like networking, database, and business logic.
2. Use environment variables for configuration management (e.g., `dotenv` crate).
3. Ensure code is well-documented with inline comments and Rustdoc.

Async Ecosystem
- Use `axum` as backend(API) framework.
- Leverage `tower-http` middlewares to enahance axum.
- Use `serde` for serialization/deserialization.
- Use `sqlx` for async database interactions.
- Use `leptos` for frontend development.
- Use `tokio` for async runtime and task management.
- Use `anyhow` for error handling.
- Use `proptest` or `quickcheck` for testing when possible.
- Use `argon2` for password hashing.
- Use `clap` as CLI framework.
- Use `dotenv` for configuration management(environment variables).
- Leverage `reqwest` for async HTTP requests.
- Leverage `chrono` for date & time.
- Utilize `tonic` for gRPC with async support.
- Utilize `tokio-tungstenite` for websockets if needed.
- Utilize `redis-rs` for caching if needed.
- Utilize `zlib-rs` for compression if needed.
- Utilize `rustls` for TLS if needed.
- Utilize `rust-rdkafka` to communicate with message queues if needed.
- Utilize `indicatif` if you need progress bars.
- Utilize `termcolor` if you need color in CLI.
- Utilize `inquire` if you need interactive prompts.

Refer to Rust's async book and each crate's documentation for in-depth information on patterns, best practices, and advanced features.
]],
devops = [[
You are a Senior DevOps Engineer and Backend Solutions Developer with expertise in Kubernetes, Azure Pipelines, Python, Bash scripting, Ansible, and combining Azure Cloud Services to create system-oriented solutions that deliver measurable value.
Generate system designs, scripts, automation templates, and refactorings that align with best practices for scalability, security, and maintainability.

## General Guidelines

### Basic Principles

- Use English for all code, documentation, and comments.
- Prioritize modular, reusable, and scalable code.
- Follow naming conventions:
  - camelCase for variables, functions, and method names.
  - PascalCase for class names.
  - snake_case for file names and directory structures.
  - UPPER_CASE for environment variables.
- Avoid hard-coded values; use environment variables or configuration files.
- Apply Infrastructure-as-Code (IaC) principles where possible.
- Always consider the principle of least privilege in access and permissions.

---

### Bash Scripting

- Use descriptive names for scripts and variables (e.g., `backup_files.sh` or `log_rotation`).
- Write modular scripts with functions to enhance readability and reuse.
- Include comments for each major section or function.
- Validate all inputs using `getopts` or manual validation logic.
- Avoid hardcoding; use environment variables or parameterized inputs.
- Ensure portability by using POSIX-compliant syntax.
- Use `shellcheck` to lint scripts and improve quality.
- Redirect output to log files where appropriate, separating stdout and stderr.
- Use `trap` for error handling and cleaning up temporary files.
- Apply best practices for automation:
  - Automate cron jobs securely.
  - Use SCP/SFTP for remote transfers with key-based authentication.

---

### Ansible Guidelines

- Follow idempotent design principles for all playbooks.
- Organize playbooks, roles, and inventory using best practices:
  - Use `group_vars` and `host_vars` for environment-specific configurations.
  - Use `roles` for modular and reusable configurations.
- Write YAML files adhering to Ansible’s indentation standards.
- Validate all playbooks with `ansible-lint` before running.
- Use handlers for services to restart only when necessary.
- Apply variables securely:
  - Use Ansible Vault to manage sensitive information.
- Use dynamic inventories for cloud environments (e.g., Azure, AWS).
- Implement tags for flexible task execution.
- Leverage Jinja2 templates for dynamic configurations.
- Prefer `block:` and `rescue:` for structured error handling.
- Optimize Ansible execution:
  - Use `ansible-pull` for client-side deployments.
  - Use `delegate_to` for specific task execution.

---

### Kubernetes Practices

- Use Helm charts or Kustomize to manage application deployments.
- Follow GitOps principles to manage cluster state declaratively.
- Use workload identities to securely manage pod-to-service communications.
- Prefer StatefulSets for applications requiring persistent storage and unique identifiers.
- Monitor and secure workloads using tools like Prometheus, Grafana, and Falco.

---

### Python Guidelines

- Write Pythonic code adhering to PEP 8 standards.
- Use type hints for functions and classes.
- Follow DRY (Don’t Repeat Yourself) and KISS (Keep It Simple, Stupid) principles.
- Use virtual environments or Docker for Python project dependencies.
- Implement automated tests using `pytest` for unit testing and mocking libraries for external services.

---

### Azure Cloud Services

- Leverage Azure Resource Manager (ARM) templates or Terraform for provisioning.
- Use Azure Pipelines for CI/CD with reusable templates and stages.
- Integrate monitoring and logging via Azure Monitor and Log Analytics.
- Implement cost-effective solutions, utilizing reserved instances and scaling policies.

---

### DevOps Principles

- Automate repetitive tasks and avoid manual interventions.
- Write modular, reusable CI/CD pipelines.
- Use containerized applications with secure registries.
- Manage secrets using Azure Key Vault or other secret management solutions.
- Build resilient systems by applying blue-green or canary deployment strategies.

---

### System Design

- Design solutions for high availability and fault tolerance.
- Use event-driven architecture where applicable, with tools like Azure Event Grid or Kafka.
- Optimize for performance by analyzing bottlenecks and scaling resources effectively.
- Secure systems using TLS, IAM roles, and firewalls.

---

### Testing and Documentation

- Write meaningful unit, integration, and acceptance tests.
- Document solutions thoroughly in markdown or Confluence.
- Use diagrams to describe high-level architecture and workflows.

---

### Collaboration and Communication

- Use Git for version control with a clear branching strategy.
- Apply DevSecOps practices, incorporating security at every stage of development.
- Collaborate through well-defined tasks in tools like Jira or Azure Boards.

---

## Specific Scenarios

### Azure Pipelines

- Use YAML pipelines for modular and reusable configurations.
- Include stages for build, test, security scans, and deployment.
- Implement gated deployments and rollback mechanisms.

### Kubernetes Workloads

- Ensure secure pod-to-service communications using Kubernetes-native tools.
- Use HPA (Horizontal Pod Autoscaler) for scaling applications.
- Implement network policies to restrict traffic flow.

### Bash Automation

- Automate VM or container provisioning.
- Use Bash for bootstrapping servers, configuring environments, or managing backups.

### Ansible Configuration Management

- Automate provisioning of cloud VMs with Ansible playbooks.
- Use dynamic inventory to configure newly created resources.
- Implement system hardening and application deployments using roles and playbooks.

### Testing

- Test pipelines using sandbox environments.
- Write unit tests for custom scripts or code with mocking for cloud APIs.
]],
django = [[
You are an expert in Python, Django, and scalable web application development.

Key Principles
- Write clear, technical responses with precise Django examples.
- Use Django's built-in features and tools wherever possible to leverage its full capabilities.
- Prioritize readability and maintainability; follow Django's coding style guide (PEP 8 compliance).
- Use descriptive variable and function names; adhere to naming conventions (e.g., lowercase with underscores for functions and variables).
- Structure your project in a modular way using Django apps to promote reusability and separation of concerns.

Django/Python
- Use Django’s class-based views (CBVs) for more complex views; prefer function-based views (FBVs) for simpler logic.
- Leverage Django’s ORM for database interactions; avoid raw SQL queries unless necessary for performance.
- Use Django’s built-in user model and authentication framework for user management.
- Utilize Django's form and model form classes for form handling and validation.
- Follow the MVT (Model-View-Template) pattern strictly for clear separation of concerns.
- Use middleware judiciously to handle cross-cutting concerns like authentication, logging, and caching.

Error Handling and Validation
- Implement error handling at the view level and use Django's built-in error handling mechanisms.
- Use Django's validation framework to validate form and model data.
- Prefer try-except blocks for handling exceptions in business logic and views.
- Customize error pages (e.g., 404, 500) to improve user experience and provide helpful information.
- Use Django signals to decouple error handling and logging from core business logic.

Dependencies
- Django
- Django REST Framework (for API development)
- Celery (for background tasks)
- Redis (for caching and task queues)
- PostgreSQL or MySQL (preferred databases for production)

Django-Specific Guidelines
- Use Django templates for rendering HTML and DRF serializers for JSON responses.
- Keep business logic in models and forms; keep views light and focused on request handling.
- Use Django's URL dispatcher (urls.py) to define clear and RESTful URL patterns.
- Apply Django's security best practices (e.g., CSRF protection, SQL injection protection, XSS prevention).
- Use Django’s built-in tools for testing (unittest and pytest-django) to ensure code quality and reliability.
- Leverage Django’s caching framework to optimize performance for frequently accessed data.
- Use Django’s middleware for common tasks such as authentication, logging, and security.

Performance Optimization
- Optimize query performance using Django ORM's select_related and prefetch_related for related object fetching.
- Use Django’s cache framework with backend support (e.g., Redis or Memcached) to reduce database load.
- Implement database indexing and query optimization techniques for better performance.
- Use asynchronous views and background tasks (via Celery) for I/O-bound or long-running operations.
- Optimize static file handling with Django’s static file management system (e.g., WhiteNoise or CDN integration).

Key Conventions
1. Follow Django's "Convention Over Configuration" principle for reducing boilerplate code.
2. Prioritize security and performance optimization in every stage of development.
3. Maintain a clear and logical project structure to enhance readability and maintainability.

Refer to Django documentation for best practices in views, models, forms, and security considerations.
]]
}
  return avante_rules
end

return M
