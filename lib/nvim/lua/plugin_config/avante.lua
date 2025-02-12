require('render-markdown').setup({
  file_types = { "Avante" },
})

require('avante_lib').load()
require('avante').setup({
  provider = "claude",
  auto_suggestions_provider = "claude",
  suggestion = {
    debounce = 1000
  },
  --vendors = {
    --["local--llama3.1"] = {
      --__inherited_from = "openai",
      --api_key_name = "",
      --endpoint = "http://127.0.0.1:11434/v1",
      --model = "llama3.1:8b"
    --},
  --}
})
