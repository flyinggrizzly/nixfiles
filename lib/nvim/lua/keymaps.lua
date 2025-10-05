

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

keymap('', 'gf', ':edit <cfile><CR>')

vim.cmd [[
  " zoom a vim pane, <C-w>= to re-balance
  nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
  nnoremap <leader>= :wincmd =<cr>

  " jk in rapid succession will bring you out of insert mode
  inoremap jk <esc>
  inoremap kj <esc>

  cnoremap jk <c-c>
  cnoremap kj <c-c>

  vnoremap v <esc>

  " Quick save shortcut
  noremap <Leader>f :update<CR>

  " Quick tab switching
  nnoremap H gT
  nnoremap L gt

  " Get off my lawn
  " nnoremap <Left> :echoe "Use h"<CR>
  " nnoremap <Right> :echoe "Use l"<CR>
  " nnoremap <Up> :echoe "Use k"<CR>
  " nnoremap <Down> :echoe "Use j"<CR>
]]

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Markdown TODO keybindings
vim.keymap.set('n', '<leader>dd', function()
  if vim.bo.filetype ~= "markdown" then return end

  local line = vim.fn.getline('.')
  local new_line = line:gsub("^(%s*)%-%s%[(.)%]%s?(.*)", function(indent, status, text)
    local new_status = status == " " and "x" or " "
    return indent .. "- [" .. new_status .. "] " .. text
  end)

  vim.fn.setline('.', new_line)
end, { desc = 'Toggle markdown TODOs' })

vim.keymap.set('v', '<leader>dd', function()
  if vim.bo.filetype ~= "markdown" then return end

  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  for line_nr = start_line, end_line do
    local line = vim.fn.getline(line_nr)
    local new_line = line:gsub("^(%s*)%-%s%[(.)%]%s?(.*)", function(indent, status, text)
      local new_status = status == " " and "x" or " "
      return indent .. "- [" .. new_status .. "] " .. text
    end)
    vim.fn.setline(line_nr, new_line)
  end
end, { desc = 'Toggle markdown TODOs' })

vim.keymap.set('n', '<leader>dx', function()
  if vim.bo.filetype ~= "markdown" then return end

  local line = vim.fn.getline('.')
  local new_line = line:gsub("^(%s*)%-%s%[.%]%s?(.*)", function(indent, text)
    return indent .. "- ~~" .. text .. "~~"
  end)

  vim.fn.setline('.', new_line)
end, { desc = 'Cancel markdown TODOs' })

vim.keymap.set('v', '<leader>dx', function()
  if vim.bo.filetype ~= "markdown" then return end

  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  local start_line = start_pos[1]
  local end_line = end_pos[1]

  for line_nr = start_line, end_line do
    local line = vim.fn.getline(line_nr)
    local new_line = line:gsub("^(%s*)%-%s%[.%]%s?(.*)", function(indent, text)
      return indent .. "- ~~" .. text .. "~~"
    end)
    vim.fn.setline(line_nr, new_line)
  end
end, { desc = 'Cancel markdown TODOs' })

vim.keymap.set('n', '<leader>dX', function()
  if vim.bo.filetype ~= "markdown" then return end

  require('snacks').input({
    prompt = "Cancellation reason: ",
  }, function(reason)
    if not reason then return end

    local line = vim.fn.getline('.')
    local new_line = line:gsub("^(%s*)%-%s%[.%]%s?(.*)", function(indent, text)
      return indent .. "- ~~" .. text .. "~~ CANCELLED: " .. reason
    end)

    vim.fn.setline('.', new_line)
  end)
end, { desc = 'Cancel markdown TODOs with reason' })

vim.keymap.set('v', '<leader>dX', function()
  if vim.bo.filetype ~= "markdown" then return end

  require('snacks').input({
    prompt = "Cancellation reason: ",
  }, function(reason)
    if not reason then return end

    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')
    local start_line = start_pos[1]
    local end_line = end_pos[1]

    for line_nr = start_line, end_line do
      local line = vim.fn.getline(line_nr)
      local new_line = line:gsub("^(%s*)%-%s%[.%]%s?(.*)", function(indent, text)
        return indent .. "- ~~" .. text .. "~~ CANCELLED: " .. reason
      end)
      vim.fn.setline(line_nr, new_line)
    end
  end)
end, { desc = 'Cancel markdown TODOs' })

vim.keymap.set('n', '<leader>tm', '<cmd>TableModeToggle<cr>', { desc = 'Toggle [T]able [M]ode' })
