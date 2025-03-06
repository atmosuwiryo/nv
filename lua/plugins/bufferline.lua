local g_ok, bufferline_groups = pcall(require, "bufferline.groups")
if not g_ok then
  bufferline_groups = {
    builtin = {
      pinned = {
        name = "pinned",
        with = function(_ico) end,
      },
      ungroupued = { name = "ungrouped" },
    },
  }
end
return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      close_command = function(n)
        Snacks.bufdelete(n)
      end,
      right_mouse_command = function(n)
        Snacks.bufdelete(n)
      end,
      diagnostics = false,
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = LazyVim.config.icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      hover = { enabled = true, reveal = { "close" } },
      mode = "buffers",
      sort_by = "insert_after_current",
      custom_areas = {
        right = function()
          return {
            { text = "%@TbToggle_theme@" .. vim.g.toggle_theme_icon .. "%X" },
            { text = "%@Quit_vim@󰗼 %X", fg = "#f7768e" },
          }
        end,
      },
      groups = {
        options = {
          toggle_hidden_on_enter = true,
        },
        items = {
          bufferline_groups.builtin.pinned:with({ icon = "" }),
          bufferline_groups.builtin.ungrouped,
          {
            name = "Internals",
            highlight = { fg = "#ECBE7B" },
            matcher = function(buf)
              return vim.startswith(buf.path, vim.env.VIMRUNTIME)
            end,
          },
          {
            highlight = { sp = "#51AFEF" },
            name = "Tests",
            icon = "",
            matcher = function(buf)
              local name = vim.api.nvim_buf_get_name(buf.id)
              return name:match("_spec") or name:match("_test") or name:match("test_")
            end,
          },
          {
            name = "Terraform",
            matcher = function(buf)
              return buf.name:match("%.tf") ~= nil
            end,
          },
          {
            name = "SQL",
            matcher = function(buf)
              local name = vim.api.nvim_buf_get_name(buf.id)
              return name:match("%.sql$")
            end,
          },
          {
            name = "View models",
            highlight = { sp = "#03589C" },
            matcher = function(buf)
              local name = vim.api.nvim_buf_get_name(buf.id)
              return name:match("view_model%.dart")
            end,
          },
          {
            name = "Screens",
            icon = "󰐯",
            matcher = function(buf)
              return buf.path:match("screen")
            end,
          },
          {
            highlight = { sp = "#C678DD" },
            name = "Docs",
            matcher = function(buf)
              for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
                if ext == vim.fn.fnamemodify(buf.path, ":e") then
                  return true
                end
              end
            end,
          },
          {
            highlight = { sp = "#F6A878" },
            name = "Config",
            matcher = function(buf)
              local name = vim.api.nvim_buf_get_name(buf.id)
              local filename_arr = vim.split(name, "/", { plain = true })
              local filename = nil
              if #filename_arr > 0 then
                filename = filename_arr[#filename_arr]
              end
              if filename == nil then
                return false
              end
              return filename:match("go.mod")
                or filename:match("go.sum")
                or filename:match("Cargo.toml")
                or filename:match("manage.py")
                or filename:match("Makefile")
            end,
          },
          {
            name = "Terms",
            auto_close = true,
            matcher = function(buf)
              return buf.path:match("term://") ~= nil
            end,
          },
        },
      },
      separator_style = vim.env.KITTY_WINDOW_ID and "slant" or "thin",
      show_close_icon = false,
      indicator = {
        icon = "▎", -- this should be omitted if indicator style is not 'icon'
        style = "icon", -- can also be 'underline'|'none',
      },
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      truncate_names = true, -- whether or not tab names should be truncated
      tab_size = 18,
      color_icons = true,
      show_buffer_close_icons = true,
      diagnostics_update_in_insert = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },
    },
  },
}
