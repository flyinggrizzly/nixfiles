local has_custom_llms, custom_llms = pcall(require, 'plugin_config/custom_llms')
if has_custom_llms then
  return custom_llms
end

if not require('helpers').is_git_subprocess() then
  require('copilot').setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    copilot_model = "gpt-4o-copilot",
  })
  require("copilot_cmp").setup()

  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = 'LLM: ' .. desc })
  end

  if vim.fn.executable('claude') == 1 then
    require('claudecode').setup()
  end

  map('<leader>ll', '<cmd>ClaudeCode<cr>', '[L]aunch C[L]aude Code', { 'n', 'v' })
  map('<leader>llc', '<cmd>ClaudeCode --continue<cr>', '[L]aunch C[L]aude Code, [C]ontinue last convo', { 'n', 'v' })
  map('<leader>llr', '<cmd>ClaudeCode --resume<cr>', '[L]aunch C[L]aude Code, and [R]esume a convo from picker', { 'n', 'v' })
  map('<leader>llsm', '<cmd>ClaudeCodeSelectModel<cr>', '[L]aunch C[L]aude Code, [S]et [M]odel', { 'n', 'v' })
  map('<leader>llf', '<cmd>ClaudeCodeFocus<cr>', '[L]aunch C[L]aude Code, [F]ocus last convo window', { 'n', 'v' })
  map('<leader>llC', '<cmd>ClaudeCodeSend<cr>', 'Send to C[L]aude', { 'v' })
end
