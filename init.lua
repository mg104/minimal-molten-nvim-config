require('config.lazy')

vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

vim.g.netrw_browse_split = 2
vim.g.netrw_keepdir = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 80

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = false

vim.api.nvim_set_keymap("n", "<M-h>", "<C-w>h", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<M-j>", "<C-w>j", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<M-k>", "<C-w>k", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<M-l>", "<C-w>l", {noremap = true, silent = true})
vim.api.nvim_set_keymap("i", "jj", "<Esc>", {noremap = true, silent = true})

vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")
vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
    { silent = true, desc = "Initialize the plugin" })
vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
    { silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>",
    { silent = true, desc = "evaluate line" })
vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
    { silent = true, desc = "re-evaluate cell" })
vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>",
    { silent = true, desc = "evaluate visual selection" })
vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>")

vim.g.molten_output_terminal = true  -- Sends output to a terminal buffer
vim.g.molten_output_terminal_cmd = "new"  -- Opens it in a new buffer below

