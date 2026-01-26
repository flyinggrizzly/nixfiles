local cmp = require('cmp')
local llms_enabled = require('helpers').llms_enabled()

cmp.setup({
  sources = (function()
    local sources = {
      {
        name = 'nvim_lsp',
        priority = 1000,
        group_index = 1,
        entry_filter = function(entry, _ctx)
          return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
        end
      },
      { name = 'nvim_lsp_signature_help', priority = 900, group_index = 1, },
      { name = 'emoji',                   priority = 100, group_index = 1, },
      { name = 'git',                     priority = 400, group_index = 1, },
      {
        name = 'buffer',
        priority = 300,
        group_index = 1,
        option = {
          -- Use all open buffers
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end
        }
      },
    }

    if llms_enabled then
      table.insert(sources, 1, { name = 'copilot', priority = 1100, group_index = 1, })
    end

    return sources
  end)(),

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

require('cmp_git').setup()


-- Add these highlight groups to your colorscheme setup or after/colors
vim.api.nvim_set_hl(0, 'CmpPmenu', { bg = '#e8e8e8' })       -- Light gray background
vim.api.nvim_set_hl(0, 'CmpPmenuBorder', { fg = '#999999' }) -- Border color
vim.api.nvim_set_hl(0, 'CmpDoc', { bg = '#f0f0f0' })         -- Even lighter documentation bg
