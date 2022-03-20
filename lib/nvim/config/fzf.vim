" If fzf has already been installed via Homebrew, use the existing fzf
" Otherwise, install fzf. The `--all` flag makes fzf accessible outside of vim
if isdirectory("/usr/local/opt/fzf")
  Plug '/usr/local/opt/fzf'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
endif

Plug 'junegunn/fzf.vim'

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>
