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

vim.cmd [[
  " Display extra whitespace
  set list listchars=tab:»·,trail:·,nbsp:·
]]

--- Use one space, not two, after punctuation.
--- vim.o.nojoinspaces = true


--- Make it obvious where 120 characters is
vim.o.textwidth = 120
vim.o.colorcolumn = '+1'

vim.o.number = true


--- More natural feeling splits
vim.o.splitright = true
vim.o.splitbelow = true

--- Disable folding by default
vim.cmd [[
  let g:markdown_folding = 0
  set nofoldenable
  let g:vim_markdown_folding_disabled = 1
]]
