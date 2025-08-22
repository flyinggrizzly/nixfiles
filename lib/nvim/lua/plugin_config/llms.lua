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

  require("plugin_config/llms/codecompanion_fidget"):init()

  local codecompanion = require('codecompanion')
  codecompanion.setup({
    strategies = {
      chat = {
        adapter = "sonnet_37",
        send = {
          modes = { n = "<C-i>", i = "<C-i>" },
        },
      },

      inline = {
        adapter = "copilot",
      },
    },

    display = {
      action_palette = {
        provider = 'telescope',
      },
    },

    adapters = {
      sonnet_37 = function()
        return require("codecompanion.adapters").extend("anthropic", {
          name = "sonnet_37",
          schema = {
            model = {
              default = "claude-3-7-sonnet-20250219",
            },
          },
          env = {
            api_key = "cmd:op read op://Personal/anthropic-api-key/password"
          },
        })
      end,

      deepseek_r1 = function()
        return require("codecompanion.adapters").extend("ollama", {
          name = "deepseek_r1",
          schema = {
            model = {
              default = "deepseek-r1:1.5b",
            },
          },
        })
      end,
    },
  })

  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = 'LLM: ' .. desc })
  end

  if vim.fn.executable('claude') == 1 then
    require('coder-claude-code-nvim').setup()
  end

  map('<leader>lc', '<cmd>CodeCompanionChat Toggle<cr>', 'Open [L]LM [C]hat', { 'n', 'v' })
  map('<leader>la', '<cmd>CodeCompanionActions<cr>', 'Open [L]LM [A]ctions', { 'n', 'v' })
  map('al', '<cmd>CodeCompanionChat Add<cr>', '[A]dd selection to [L]LM chat', 'v')

  map('<leader>ll', '<cmd>ClaudeCode<cr>', '[L]aunch C[L]aude Code', { 'n', 'v' })
  map('<leader>llc', '<cmd>ClaudeCode --continue<cr>', '[L]aunch C[L]aude Code, [C]ontinue last convo', { 'n', 'v' })
  map('<leader>llr', '<cmd>ClaudeCode --resume<cr>', '[L]aunch C[L]aude Code, and [R]esume a convo from picker', { 'n', 'v' })
  map('<leader>llsm', '<cmd>ClaudeCodeSelectModel<cr>', '[L]aunch C[L]aude Code, [S]et [M]odel', { 'n', 'v' })
  map('<leader>llf', '<cmd>ClaudeCodeFocus<cr>', '[L]aunch C[L]aude Code, [F]ocus last convo window', { 'n', 'v' })
  map('<leader>llC', '<cmd>ClaudeCodeSend<cr>', 'Send to C[L]aude', { 'v' })
end
