-- Detect Neovim invocations spawned by an AI coding agent to edit a
-- prompt in $EDITOR. Matches the tempfile naming used by:
--   * `pi`     -> /tmp/pi-editor-<ts>.pi.md
--   * `claude` -> /tmp/claude-prompt-<uuid>.md

local patterns = {
  'pi%-editor%-.*%.pi%.md$',
  'claude%-prompt%-.*%.md$',
}

return function()
  for _, arg in ipairs(vim.v.argv) do
    for _, pat in ipairs(patterns) do
      if arg:match(pat) then
        return true
      end
    end
  end

  return false
end
