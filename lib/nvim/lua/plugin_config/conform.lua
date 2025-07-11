local conform = require('conform')

conform.setup({
  formatters_by_ft = {
    ruby = {},
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    html = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    erb = { "erb-format", "prettierd", "prettier" },
    nix = { "nixfmt" },
  },

  format_on_save = false,

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
