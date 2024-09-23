vim.o.encoding = 'utf-8'

vim.o.backspace = '2'
vim.o.history = 50
vim.o.ruler = true         --- show the cursor position all the time
vim.o.showcmd = true       --- display incomplete commands
vim.o.incsearch = true     --- do incremental searching
vim.o.laststatus = 2       --- Always display the status line
vim.o.autowrite = true     --- Automatically :write before running commands
vim.cmd [[
  set noswapfile
  set nobackup
  set nowritebackup
]]

--- Softtabs, 2 spaces
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.shiftround = true
vim.o.expandtab = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

--- Use one space, not two, after punctuation.
--- vim.o.nojoinspaces = true


--- Make it obvious where 120 characters is
vim.o.textwidth = 120
vim.o.colorcolumn = '+1'

vim.o.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

--- More natural feeling splits
vim.o.splitright = true
vim.o.splitbelow = true

--- Disable folding by default
vim.cmd [[
  let g:markdown_folding = 0
  set nofoldenable
  let g:vim_markdown_folding_disabled = 1
]]

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--vim.schedule(function()
  --vim.opt.clipboard = 'unnamedplus'
--end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
