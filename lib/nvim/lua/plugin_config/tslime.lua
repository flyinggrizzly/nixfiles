vim.cmd [[
  let g:tslime_always_current_session = 1
  let g:tslime_always_current_window = 1

  " Ruby indentation style
  let ruby_indent_block_style = 'do'

  " Automated testing
  autocmd FileType ruby map <silent> <leader>b :TestNearest<CR>
  autocmd FileType ruby map <silent> <leader>bb :TestFile<CR>
  autocmd FileType ruby map <silent> <leader>bl :TestLast<CR>
  autocmd FileType ruby map <silent> <leader>g :TestVisit<CR>

  let test#strategy = "tslime"
  let g:test#preserve_screen = 1

  let g:test#javascript#executable = 'pnpm exect jest'
  let g:test#typescript#executable = 'pnpm exect jest'
  let g:test#typescriptreact#executable = 'pnpm exect jest'

  let test#ruby#rspec#options = {
    \ 'nearest': '--fail-fast',
    \ 'file':    '--fail-fast',
    \ 'suite':   '--fail-fast',
  \}
]]
