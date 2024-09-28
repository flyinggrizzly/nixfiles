vim.cmd [[
  let g:tslime_always_current_session = 1
  let g:tslime_always_current_window = 1

  " Ruby indentation style
  let ruby_indent_block_style = 'do'

  let test#strategy = "tslime"
  let g:test#preserve_screen = 1

  let g:test#javascript#runnr = 'jest'

  let test#ruby#rspec#options = {
    \ 'nearest': '--fail-fast',
    \ 'file':    '--fail-fast',
    \ 'suite':   '--fail-fast',
  \}
]]

vim.keymap.set('n', '<leader>t', ":TestNearest<CR>", { desc = 'Run [T]est under cursor' })
vim.keymap.set('n', '<leader>tt', ":TestFile<CR>", { desc = 'Run [TT]est file' })
vim.keymap.set('n', '<leader>tl', ":TestLast<CR>", { desc = 'Rerun [T]est [L]ast' })
vim.keymap.set('n', '<leader>tv', ":TestVisit<CR>", { desc = 'Rerun [T]est [V]isit' })
