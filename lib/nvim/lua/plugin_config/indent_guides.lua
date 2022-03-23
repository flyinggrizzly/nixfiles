vim.cmd [[
  " Enable by default
  let g:indent_guides_enable_on_vim_startup = 1

  " Set colors
  let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=61
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=18
]]

