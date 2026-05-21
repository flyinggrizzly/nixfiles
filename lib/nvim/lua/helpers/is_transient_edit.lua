-- Short-lived editor invocations where we skip heavy setup
-- (treesitter grammar compiles, LLM plugins, etc.).

local is_git_subprocess = require('helpers/is_git_subprocess')
local is_agent_prompt = require('helpers/is_agent_prompt')

return function()
  return is_git_subprocess() or is_agent_prompt()
end
