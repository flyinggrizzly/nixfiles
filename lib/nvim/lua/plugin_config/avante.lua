local openai = require("avante.providers.openai")

require('render-markdown').setup({
  file_types = { "Avante" },
})

require('avante_lib').load()
--require("avante").setup()
require("avante").setup({
  -- @type AvanteProvider
  provider = "shopify-ai",
  vendors = {
    ["shopify-ai"] = {
      endpoint = "https://proxy.shopify.ai/v3/v1",
      model = "anthropic:claude-3-5-sonnet",
      api_key_name = {"oai-proxy-key", "cat"},
      parse_curl_args = openai.parse_curl_args,
      parse_response_data = openai.parse_response,
    },
  },
})
