vim.cmd [[
  " Configure custom shortcuts for moving between git hunks
  nmap ]h <Plug>GitGutterNextHunk
  nmap [h <Plug>GitGutterPrevHunk

  let g:gitgutter_updatetime = 100

  set signcolumn=yes

  highlight! link SignColumn LineNr
  highlight GitGutterAdd    guifg=#009900 ctermfg=2
  highlight GitGutterChange guifg=#bbbb00 ctermfg=3
  highlight GitGutterDelete guifg=#ff2222 ctermfg=1
]]
