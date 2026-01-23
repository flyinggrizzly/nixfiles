local leap = require('leap')

local function do_leap(args)
  return function()
    leap.leap(args)
  end
end

vim.keymap.set({'n', 'x', 'o'}, 's',  do_leap())
vim.keymap.set({'n', 'x', 'o'}, 'S',  do_leap({ backward = true }))
