local colorscheme = 'tokyonight'

if colorscheme == 'tokyonight' then

  return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000000, -- load first so we can be sexy
    config = function() 
      vim.cmd [[
        colorscheme tokyonight
      ]]
    end
  }

elseif colorscheme == 'dracula' then

  return  {
    'dracula/vim',
    lazy = false,
    priority = 1000000, -- load first so we can be sexy
    name = 'dracula',
    config = function()
      vim.cmd [[
        colorscheme dracula

        highlight Normal ctermbg=235
      ]]
    end
  }

else

  return  {
    "rakr/vim-one",
    lazy = false,
    priority = 1000000, -- load first so we can be sexy
    config = function()
      vim.cmd [[
        set background=light
        let g:one_allow_italics = 1
        colorscheme one
      ]]
    end
  }

end
