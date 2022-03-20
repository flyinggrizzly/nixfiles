" React and JSX
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

let g:user_emmet_leader_key = '<C-Y>' " trigger completion with Ctrl-Y , <- don't forget the comma
let g:user_emmet_settings = {
\      'javascript.jsx' : { 'extends' : 'jsx' },
\      'javascript' : { 'extends' : 'jsx' },
\     }

Plug 'pangloss/vim-javascript'
Plug 'jxnblk/vim-mdx-js'
Plug 'mattn/emmet-vim'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
