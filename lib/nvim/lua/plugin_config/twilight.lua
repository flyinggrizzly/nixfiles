require('twilight').setup()

vim.keymap.set("n", "<leader>tt", "<cmd>Twilight<cr>",
  { silent = true, noremap = true }
)
