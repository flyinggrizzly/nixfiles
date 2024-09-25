local conform = require('conform')

conform.setup({
  formatters_by_ft = {
    ruby = { "rubocop" },
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
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

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end

  conform.format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.keymap.set('n', '<leader>m', ":Format<CR>", { desc = 'Format with Conform' })
