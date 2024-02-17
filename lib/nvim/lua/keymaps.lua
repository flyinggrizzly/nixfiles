local keymap = require'lib.utils'.keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('', 'gf', ':edit <cfile><CR>')


vim.cmd [[
  " zoom a vim pane, <C-w>= to re-balance
  nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
  nnoremap <leader>= :wincmd =<cr>

  " jk in rapid succession will bring you out of insert mode
  inoremap jk <esc>
  inoremap kj <esc>

  cnoremap jk <c-c>
  cnoremap kj <c-c>

  vnoremap v <esc>

  " Quick save shortcut
  noremap <Leader>f :update<CR>

  " Quick tab switching
  nnoremap H gT
  nnoremap L gt

  " Get off my lawn
  nnoremap <Left> :echoe "Use h"<CR>
  nnoremap <Right> :echoe "Use l"<CR>
  nnoremap <Up> :echoe "Use k"<CR>
  nnoremap <Down> :echoe "Use j"<CR>
]]
