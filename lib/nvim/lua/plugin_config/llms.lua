local function is_git_subprocess()
  -- Check Git-specific environment variables
  if vim.env.GIT_EXEC_PATH ~= nil or
      vim.env.GIT_EDITOR ~= nil or
      vim.env.GIT_SEQUENCE_EDITOR ~= nil then
    return true
  end

  -- Check if Neovim was invoked via git commit, rebase, etc.
  -- by examining process arguments
  local args = vim.v.argv
  for _, arg in ipairs(args) do
    if arg:match("COMMIT_EDITMSG$") or
        arg:match("git%-rebase%-todo$") or
        arg:match("MERGE_MSG$") then
      return true
    end
  end

  return false
end

if not is_git_subprocess() then
  require('copilot').setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
  })

  require("plugin_config/llms/codecompanion_fidget"):init()

  local codecompanion = require('codecompanion')
  codecompanion.setup({
    strategies = {
      chat = {
        adapter = "sonnet_37",
        send = {
          modes = { n = "<C-s>", i = "<C-s>" },
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

  map('<leader>lc', '<cmd>CodeCompanionChat Toggle<cr>', 'Open [L]LM [C]hat', { 'n', 'v'})
  map('<leader>la', '<cmd>CodeCompanionActions<cr>', 'Open [L]LM [A]ctions', { 'n', 'v'})
  map('al', '<cmd>CodeCompanionChat Add<cr>', '[A]dd selection to [L]LM chat', 'v')
end
