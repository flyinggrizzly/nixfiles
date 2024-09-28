require('twilight').setup()

vim.keymap.set("n", "<leader>z", "<cmd>Twilight<cr>",
  { silent = true, noremap = true }
)
