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

