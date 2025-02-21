local opt = vim.opt

local function link(group, other)
  vim.cmd("highlight! link " .. group .. " " .. other)
end

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
opt.pumblend = 0 -- for cmp menu
opt.winblend = 0 -- for documentation popup
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Case sensitive when uppercase
opt.undofile = true -- Enable undo file
opt.swapfile = false -- Disable swap file
opt.showmode = false
opt.iskeyword:append("-") -- Treat words separated by - as one word
opt.clipboard:append("unnamedplus") -- Enable copying to system clipboard

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

link("MarkviewHeading1", "rainbow1")
link("MarkviewHeading1Sign", "rainbow1")
link("MarkviewHeading2", "rainbow2")
link("MarkviewHeading2Sign", "rainbow2")
link("MarkviewHeading3", "rainbow3")
link("MarkviewHeading4", "rainbow4")
link("MarkviewHeading5", "rainbow5")
link("MarkviewHeading6", "rainbow6")
