-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")


-- enable background transparancy for winteriscoming theme
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
