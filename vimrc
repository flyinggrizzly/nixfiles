set encoding=utf-8

" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set modelines=0   " Disable modelines as a security precaution
set nomodeline

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile
    \ aliases.local,
    \zshenv.local,zlogin.local,zlogout.local,zshrc.local,zprofile.local,
    \*/zsh/configs/*
    \ set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
augroup END

" ALE linting events
augroup ale
  autocmd!

  if g:has_async
    autocmd VimEnter *
      \ set updatetime=1000 |
      \ let g:ale_lint_on_text_changed = 0
    autocmd CursorHold * call ale#Queue(0)
    autocmd CursorHoldI * call ale#Queue(0)
    autocmd InsertEnter * call ale#Queue(0) autocmd InsertLeave * call ale#Queue(0)
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Set tags for vim-fugitive
set tags^=.git/tags

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => BEGIN PERSONAL MODS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set spelllang=en
set spellfile=$HOME/nixfiles/vim-spell/en.utf-8.add " Point directly at file, not at symlink in ~/ so updates aren't lost

set incsearch nohlsearch " do incremental searching without residual highlighting
set smartcase     " Case insensitive searches, until an uppercase letter is type

let g:ag_prg="rg --vimgrep"

" Two settings to (potentially) aid in keeping the UI responsive, e.g. when
" scrolling
set ttyfast
set lazyredraw

" Set to auto read when a file is changed from the outside
set autoread

" Prevent auto line breaking, see http://vim.wikia.com/wiki/VimTip989
:set wrap
:set linebreak
:set nolist  " list disables linebreak
:set textwidth=0
:set wrapmargin=0

" Highlight column 120
let &colorcolumn="120,120"

" Appearance
set encoding=UTF-8
set guifont=Monoid_Nerd_Font_Mono:h11
try
  let g:molokai_original=0
  let g:rehash256 = 1
  colorscheme molokai
  highlight LineNr ctermfg=grey
catch
endtry

" Python package paths for NeoVim
"if has('nvim')
  "let g:python_host_prog  = system('$(which python2)')
  "let g:python2_host_prog  = system('$(which python2)')
  "let g:python3_host_prog = system('$(which python3)')
"endif

" Markdown tables
au Filetype markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

let g:vim_markdown_folding_disabled = 1

" Vim-Zoom
if !hasmapto('<Plug>(zoom-toggle)')
  nmap <Leader>m <Plug>(zoom-toggle)
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimwiki config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:vimwiki_list = [
  \{
    \ 'path' : '~/Dropbox/Apps/Editorial/wikis/personal',
    \ 'syntax' : 'markdown',
    \ 'ext' : '.md',
    \ 'auto_export' : 1
  \},
  \{
    \ 'path' : '~/Dropbox/Apps/Editorial/wikis/uncharted_worlds',
    \ 'syntax' : 'markdown',
    \ 'ext' : '.md',
    \ 'auto_export' : 1
  \}
\]
let g:vimwiki_autowriteall = 1 " 1 == on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerdtree config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Indent guides
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable by default
let g:indent_guides_enable_on_vim_startup = 1

" Set colors
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=17
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=56

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Linting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use Rubocop, ESLint
let g:ale_linters = {
\   'ruby': ['rubocop'],
\   'javascript': ['eslint']
\ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language specifics
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" React and JSX
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

let g:user_emmet_leader_key = '<C-Y>' " trigger completion with Ctrl-Y , <- don't forget the comma
let g:user_emmet_settings = {
\      'javascript.jsx' : { 'extends' : 'jsx' },
\      'javascript' : { 'extends' : 'jsx' },
\     }

" Ruby indentation style
let ruby_indent_block_style = 'do'

" Automated testing
autocmd FileType ruby map <silent> <leader>s :TestNearest<CR>
autocmd FileType ruby map <silent> <leader>t :TestFile<CR>
autocmd FileType ruby map <silent> <leader>l :TestLast<CR>
autocmd FileType ruby map <silent> <leader>g :TestVisit<CR>

let test#strategy = "tslime"
let g:test#preserve_screen = 1

let test#ruby#rspec#options = {
  \ 'nearest': '--fail-fast',
  \ 'file':    '--fail-fast',
  \ 'suite':   '--fail-fast',
\}

" By default assume that we want to target the current window in the current
" session for tslime commands, like test runs

let g:tslime_always_current_session=1
let g:tslime_always_current_window=1
let g:tmux_panenumber=2

nmap <Leader>u :Tmux bundle exec undercover<CR>
nmap <Leader>um :Tmux bundle exec undercover -c main<CR>

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" Zoom the tmux runner pane
map <Leader>vz :VimuxZoomRunner<CR>

" Ruby mode for .thor and .etl files
au BufRead,BufNewFile *.thor set filetype=ruby
au BufNewFile,BufRead *.etl set filetype=ruby
au BufNewFile,BufRead *.jbuilder set filetype=ruby
au BufNewFile,BufRead *.axlsx set filetype=ruby

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

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

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Start in hard mode by default
" autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()

" Toggle hard mode
nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>

" Configure custom shortcuts for moving between git hunks
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

let g:gitgutter_updatetime = 100

map y <Plug>(highlightedyank)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc#L202
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2  }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr><Paste>"

let g:coc_global_extensions = [
  \ 'coc-tsserver'
\ ]

silent! so ~/.coc.nvim.vimrc.local

augroup ale
  autocmd!
augroup END

nmap <Leader>ttf :TableFormat<CR>

