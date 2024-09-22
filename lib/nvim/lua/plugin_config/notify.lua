local mini_notify = require('mini.notify')

mini_notify.setup({
  window = {
    max_width_share = 0.65,
    config = function()
      local row = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus >= 2 and 1 or 0)
      return { border = 'solid', anchor = 'SE', row = row }
    end,
  },
})

vim.notify = mini_notify.make_notify({
  ERROR = { duration = 9000 }
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype

    if (ft == 'gitcommit') or (ft == 'help') then
      vim.b[args.buf].mininotify_disable = true
    end
  end
})
