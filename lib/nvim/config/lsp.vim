Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
Plug 'hrsh7th/nvim-compe'


autocmd User PlugLoaded ++nested source ~/.config/nvim/config/lsp_setup.lua

