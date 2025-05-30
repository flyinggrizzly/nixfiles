local snacks = require('snacks')
local colors = require('dracula').colors()

snacks.setup({
  picker = { enabled = true, },
  explorer = { enabled = true },

  bigfile = { enabled = false },
  dashboard = { enabled = false },
  indent = { enabled = false },
  input = { enabled = false },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
})

local function mapn(keys, fn, desc, callback)
  vim.keymap.set('n', keys, fn, { desc = desc })

  if callback ~= nil then
    callback()
  end
end

mapn('<C-p>', snacks.picker.smart, 'Ctrl-P Search Files (Smart)', function()
  vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = colors.purple })
  vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = colors.purple })
end)
mapn('<leader>sh', snacks.picker.help, '[S]earch [H]elp')
mapn('<leader>sk', snacks.picker.keymaps, '[S]earch [K]eymaps')
mapn('<leader>sw', snacks.picker.grep_word, '[S]earch [W]ord')
mapn('<leader>sg', snacks.picker.grep, '[S]earch [G]rep')
mapn('<leader>sr', snacks.picker.resume, '[S]earch [R]esume')
mapn('<leader>s.', snacks.picker.recent, '[S]earch Recent Files')
mapn('<leader>sc', snacks.picker.commands, '[S]earch [C]ommands')
mapn('<leader>sb', snacks.picker.buffers, '[S]earch [B]uffers')
mapn('<C-n>', snacks.explorer.reveal, 'Ctrl-N Search Explorer')
mapn('<leader>/', snacks.picker.lines, '[/] Fuzzy buffer search')

mapn('<leader>gl', snacks.picker.git_log, '[G]it [L]og')
mapn('<leader>gb', snacks.picker.git_log_line, '[G]it [b]lame')
mapn('<leader>gB', snacks.picker.git_log_file, '[G]it [B]lame (File)')
mapn('<leader>gs', snacks.picker.git_status, '[G]it [S]tatus')
mapn('<leader>gS', snacks.picker.git_stash, '[G]it [S]tash')
mapn('<leader>gd', snacks.picker.git_diff, '[G]it [D]iff')

mapn('<leader>gg', snacks.lazygit.open, 'Lazy [G]it')
mapn('<leader>gH', snacks.gitbrowse.open, 'Open in [G]it[H]ub')

-- Diagnostic mappings
mapn('<leader>sd', snacks.picker.diagnostics_buffer, '[S]earch [D]ocument diagnostics')
mapn('<leader>sD', snacks.picker.diagnostics, '[S]earch workspace [D]iagnostics')
