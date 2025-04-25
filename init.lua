-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")


-- enable background transparency for all themes
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight SignColumn guibg=none
  highlight NormalFloat guibg=none
  highlight FloatBorder guibg=none
  highlight Pmenu guibg=none
  highlight PmenuSel guibg=#3a3a3a
  highlight CursorLine guibg=#1a1a1a
  highlight LineNr guibg=none
  highlight VertSplit guibg=none
  highlight StatusLine guibg=none
  highlight StatusLineNC guibg=none
  highlight TabLine guibg=none
  highlight TabLineFill guibg=none
  highlight Comment gui=italic
  highlight FoldColumn guibg=none
  highlight Folded guibg=none
]]
