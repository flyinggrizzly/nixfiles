Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'dhruvasagar/vim-zoom'

" Configure custom shortcuts for moving between git hunks
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

let g:gitgutter_updatetime = 100

" Map C-n to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" Show dotfiles
let NERDTreeShowHidden=1

" Git symbols
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
