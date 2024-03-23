local colorscheme = 'tokyonight'

if colorscheme == 'tokyonight' then
  vim.cmd [[
    colorscheme tokyonight
  ]]
else
  vim.cmd [[
    set background=light
    let g:one_allow_italics = 1
    colorscheme one
  ]]
end
