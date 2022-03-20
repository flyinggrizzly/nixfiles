local keymap = require'lib.utils'.keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('', 'gf', ':edit <cfile><CR>')

vim.cmd [[
  noremap <Leader>f :update<CR>

  nmap <silent> <C-h> <C-w>h
  nmap <silent> <C-j> <C-w>j
  nmap <silent> <C-k> <C-w>k
  nmap <silent> <C-l> <C-w>l

  nnoremap H gT
  nnoremap L gt

  vnoremap < <gv
  vnoremap > >gv

  " Maintain the cursor position when yanking a visual selection
  " http://ddrscott.github.io/blog/2016/yank-without-jank/
  vnoremap y myy`y
  vnoremap Y myY`y

  inoremap jk <esc>
  inoremap kj <esc>

  cnoremap jk <c-c>
  cnoremap kj <c-c>

  vnoremap v <esc>
]]

