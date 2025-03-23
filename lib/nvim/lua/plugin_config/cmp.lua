local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'buffer', },
    { name = 'tmux' },
  },

  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = 'Normal:NormalFloat,FloatBorder:CmpDocBorder,Search:None',
    },
    completion = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = 'Normal:NormalFloat,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
    },
  },

  -- For an understanding of why these mappings were
  -- chosen, you will need to read `:help ins-completion`
  --
  -- No, but seriously. Please read `:help ins-completion`, it is really good!
  mapping = cmp.mapping.preset.insert {
    -- Scroll the documentation window [b]ack / [f]orward
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),

    -- Manually trigger a completion from nvim-cmp.
    --  Generally you don't need this, because nvim-cmp will display
    --  completions whenever it has completion options available.
    ['<C-Space>'] = cmp.mapping.complete {},
  },
})

require("copilot_cmp").setup()

-- Add these highlight groups to your colorscheme setup or after/colors
vim.api.nvim_set_hl(0, 'CmpPmenu', { bg = '#e8e8e8' })  -- Light gray background
vim.api.nvim_set_hl(0, 'CmpPmenuBorder', { fg = '#999999' })  -- Border color
vim.api.nvim_set_hl(0, 'CmpDoc', { bg = '#f0f0f0' })  -- Even lighter documentation bg
