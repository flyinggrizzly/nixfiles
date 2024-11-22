local colorscheme = 'dracula'

if colorscheme == 'tokyonight' then
  vim.cmd [[
    colorscheme tokyonight
  ]]
elseif colorscheme == 'dracula' then
  vim.cmd [[
    colorscheme dracula
  ]]
else
  vim.cmd [[
    set background=light
    let g:one_allow_italics = 1
    colorscheme one
  ]]
end
