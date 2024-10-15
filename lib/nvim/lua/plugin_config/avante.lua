
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
  local openai = require("avante.providers.openai")
  require('render-markdown').setup({ file_types = { "Avante" } })
  require('avante_lib').load()

  require("avante").setup({
    -- @type AvanteProvider
    provider = "shopify-ai",
    auto_suggestions_provider = "shopify-ai",
    vendors = {
      ["shopify-ai"] = {
        endpoint = "https://proxy.shopify.ai/v1",
        model = "anthropic:claude-3-7-sonnet-20250219",
        api_key_name = {"oai-proxy-key", "cat"},
        parse_curl_args = openai.parse_curl_args,
        parse_response_data = openai.parse_response,
      },
    },
  })
end
