--- https://github.com/bartzon/dotfiles/blob/main/config/nvim/plugins/nvim-lsp.vim

vim.lsp.set_log_level("debug")

vim.lsp.stop_client(vim.lsp.get_active_clients())

require('mason').setup()
require('mason-lspconfig').setup()

local nvim_lsp = require'lspconfig'

local nnoremap = function (lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, {noremap = true, silent = true})
end

local on_attach = function ()
  local mappings = {
    ['K'] = "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>",
    ['gd'] = "<cmd>lua vim.lsp.buf.definition()<CR>",
    ['gi'] = "<cmd>lua vim.lsp.buf.implementation()<CR>",
    ['gh'] = "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>",
    ['gl'] = "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    ['gr'] = "<cmd>lua vim.lsp.buf.references()<CR>",
    ['rn'] = "<cmd>lua vim.lsp.buf.rename()<CR>",

    ['[d'] = "<cmd>lua vim.diagnostic.goto_prev()<CR>",
    [']d'] = "<cmd>lua vim.diagnostic.goto_next()<CR>",
  }

  for lhs, rhs in pairs(mappings) do
    nnoremap(lhs, rhs)
  end
end

--local configs = require 'lspconfig.configs'
--if not configs.rubocop_lsp then
  --configs.rubocop_lsp = {
    --default_config = {
      --cmd = {'bundle', 'exec', 'rubocop-lsp'};
      --filetypes = {'ruby'};
      --root_dir = function(fname)
        --return nvim_lsp.util.find_git_ancestor(fname)
      --end;
      --settings = {};
    --};
  --}
--end

nvim_lsp.tsserver.setup{
  on_attach = on_attach
}

nvim_lsp.sorbet.setup{
  cmd = {'srb', 'tc', '--lsp'};
  on_attach = on_attach,
  completion = {
    autocomplete = false,
  }
}

require('lspsaga').setup({})

vim.diagnostic.config({virtual_text = false})
