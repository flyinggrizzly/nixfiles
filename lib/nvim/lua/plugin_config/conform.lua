require('conform').setup({
  formatters_by_ft = {
    ruby = { "rubocop" },
  },

  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    local lsp_format_opt

    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = 'never'
    else
      lsp_format_opt = 'fallback'
    end
    return {
      timeout_ms = 500,
      lsp_format = lsp_format_opt,
    }
  end,

  opts = {
    notify_on_error = false,
  },
})

vim.keymap.set('n', '<leader>m', ":Format<CR>", { desc = 'Format with Conform' })
