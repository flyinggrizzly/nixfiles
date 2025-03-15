require('render-markdown').setup({
  file_types = { "Avante" },
})

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

require('avante_lib').load()
if not is_git_subprocess() then
  require('avante').setup({
    provider = "claude",
    auto_suggestions_provider = "claude",
    suggestion = {
      debounce = 1000
    },
    claude = {
      api_key_name = "cmd:op read op://Personal/anthropic-api-key/password"
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
end
