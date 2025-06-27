-- PRO TIPS:
-- 1. If a vim.cmd() works in nvim normatlly (":lua vim.cmd(...)") but not inside init.lua file, try to run the vim.cmd in init.lua inside vim.defer_fn as there seems to be an issue with vim running init.lua commands "too early" (whatever that means - asked ChatGPT) leading to the command not working

require('config.lazy')  -- Initialize lazy package manager so that it can manage different nvim packages for this session

vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- CLIPBOARD
vim.g.clipboard = 'osc52'
-- Copy visual selection to system clipboard, using default default "y" keystroke
vim.api.nvim_set_keymap(
   "v",
   "y",
   '"+y',
   {
      noremap = true,
      silent = true,
   }
)

-- Copy line to system clipboard, using default default "y" keystroke
vim.api.nvim_set_keymap(
   "n",
   "yy",
   '"+yy',
   {
      noremap = true,
      silent = true,
   }
)

-- OS SPECIFIC SETTINGS
-- Use Windows powershell on windows
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
   vim.opt.shell = "pwsh"
   vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
   vim.opt.shellquote = ''
   vim.opt.shellxquote = ""
end

-- VIM RESPONSIVENESS

vim.opt.timeoutlen = 300   -- Reducing the current time duration (1000 ms) taken by vim to register long-pressing of keys INSIDE INSERT MODE (like: pressing <j> in quick succession to enter <Esc>)
vim.opt.ttimeoutlen = 5    -- Same as above, but works in normal mode (the original vim ttimeout was 50 ms)

-- WINDOW SPLITS 

vim.g.netrw_keepdir = 0       -- Automatically change the working directory to the current folder that is open in Netrw file explorer
vim.g.netrw_altv = 1          -- Open the code window on the right-hand-side in nvim
vim.g.netrw_browse_split = 2
vim.g.netrw_winsize = 80      -- Limit Netrw (Nvim's "file explorer") to 20% of the screen size
vim.opt.hlsearch = true       -- Highlight the searches for keywords in a buffer
vim.opt.ignorecase = true     -- Ignore case while searching for keywords in a buffer
vim.opt.incsearch = true

vim.opt.number = true         -- Display line numbers on the left by default
vim.opt.relativenumber = true -- Make the line number = 0 where the cursor is, and number the rest of lines in the file from there on (0 -> current cursor position, 1 -> next line, and so on). This is helpful when I run a visual selection of python code, and an error showing line numbers RELATIVE to the starting of the chunk of code is shown (with the starting line being labeled as 1 in the error output). Doing this helps me see the corresponding line numbers in nvim buffer/editor as well

-- WIDTH SETTINGS FOR SPACES/TABS/ETC 

vim.opt.expandtab = true   -- Don't 'expand' the tab into spaces. With this setting, entering <tab> will not enter <tab>, but will enter <space> 8 times, instead. Note that this needs to come before softtabstop, tabstop, and shiftwidth, because it wasn't working otherwise
vim.opt.softtabstop = 3    -- When pressing backspace, delete 3 spaces at once (by treating them as 1 tabspace; helpful in deleting tabs fastly)
vim.opt.tabstop = 3        -- Set <tab> to 8 spaces
vim.opt.shiftwidth = 3     -- Set <shift> to 8 spaces

-- BUFFER NAVIGATION SHORTCUTS: Shortcuts for navigating amongst buffers by pressing Alt+<direction> instead of the nvim default of pressing Ctrl + w + <direction> (1 key-press lesser)

vim.api.nvim_set_keymap(   -- Left
   "n",                    -- Run this command in vim's normal mode
   "<M-h>",                -- Trigger it on pressing Alt + h
   "<C-w>h",               -- Ctrl + w + h: Switch to the buffer on the left of current/active buffer
   {
      noremap = true,      -- when I say <C-w>h/j/k/l, consider the original meaning of <C-w>h/j/k/l i.e., if you had remapped <C-w>h/j/k/l to some other keys also, the recursion won't happen while interpreting <C-w>h/j/k/l and instead the 'original meaning' will be taken into account
      silent = true
   }) 

vim.api.nvim_set_keymap(   -- Down
   "n", 
   "<M-j>", 
   "<C-w>j", 
   {
      noremap = true, 
      silent = true
   }) 

vim.api.nvim_set_keymap(   -- Up
   "n", 
   "<M-k>", 
   "<C-w>k", 
   {
      noremap = true, 
      silent = true
   })

vim.api.nvim_set_keymap(   -- Right
   "n", 
   "<M-l>", 
   "<C-w>l", 
   {
      noremap = true, 
      silent = true
   })

vim.api.nvim_set_keymap(   -- Use fastly-pressed 'j' key to act as <Esc> for less movement of fingers to the <Esc> key
   "i",                    -- Run this command in 'insert' mode
   "nn",                   -- Run it when I press 'j' twice fastly
   "<Esc>",                -- Enter normal mode (same as pressing <Esc> in plain nvim)
   {
      noremap = true,      -- No remapping of <Esc> (if I defined it anywhere), i.e., <Esc> should work as it does in plain vim
      silent = true
   })

vim.fn.timer_start(           -- Save all nvim buffers automatically after 60 seconds
   60000,
   function()
      vim.cmd('silent! wa')   -- Save/write all nvim buffers
   end,
   {['repeat'] = -1}
)

vim.g.molten_output_terminal = true       -- Sends output to a terminal buffer
vim.g.molten_output_terminal_cmd = "new"  -- Opens it in a new buffer below
vim.g.molten_image_provider = nil
-- CUSTOM AUTOCOMMANDS: Autocommands perform certain "Actions" automatically upon detecting happening of one or more "Triggering events"

vim.api.nvim_create_autocmd(           -- Un-highlight search results after I edit any part of my file after searching for any string in the file RATIONALE: The search-string remains highlighted even after I've edited the file using it, but no longer need it. This ends up distracting me a lot
   {  
      "BufEnter", 
      "TextChanged", 
      "TextChangedI"
   },                                  -- any kind of file content change (editing/adding text, triggers un-highlighting)
   {
      pattern = "*",                   -- Search clearning autocmd will work on all filetypes
      callback = function()            -- Function that runs upon file change
         vim.defer_fn(                 -- Vim was running "nohlsearch" too soon
            function()
               vim.cmd("nohlsearch")   -- To clear the search highlights
            end,                       -- The function vim.cmd("nohlsearch") was running too soon and was not working. 100 ms delay corrected this (I still need to understand this intricacy, but Protip 1. applies here)
            100      
         )
      end
   }
)

-- CUSTOM Ex COMMANDS 

vim.api.nvim_create_user_command(   -- Open the terminal in a vertical split on the right side of the current buffer
   "RightTerm",
   function()
      vim.cmd("vertical rightbelow split")
      vim.cmd("vertical resize 120%")
      vim.cmd("terminal")
   end,
   {}
)

-- PACKAGE SPECIFIC SETTINGS 

-- MOLTEN

-- vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/Scripts/python.exe") 
vim.g.python3_host_prog = vim.fn.expand("/home/madhur/.virtualenvs/neovim/bin/python") 

vim.keymap.set(                        -- Code execution shortcuts
   "n",
   "<localleader>mi",
   ":MoltenInit<CR>",                  -- Initializes the pip/conda environment whose jupyter kernel you want to use
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
      desc = "re-evaluate cell" 
   }
)


