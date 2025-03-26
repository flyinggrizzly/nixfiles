local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-minitest")({
      --dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    --require("neotest-vim-test")({
      --ignore_file_types = { "python", "vim", "lua" },
    --}),
  },
  discovery = {
    enabled = false,
  },
})

local function mapn(keys, desc, runner)
  vim.keymap.set('n', keys, runner, { desc = desc })
end

mapn('<leader>t', 'Run [T]est under cursor', function ()
  neotest.run.run()
end)

mapn('<leader>tt', 'Run [TT]est file', function ()
  neotest.run.run(vim.fn.expand("%"))
end)

mapn('<leader>tl', 'Rerun [T]est [L]ast', function ()
  neotest.run.run_last()
end)
