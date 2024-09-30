local flash = require('flash')

flash.setup()

local function map(keys, desc, fn)
  vim.keymap.set('n', keys, fn, { desc = desc })
end

map(
  's',
  "[S]earch for 2 chars",
  function ()
    flash.jump()
  end
)

map(
  'S',
  "[S]earch for 2 chars, with Treesitter support",
  function ()
    flash.treesitter()
  end
)
