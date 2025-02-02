local map = vim.keymap.set
local term = require("snacks.terminal")
local lazygit = require("snacks.lazygit")

-- run last ran command
map("n", "<leader>ol", "<cmd>OverseerRestartLast<cr>", { desc = "Overseer Run Last" })

-- comment line
map("n", "<leader>/", "<cmd>normal gcc<cr>", { desc = "Comment" })
map("v", "<leader>/", "<cmd>normal gcc<cr>", { desc = "Comment" })

-- quick clear highlighting
map("n", "<C-[>", "<cmd>nohlsearch<cr>", { noremap = true, silent = true })

-- next quickfix item
map("n", "]q", ":cnext<cr>zz", { noremap = true, silent = true, desc = "next quickfix" })

-- prev quickfix item
map("n", "[q", ":cprev<cr>zz", { noremap = true, silent = true, desc = "prev quickfix" })

-- better redo
map("n", "U", "<c-r>", { noremap = true, silent = true, desc = "redo" })

-- quick window quit
map("n", "<leader>qw", ":q<cr>", { noremap = true, silent = true, desc = "quit window" })

-- leader backspace to delete buffer
map("n", "<leader><bs>", ":bd<cr>", { noremap = true, silent = true, desc = "delete buffer" })

-- resume telescope after exiting
map("n", ";", "<cmd>lua require('telescope.builtin').resume(require('telescope.themes').get_ivy({}))<cr>")

-- move line up and down
map("v", "J", ":m '>+1<CR>gv==kgvo<esc>=kgvo", { desc = "move highlighted text down" })
map("v", "K", ":m '<-2<CR>gv==jgvo<esc>=jgvo", { desc = "move highlighted text up" })

-- floating terminal
map("n", "<c-/>", function()
  term.toggle()
end, { desc = "Terminal (root dir)" })

-- lazygit
map("n", "<leader>gg", function()
  lazygit.open()
end, { desc = "Lazygit (root dir)" })

-- diff
map("n", "<leader>ds", "<cmd>windo diffthis<cr>", { desc = "Diff Split" })
