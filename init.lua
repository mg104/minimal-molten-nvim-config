-- PRO TIPS;

-- 1. If a vim.cmd() works in nvim normatlly (":lua vim.cmd(...)") but 
-- 	not inside init.lua file, try to run the vim.cmd in init.lua inside
-- 	vim.defer_fn as there seems to be an issue with vim running init.lua commands
-- 	"too early" (whatever that means - asked ChatGPT) leading to the command not
-- 	working

-- Initialize lazy package manager so that it can manage different nvim
-- packages for this session
require('config.lazy')

vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-------------------- BASIC TOOLS FOR INTERACTING -------------------
--------------------- WITH WINDOWS HOST (IN WSL) -------------------
-- Tell nvim to use "unnamed plus" ("+) by default
-- "+ is a register that is accessible to windows clipboards like
-- win32yank.exe (I installed it and added it to wsl linux PATH variable, 
-- so that linux can use it)
-- This will copy the yanked (copied) text from nvim into the windows
-- clipboard, and I can paste it outside nvim for later use
-- vim.opt.clipboard:append("unnamedplus")

-------------------- WINDOW SPLITS ---------------------------------

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

-------------------- DISPLAYING INSIDE BUFFER ----------------------

-- Display line numbers on the left by default
vim.opt.number = true

-------------------- SPACES/TABS/ETC -------------------------------

-- Setting <tab> to 3 spaces
vim.opt.tabstop = 3
-- Setting <shift> to 3 spaces
vim.opt.shiftwidth = 3
-- Don't 'expand' the tab into spaces (tab won't expand into 3 spaces, it
-- will remain as a single 'tab')
vim.opt.expandtab = false

-------------------- MOVEMENT --------------------------------------

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
-- vim.api.nvim_set_keymap("i", "jj", "<Esc>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("i", "jj", "<Esc>", {noremap = true, silent = true})

-- Save all nvim buffers automatically after 30 seconds
vim.fn.timer_start(
	60000,
	function()
		vim.cmd('silent! wa')
	end,
	{['repeat'] = -1}
)

vim.g.molten_output_terminal = true  -- Sends output to a terminal buffer
vim.g.molten_output_terminal_cmd = "new"  -- Opens it in a new buffer below

---------------- MY CUSTOM AUTOCOMMANDS -----------------------------
-- Autocommands perform certain "Actions" automatically upon detecting
-- happening of one or more "Triggering events"
---------------------------------------------------------------------

-- Create autocommand to un-highlight search results after I edit any 
-- part of my file after searching for any string in the file
-- Rationale: The search-string remains highlighted even after I've
-- 	edited the file using it, but no longer need it. This ends up
-- 	distracting me a lot
vim.api.nvim_create_autocmd({"BufEnter", "TextChanged", "TextChangedI"}, -- any kind of file content change (editing/adding
																								 -- text, triggers un-highlighting)
	{
	pattern = "*", -- Search clearning autocmd will work on all filetypes
	callback = function() -- Function that runs upon file change
		vim.defer_fn( -- Vim was running "nohlsearch" too soon
			function()
				-- vim.fn.setreg("/", "")
				vim.cmd("nohlsearch") -- To clear the search highlights
			end,
			100 -- The function vim.cmd("nohlsearch") was running too soon and was not working. 100 ms delay 
				 -- corrected this (I still need to understand this intricacy, but Protip 1. applies here)
		)
	end
	}
)

---------------- MY CUSTOM Ex COMMANDS ------------------------------

-- Create command to open the terminal in a vertical split
-- on the right side of the current buffer
vim.api.nvim_create_user_command(
	"RightTerm",
	function()
		vim.cmd("vertical rightbelow split")
		vim.cmd("vertical resize 120%")
		vim.cmd("terminal")
	end,
	{}
)

-------------- PACKAGE SPECIFIC SETTINGS ------------------------------

-------------------- MOLTEN.NVIM --------------------------------------

-- Make nvim use the python virtual environment that Molten.nvim package advises to use
-- This package will be used by nvim to do "python things". You can still create a separate 
-- pip or mamba env for your project and the project will use that (not the nvim python env)
vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")

-- Keymap shortcuts for the plugin Molten.nvim
vim.keymap.set(
	"n",
	"<localleader>mi",
	":MoltenInit<CR>", -- Initializes the pip/conda environment whose jupyter kernel you want to use
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
	":<C-u>MoltenEvaluateVisual<CR>",-- Run the code contained in the current visual selection. Honestly
												-- this is the only way of running commands in molten, is what I've 
												-- been able to use so far without errors (didn't have time to debug other
												-- ways of running cells in molten)
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

-------------- MY CUSTOM MOLTEN KEY MAPPINGS (SHORTCUTS) -----------------

-- Keymapping shortcut to use <localleader>oo (\oo) to run everything
-- from the 1st line to the current line
vim.keymap.set(
	-- Keymapping runs in normal mode
	"n",
	-- \oo
	"<localleader>oo",
	-- ":<C-u>MoltenEvaluateVisual | normal! ''<CR>",
	function()
		-- Get the line number of the current line on which
		-- the cursor is present currently
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		cursor_row, cursor_col = unpack(cursor_pos)
		-- Visually select from 1st line to the current line
		vim.cmd("normal! 1GV" .. cursor_row .. "G")
		-- Get the last visual selection (i.e., the one highlighted above)
		-- This is necessary as otherwise the nvim is deselcting the visual
		-- selection selected in the normal mode in the command above
		vim.cmd("normal! gv")
		-- Run the current visual selection
		vim.cmd("MoltenEvaluateVisual")
		-- Move the cursor back to the original line
		vim.cmd("normal! " .. cursor_row .. "G")
		-- Center the current line to the middle of the nvim window
		-- This is useful for looking at the output of the Molten cell being run
		vim.cmd("normal! zz")
	end,
	{
		silent = true,
		desc = "test lua's ability to select line"
	}
)
