local opt = vim.opt

local function link(group, other)
  vim.cmd("highlight! link " .. group .. " " .. other)
end

-- add highlighting to weird files
vim.filetype.add({
  extension = {
    fnl = "fennel",
    wiki = "markdown",
  },
  filename = {
    [".env"] = "sh",
    [".env.example"] = "sh",
    [".envrc"] = "sh",
    [".envrc.local"] = "sh",
    ["requirements.txt"] = "config",
    ["requirements-dev.txt"] = "config",
    ["requirements-test.txt"] = "config",
    ["go.sum"] = "gosum",
    ["go.mod"] = "gomod",
  },
  pattern = {
    ["*.tml"] = "gohtmltmpl",
    ["%.env.*"] = "sh",
  },
})

-- don't show tab indicators
vim.opt.listchars = { tab = "  " }

-- default options
opt.ttyfast = true
opt.termguicolors = true
opt.updatetime = 100
opt.timeoutlen = 250
opt.redrawtime = 1500
opt.ttimeoutlen = 10
opt.wrapscan = true -- Searches wrap around the end of the file
vim.o.secure = true -- Disable autocmd etc for project local vimrc files.
vim.o.exrc = false -- Allow project local vimrc files example .nvimrc see :h exrc
opt.confirm = true -- make vim prompt me to save before doing destructive things
opt.autowriteall = true -- automatically :write before running commands and changing files
vim.g.editorconfig = true
vim.g.lazyvim_blink_main = true
opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim"
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Case sensitive when uppercase
opt.undofile = true -- Enable undo file
opt.swapfile = false -- Disable swap file
opt.showmode = false
opt.iskeyword:append("-") -- Treat words separated by - as one word
opt.clipboard:append("unnamedplus") -- Enable copying to system clipboard
opt.fillchars = {
  fold = " ",
  eob = " ", -- suppress ~ at EndOfBuffer
  diff = "╱", -- alternatives = ⣿ ░ ─
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
opt.wildignore = {
  "*.aux,*.out,*.toc",
  "*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
  -- media
  "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
  "*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
  "*.eot,*.otf,*.ttf,*.woff",
  "*.doc,*.pdf",
  -- archives
  "*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
  -- temp/system
  "*.*~,*~ ",
  "*.swp,.lock,.DS_Store,._*,tags.lock",
  -- version control
  ".git,.svn",
  --rust
  "Cargo.lock,Cargo.Bazel.lock",
}

-- make windows opaque
opt.pumblend = 0 -- for cmp menu
opt.winblend = 0 -- for documentation popup

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

-- Lines
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.cursorline = true

-- Appearance
opt.scrolloff = 10
opt.sidescrolloff = 10

-- disable autoformat
vim.g.autoformat = false

-- custom
if vim.env.USER == "abz" then
  vim.g.lazyvim_python_lsp = "pylance"
else
  vim.g.lazyvim_python_lsp = "basedpyright"
end
vim.g.lazyvim_python_ruff = "ruff"

-- highlights
-- get highlights from highlight groups
-- local function get_hlgroup(name, fallback)
--   if vim.fn.hlexists(name) == 1 then
--     local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
--     if not hl.fg then
--       hl.fg = "NONE"
--     end
--     if not hl.bg then
--       hl.bg = "NONE"
--     end
--     if hl.reverse then
--       hl.fg, hl.bg, hl.reverse = hl.bg, hl.fg, nil
--     end
--     return hl
--   end
--   return fallback or {}
-- end
-- local bg = get_hlgroup("Normal").bg
-- local fg = get_hlgroup("Cursor").bg
-- local bg_alt = get_hlgroup("Cursor").fg
-- local green = get_hlgroup("String").fg
-- local red = get_hlgroup("ErrorMsg").fg
local function set_hl(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end
local bg = "#161621"
-- local fg = "#d9e0ee"
local fg = "#cdd6f4"
local bg_alt = "#242438"
local red = "#f38ba8"
local green = "#a6e3a1"
link("MarkviewHeading1", "rainbow1")
link("MarkviewHeading1Sign", "rainbow1")
link("MarkviewHeading2", "rainbow2")
link("MarkviewHeading2Sign", "rainbow2")
link("MarkviewHeading3", "rainbow3")
link("MarkviewHeading4", "rainbow4")
link("MarkviewHeading5", "rainbow5")
link("MarkviewHeading6", "rainbow6")
set_hl("TelescopeBorder", { fg = bg_alt, bg = bg })
set_hl("TelescopeNormal", { bg = bg })
set_hl("TelescopeSelection", { bg = bg_alt })
set_hl("TelescopePreviewBorder", { fg = bg, bg = bg })
set_hl("TelescopePreviewNormal", { bg = bg })
set_hl("TelescopePreviewTitle", { fg = bg, bg = green })
set_hl("TelescopePromptBorder", { fg = bg_alt, bg = bg_alt })
set_hl("TelescopePromptNormal", { fg = fg, bg = bg_alt })
set_hl("TelescopePromptPrefix", { fg = red, bg = bg_alt })
set_hl("TelescopePromptTitle", { fg = bg, bg = red })
set_hl("TelescopeResultsBorder", { fg = bg, bg = bg })
set_hl("TelescopeResultsNormal", { bg = bg })
set_hl("TelescopeResultsTitle", { fg = bg, bg = bg })

-- fold
opt.foldtext = "v:lua.require'config.utils'.foldtext()"

-- quickfix
opt.qftf = "{info -> v:lua.require'config.utils'.qftf(info)}"

--bufferline
vim.g.toggle_theme_icon = "   "
vim.cmd("function! TbToggle_theme(a,b,c,d) \n lua require('config.utils').toggle_theme() \n endfunction")
vim.cmd("function! Quit_vim(a,b,c,d) \n qa \n endfunction")