vim.keymap.set(   -- Run the code contained in the current visual selection, using Molten
   "v",
   "rr",
   ":<C-u>MoltenEvaluateVisual<CR>",   
   { 
      desc = "evaluate visual selection" 
   }
)

vim.keymap.set(
   "n",
   "<leader>os",
   ":noautocmd MoltenEnterOutput<CR>"
)

-- CUSTOM MOLTEN SHORTCUTS

vim.keymap.set(                                          -- Use <localleader>oo (\oo) to run everything from the 1st line to the current line
   "n",                                                  -- Keymapping runs in normal mode
   "<leader>ro",                                         -- Keypress: \oo
   function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)  -- Get the line number of the current cursor position
      cursor_row, cursor_col = unpack(cursor_pos)     
      vim.cmd("normal! 1GV" .. cursor_row .. "G")        -- Visually select from 1st line to the current line
      vim.cmd("normal! gv")                              -- Select the last visual selection (i.e., the one highlighted above) This is necessary as otherwise the nvim is deselcting the visual selection selected in the normal mode in the command above
      vim.cmd("MoltenEvaluateVisual")                    -- Run the current visual selection 
      vim.cmd("normal! " .. cursor_row .. "G")           -- Move the cursor back to the original line
      vim.cmd("normal! zz")                              -- Center the current line to the middle of the nvim window, to display the output properly
   end,
   {
      silent = true,
      desc = "test lua's ability to select line"
   }
)

-- MY CUSTOM LUA PLUGINS/SCRIPTS
vim.keymap.set(                                          -- Shortcut to highlight strings in nvim buffer, using perl
   "n",
   "<localleader>w",
   function()
      local perl_regex = vim.fn.input("Enter search term: ")
      require("hl").get_perl_regex_matches(perl_regex)
   end,
   {
      noremap = true,
      silent = true
   }
)

vim.keymap.set(
   "",
   "n",
   "j"
)

vim.keymap.set(
   "",
   "e",
   "k"
)

vim.keymap.set(
   "",
   "i",
   "l"
)

vim.keymap.set(
   "",
   "u",
   "i"
)

vim.keymap.set(
   "",
   "z",
   "b"
)

vim.keymap.set(
   "n",
   "y",
   "o"
)

vim.keymap.set(
   "",
   "s",
   "d"
)

vim.keymap.set(
   "n",
   "<C-s>",
   "<C-d>"
)

vim.keymap.set(
   "n",
   "m",
   "h"
)

vim.keymap.set(
   "n",
   "i",
   "u"
)

vim.keymap.set(
   "n",
   "l",
   "u"
)

vim.keymap.set(
   "n",
   "j",
   "y"
)

vim.keymap.set(
   "n",
   "j",
   "y"
)
