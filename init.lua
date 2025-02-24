-- Initialize lazy package manager so that it can manage different nvim
-- packages for this session
require('config.lazy')

vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-------------------- WINDOW SPLITS --------------------

vim.g.netrw_browse_split = 2
-- Automatically change the working directory to the current
-- folder that is open in Netrw file explorer
vim.g.netrw_keepdir = 0
-- Setting to open the code window on the right-hand-side in nvim
vim.g.netrw_altv = 1
-- Setting Netrw (Nvim's "file explorer") to 20% of the screen size
vim.g.netrw_winsize = 80

-- Highlight the searches for keywords in a buffer
vim.opt.hlsearch = true
-- Ignore case while searching for keywords in a buffer
vim.opt.ignorecase = true
vim.opt.incsearch = true

-------------------- SPACES/TABS/ETC --------------------

-- Setting <tab> to 3 spaces
vim.opt.tabstop = 3
-- Setting <shift> to 3 spaces
vim.opt.shiftwidth = 3
-- Don't 'expand' the tab into spaces (tab won't expand into 3 spaces, it
-- will remain as a single 'tab')
vim.opt.expandtab = false

-------------------- MOVEMENT --------------------

-- Keymaps shortcuts for pressing Alt+<direction> instead of Ctrl + w + <direction>
-- (less keys to press) to switch to window that is:

-- Command syntax:
-- n: Run this command in vim's normal mode
-- <M-x>: Alt + <x>: Resulting keymap
-- <C-w>x: Ctrl + w + <x>: Current keymap which I want to change
-- noremap = true: when I say <C-w>h/j/k/l, consider the original meaning of <C-w>h/j/k/l
-- 	i.e., if you had remapped <C-w>h/j/k/l to some other keys also, the recursion won't 
-- 	happen while interpreting <C-w>h/j/k/l and instead the 'original meaning' will be
-- 	taken into account

-- Left
vim.api.nvim_set_keymap("n", "<M-h>", "<C-w>h", {noremap = true, silent = true})
-- Down
vim.api.nvim_set_keymap("n", "<M-j>", "<C-w>j", {noremap = true, silent = true})
-- Up
vim.api.nvim_set_keymap("n", "<M-k>", "<C-w>k", {noremap = true, silent = true})
-- Right
vim.api.nvim_set_keymap("n", "<M-l>", "<C-w>l", {noremap = true, silent = true})

-- Use fastly-pressed 'j' key to act as <Esc> for less movement of fingers to the 
-- <Esc> key
vim.api.nvim_set_keymap("i", "jj", "<Esc>", {noremap = true, silent = true})

-------------------- PACKAGE SPECIFIC SETTINGS --------------------

-------------------- MOLTEN.NVIM --------------------

-- Make nvim use the python virtual environment that Molten.nvim package advises to use
-- This package will be used by nvim to do "python things". You can still create a separate 
-- pip or mamba env for your project and the project will use that (not the nvim python env)
vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")

-- Keymap shortcuts for the plugin Molten.nvim
vim.keymap.set(
	"n",
	"<localleader>mi",
	":MoltenInit<CR>",
	{
		silent = true, 
		desc = "Initialize the plugin" 
	}
)

vim.keymap.set(
	"n",
	"<localleader>e",
	":MoltenEvaluateOperator<CR>",
	{
		silent = true, 
		desc = "run operator selection" 
	}
)

vim.keymap.set(
	"n",
	"<localleader>rl",
	":MoltenEvaluateLine<CR>",
	{
		silent = true,
		desc = "evaluate line" 
	}
)

vim.keymap.set(
	"n",
	"<localleader>rr",
	":MoltenReevaluateCell<CR>",
	{ 
		silent = true,
		desc = "re-evaluate cell" 
	}
)

vim.keymap.set(
	"v",
	"<localleader>r",
	":<C-u>MoltenEvaluateVisual<CR>",
	{ 
		silent = true,
		desc = "evaluate visual selection" 
	}
)

vim.keymap.set(
	"n",
	"<localleader>os",
	":noautocmd MoltenEnterOutput<CR>"
)

vim.g.molten_output_terminal = true  -- Sends output to a terminal buffer
vim.g.molten_output_terminal_cmd = "new"  -- Opens it in a new buffer below

