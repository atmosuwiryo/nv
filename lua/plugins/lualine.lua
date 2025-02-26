return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local colors = {
        bg = "#161617",
        fg = "#c9c7cd",
        subtext1 = "#b4b1ba",
        subtext2 = "#9f9ca6",
        subtext3 = "#8b8693",
        subtext4 = "#6c6874",
        bg_dark = "#1A1B26",
        -- bg_dark = "#131314",
        black = "#27272a",
        red = "#ea83a5",
        green = "#90b99f",
        yellow = "#e6b99d",
        purple = "#aca1cf",
        magenta = "#e29eca",
        orange = "#f5a191",
        blue = "#92a2d5",
        cyan = "#85b5ba",
        bright_black = "#353539",
        bright_red = "#f591b2",
        bright_green = "#9dc6ac",
        bright_yellow = "#f0c5a9",
        bright_purple = "#b9aeda",
        bright_magenta = "#ecaad6",
        bright_orange = "#ffae9f",
        bright_blue = "#a6b6e9",
        bright_cyan = "#99c9ce",
        gray0 = "#18181a",
        gray1 = "#1b1b1c",
        gray2 = "#2a2a2c",
        gray3 = "#313134",
        gray4 = "#3b3b3e",
        -- Special
        none = "NONE",
      }

      local modecolor = {
        n = colors.red,
        i = colors.cyan,
        v = colors.purple,
        [""] = colors.purple,
        V = colors.red,
        c = colors.yellow,
        no = colors.red,
        s = colors.yellow,
        S = colors.yellow,
        [""] = colors.yellow,
        ic = colors.yellow,
        R = colors.green,
        Rv = colors.purple,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.bright_red,
      }

      local space = {
        function()
          return " "
        end,
        color = { bg = colors.bg_dark, fg = colors.blue },
      }

      local filename = {
        "filename",
        color = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        separator = { left = "", right = "" },
      }

      local filetype = {
        "filetype",
        icons_enabled = false,
        color = { bg = colors.gray2, fg = colors.blue, gui = "italic,bold" },
        separator = { left = "", right = "" },
      }

      local branch = {
        "branch",
        icon = "",
        color = { bg = colors.green, fg = colors.bg, gui = "bold" },
        separator = { left = "", right = "" },
      }

      local location = {
        "location",
        color = { bg = colors.yellow, fg = colors.bg_dark, gui = "bold" },
        separator = { left = "", right = "" },
      }

      local diff = {
        "diff",
        color = { bg = colors.gray2, fg = colors.bg, gui = "bold" },
        separator = { left = "", right = "" },
        symbols = { added = " ", modified = " ", removed = " " },

        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.yellow },
          removed = { fg = colors.red },
        },
      }

      local modes = {
        "mode",
        color = function()
          local mode_color = modecolor
          return { bg = mode_color[vim.fn.mode()], fg = colors.bg_dark, gui = "bold" }
        end,
        separator = { left = "", right = "" },
      }

      local function getLspName()
        local bufnr = vim.api.nvim_get_current_buf()
        local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
        local buf_ft = vim.bo.filetype
        if next(buf_clients) == nil then
          return "  No servers"
        end
        local buf_client_names = {}

        for _, client in pairs(buf_clients) do
          if client.name ~= "null-ls" then
            table.insert(buf_client_names, client.name)
          end
        end

        local lint_s, lint = pcall(require, "lint")
        if lint_s then
          for ft_k, ft_v in pairs(lint.linters_by_ft) do
            if type(ft_v) == "table" then
              for _, linter in ipairs(ft_v) do
                if buf_ft == ft_k then
                  table.insert(buf_client_names, linter)
                end
              end
            elseif type(ft_v) == "string" then
              if buf_ft == ft_k then
                table.insert(buf_client_names, ft_v)
              end
            end
          end
        end

        local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
        local sources = require("null-ls.sources")
        for _, source in ipairs(sources.get_available(ft)) do
          table.insert(buf_client_names, source.name)
        end

        local hash = {}
        local unique_client_names = {}

        for _, v in ipairs(buf_client_names) do
          if not hash[v] then
            unique_client_names[#unique_client_names + 1] = v
            hash[v] = true
          end
        end
        local language_servers = table.concat(unique_client_names, ", ")

        return language_servers
      end

      local macro = {
        require("noice").api.status.mode.get,
        cond = require("noice").api.status.mode.has,
        color = { fg = colors.red, bg = colors.bg_dark, gui = "italic,bold" },
      }

      local dia = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.purple },
          hint = { fg = colors.cyan },
        },
        color = { bg = colors.gray2, fg = colors.blue, gui = "bold" },
        separator = { left = "" },
      }

      local overseer = {
        "overseer",
        color = { fg = colors.blue, bg = colors.bg_dark },
      }

      local lsp = {
        function()
          return getLspName()
        end,
        separator = { left = "", right = "" },
        color = { bg = colors.purple, fg = colors.bg, gui = "italic,bold" },
      }

      local opts = {
        options = {
          theme = "catppuccin",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard", "snacks_terminal" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = vim.env.TMUX == nil,
        },
        sections = {
          lualine_a = {
            modes,
          },
          lualine_b = {
            space,
          },
          lualine_c = {
            branch,
            filetype,
            space,
            diff,
            space,
            filename,
            location,
          },
          lualine_x = {
            overseer,
          },
          lualine_y = { macro, space },
          lualine_z = {
            dia,
            lsp,
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      }
      table.insert(opts.sections.lualine_x, 2, {
        function()
          return LazyVim.config.icons.kinds.Copilot
        end,
        cond = function()
          local status = function()
            local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
            if #clients > 0 then
              local status = require("copilot.api").status.data.status
              return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
            end
          end
          return status() ~= nil
        end,
        color = function()
          return { fg = colors.fg, bg = colors.bg_dark }
        end,
      })

      local auto = require("lualine.themes.auto")
      local lualine_modes = { "insert", "normal", "visual", "command", "replace", "inactive", "terminal" }
      for _, field in ipairs(lualine_modes) do
        if auto[field] and auto[field].c then
          auto[field].c.bg = colors.bg_dark
        end
      end
      opts.options.theme = auto
      require("lualine").setup(opts)
      local lualine_nvim_opts = require("lualine.utils.nvim_opts")
      local base_set = lualine_nvim_opts.set

      lualine_nvim_opts.set = function(name, val, scope)
        if vim.env.TMUX and name == "statusline" then
          if scope and scope.window == vim.api.nvim_get_current_win() then
            vim.g.tpipeline_statusline = val
            vim.cmd("silent! call tpipeline#update()")
          end
          return
        end
        return base_set(name, val, scope)
      end
    end,
  },
  {
    "vimpostor/vim-tpipeline",
    dependencies = { "nvim-lualine/lualine.nvim" },
    event = "VeryLazy",
    enabled = vim.env.TMUX ~= nil,
    config = function()
      vim.opt.cmdheight = 0
      vim.opt.laststatus = 0
      vim.g.tpipeline_cursormoved = 1
      -- vim.g.tpipeline_clearstl = 1
      -- HACK: lualine hijacks the statusline, so we need to set it back to what we want
      -- if vim.env.TMUX then
      --   vim.cmd([[ autocmd WinEnter,BufEnter,VimResized,Filetype * setlocal laststatus=0 ]])
      -- end
    end,
  },
}
