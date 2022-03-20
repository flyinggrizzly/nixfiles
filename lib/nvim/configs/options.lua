vim.o.encoding = 'utf-8'


vim.o.backspace = 2
vim.o.nobackup = true
vim.o.nowritebackup = trye
vim.o.noswapfile = true    --- http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
vim.o.history = 50
vim.o.ruler = true         --- show the cursor position all the time
vim.o.showcmd = true       --- display incomplete commands
vim.o.incsearch = true     --- do incremental searching
vim.o.laststatus = 2       --- Always display the status line
vim.o.autowrite = true     --- Automatically :write before running commands
vim.o.modelines = 0        --- Disable modelines as a security precaution
vim.o.nomodeline = true

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
vim.o.nojoinspaces = true


--- Make it obvious where 120 characters is
vim.o.textwidth = 120
vim.o.colrcolumn = '+1'

set number
vim.o.number = true
vim.o.setnumberwidth = 5
