vim.cmd [[
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
]]

vim.cmd [[
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " YANK LAST GIT SHA FOR LINE
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  func! YankLastShaForLine()
    :Git blame
    :normal! yiw

    " Need to make blame buffer modifiable to be able to delete it
    :set ma
    :bdelete

    :wincmd p
  endfunc

  " Workflow for quick fixups:
  " Use ys to yank the last SHA for the current line
  " Use yf to form a fixup command
  nmap <leader>ys :call YankLastShaForLine()<CR>
  nmap <leader>yf :Git commit --fixup=<c-r>0
]]
