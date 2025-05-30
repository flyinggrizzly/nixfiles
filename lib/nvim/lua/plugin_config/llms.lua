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
    require('claude-code').setup({
      window = {
        split_ratio = 0.3,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
        position = "vertical",  -- Position of the window: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
        enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
        hide_numbers = false,   -- Hide line numbers in the terminal window
        hide_signcolumn = true, -- Hide the sign column in the terminal window
      },
      refresh = {
        enable = true,             -- Enable file change detection
        updatetime = 100,          -- updatetime when Claude Code is active (milliseconds)
        timer_interval = 1000,     -- How often to check for file changes (milliseconds)
        show_notifications = true, -- Show notification when files are reloaded
      },
      git = {
        use_git_root = true,     -- Set CWD to git root when opening Claude Code (if in git project)
      },
      command = "claude",        -- Command used to launch Claude Code
      command_variants = {
        continue = "--continue", -- Resume the most recent conversation
        resume = "--resume",     -- Display an interactive conversation picker
        verbose = "--verbose",   -- Enable verbose logging with full turn-by-turn output
      },
      keymaps = {
        toggle = {
          normal = "<C-c>",          -- Normal mode keymap for toggling Claude Code, false to disable
          terminal = "<C-c>",        -- Terminal mode keymap for toggling Claude Code, false to disable
          variants = {
            continue = "<leader>ac", -- Normal mode keymap for Claude Code with continue flag
            verbose = "<leader>av",  -- Normal mode keymap for Claude Code with verbose flag
            resume = "<leader>ar",   -- Normal mode keymap for Claude Code with resume flag
          },
        },
        window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
        scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
      }
    })
  end

  map('<leader>lc', '<cmd>CodeCompanionChat Toggle<cr>', 'Open [L]LM [C]hat', { 'n', 'v' })
  map('<leader>la', '<cmd>CodeCompanionActions<cr>', 'Open [L]LM [A]ctions', { 'n', 'v' })
  map('al', '<cmd>CodeCompanionChat Add<cr>', '[A]dd selection to [L]LM chat', 'v')
  map('<leader>ll', '<cmd>ClaudeCode<cr>', '[L]aunch C[L]aude Code', { 'n', 'v' })
  map('<leader>llc', '<cmd>ClaudeCodeContinue<cr>', '[L]aunch C[L]aude Code, [C]ontinue last convo', { 'n', 'v' })
  map('<leader>llr', '<cmd>ClaudeCodeResume<cr>', '[L]aunch C[L]aude Code, and [R]esume a convo from picker', { 'n', 'v' })
end
