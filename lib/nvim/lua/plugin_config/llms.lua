local function is_shopify()
  if os.getenv('SHOPIFY_ENV') then
    return true
  else
    return false
  end
end

local function chat_adapter()
  if is_shopify() then
    return "shopify_sonnet"
  else
    return "sonnet_37"
  end
end

local function inline_adapter()
  if is_shopify() then
    return "shopify_sonnet"
  else
    return "copilot"
  end
end

local openai = require("codecompanion.adapters.openai")
local function shopify_adapter(base_name, url, model)
  local base = require("codecompanion.adapters." .. base_name)

  return require("codecompanion.adapters").extend(base, {
    url = url,
    env = {
      api_key = "cmd:oai-proxy-key cat",
    },
    handlers = openai.handlers,
    headers = openai.headers,
    parameters = {
      model = "${model}",
    },
    schema = {
      model = {
        default = model or base.schema.model.default,
      },
    },
  })
end

if not require('helpers').is_git_subprocess() then
  require('copilot').setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
  })

  require("plugin_config/llms/codecompanion_fidget"):init()

  local codecompanion = require('codecompanion')
  codecompanion.setup({
    strategies = {
      chat = {
        adapter = chat_adapter(),
        send = {
          modes = { n = "<C-s>", i = "<C-s>" },
        },
      },

      inline = {
        adapter = inline_adapter(),
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

      shopify_sonnet = shopify_adapter(
        "anthropic",
        "https://proxy.shopify.ai/v1/chat/completions",
        "anthropic:claude-3-7-sonnet"
      ),

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
