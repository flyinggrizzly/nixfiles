local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-minitest"),
    require("neotest-plenary"),
  },

  discovery = {
    enabled = false,
  },

  summary = {
    enabled = true,
    open = 'botright vsplit', -- Open summary in a vertical split on the right
    win_options = {
      relativenumber = false,
      number = false,
    },
  },
})

local function mapn(keys, desc, runner)
  vim.keymap.set('n', keys, runner, { desc = desc })
end

mapn('<leader>t', 'Run [T]est under cursor', function ()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local path_with_line = vim.fn.expand("%") .. ":" .. row

  neotest.run.run(path_with_line)
end)

mapn('<leader>tt', 'Run [TT]est file', function()
  neotest.run.run(vim.fn.expand("%"))
end)

mapn('<leader>tl', 'Rerun [T]est [L]ast', function()
  neotest.run.run_last()
end)

mapn('<leader>ts', 'Toggle Neotest Summary', function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local summary_win = nil

  -- Check if summary is open in any window
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'neotest-summary' then
      summary_win = win
      break
    end
  end

  if summary_win ~= nil then
    -- If summary is open in the current window, close it
    if vim.api.nvim_win_get_buf(0) == vim.api.nvim_win_get_buf(summary_win) then
      vim.api.nvim_win_close(summary_win, false)
    else
      -- If summary is open in another window, open it in current window
      vim.cmd('wincmd o') -- Close other windows
      neotest.summary.open()
    end
  else
    -- If summary is not open, open it
    neotest.summary.open()
  end
end)
