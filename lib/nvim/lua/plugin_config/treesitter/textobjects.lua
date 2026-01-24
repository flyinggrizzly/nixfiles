local ts_textobjects = require('nvim-treesitter-textobjects')

ts_textobjects.setup {
  select = {
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v',
      ['@function.outer'] = 'V',
      ['@class.outer'] = 'V',
    },
    include_surrounding_whitespace = true,
  },
  move = {
    set_jumps = false,
  },
}

vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
  ts_textobjects.goto_next_start(
    '@function.outer',
    'textobjects'
  )
  vim.cmd('normal! zz')
end)

vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
  ts_textobjects.goto_previous_start(
    '@function.outer',
    'textobjects'
  )
  vim.cmd('normal! zz')
end)
