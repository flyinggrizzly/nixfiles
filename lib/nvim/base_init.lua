require 'options'
require 'keymaps'
require 'functions'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Bootstrap...
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  -- TODO: this is brittle, we should do something better. It's just hard with the ~/nixfiles dir being an
  -- implementation detail that isn't to be leaked from the perspect of home-manager, but not doing something here means
  -- we have a read-only neovim plugin config.
  lockfile = "~/nixfiles/neovim-lazy-lock.json",
})
