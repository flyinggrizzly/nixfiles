return function ()
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
