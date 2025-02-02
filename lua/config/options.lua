-- add highlighting to weird files
vim.filetype.add({
  filename = {
    [".env"] = "sh",
    [".env.example"] = "sh",
    [".envrc"] = "sh",
    [".envrc.local"] = "sh",
    ["requirements.txt"] = "config",
    ["requirements-dev.txt"] = "config",
    ["requirements-test.txt"] = "config",
  },
})

-- don't show tab indicators
vim.opt.listchars = { tab = "  " }

-- make windows opaque
vim.opt.pumblend = 0 -- for cmp menu
vim.opt.winblend = 0 -- for documentation popup
