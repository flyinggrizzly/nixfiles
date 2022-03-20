Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'vim-ruby/vim-ruby'
"Plug 'Shopify/vim-sorbet', { 'branch': 'main' }
Plug 'zackhsi/sorbet.vim'
Plug 'tpope/vim-bundler'
Plug 'ngmy/vim-rubocop'
Plug 'tpope/vim-haml'

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
