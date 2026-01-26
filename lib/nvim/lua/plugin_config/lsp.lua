local snacks = require('snacks')

-- Get colors from Dracula theme
local dracula_colors = require('dracula').colors()

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = {
    spacing = 4, -- Add more space before the virtual text
    prefix = "●", -- Use a small dot as prefix
    format = function(diagnostic)
      -- Include the diagnostic source in the message if available
      if diagnostic.source then
        return string.format("%s (%s)", diagnostic.message, diagnostic.source)
      end
      return diagnostic.message
    end,
  },
  signs = true,             -- Show diagnostic signs in the sign column
  underline = true,         -- Underline the text with issues
  update_in_insert = false, -- Don't update diagnostics in insert mode
  severity_sort = true,     -- Sort diagnostics by severity
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    pad_top = 1,     -- Add padding at the top
    pad_bottom = 1,  -- Add padding at the bottom
    max_width = 80,  -- Maximum width of the float window
    max_height = 20, -- Maximum height of the float window
  },
})

-- Set up diagnostic highlight groups with Dracula colors
vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = dracula_colors.red, bg = dracula_colors.black })
vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = dracula_colors.orange, bg = dracula_colors.black })
vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = dracula_colors.cyan, bg = dracula_colors.black })
vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = dracula_colors.green, bg = dracula_colors.black })
vim.api.nvim_set_hl(0, "DiagnosticFloatingOk", { fg = dracula_colors.green, bg = dracula_colors.black })

-- Set up inline diagnostics with a subtle background
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = dracula_colors.red, bg = "#382838" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = dracula_colors.orange, bg = "#38352f" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = dracula_colors.cyan, bg = "#2e3a40" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = dracula_colors.green, bg = "#2d3b2d" })

-- Add faint border to underline diagnostics
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = dracula_colors.red, underline = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = dracula_colors.orange, underline = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = dracula_colors.cyan, underline = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = dracula_colors.green, underline = true })

-- Make floating window borders match the Dracula theme
vim.api.nvim_set_hl(0, "FloatBorder", { fg = dracula_colors.comment, bg = dracula_colors.black })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = dracula_colors.black })

-- Style hover documentation windows
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = dracula_colors.green, bold = true })
vim.api.nvim_set_hl(0, "LspInfoBorder", { fg = dracula_colors.comment, bg = dracula_colors.black })
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = dracula_colors.comment, italic = true })

-- Style documentation highlight groups
vim.api.nvim_set_hl(0, "markdownH1", { fg = dracula_colors.purple, bold = true })
vim.api.nvim_set_hl(0, "markdownH2", { fg = dracula_colors.purple, bold = true })
vim.api.nvim_set_hl(0, "markdownH3", { fg = dracula_colors.purple, bold = true })
vim.api.nvim_set_hl(0, "markdownCode", { fg = dracula_colors.green, bg = dracula_colors.selection })
vim.api.nvim_set_hl(0, "markdownCodeBlock", { fg = dracula_colors.green, bg = dracula_colors.selection })
vim.api.nvim_set_hl(0, "markdownBlockquote", { fg = dracula_colors.comment, italic = true })

-- Create base float config for reuse
local float_config = {
  border = "rounded",
  max_height = 20,
  pad_top = 1,
  pad_bottom = 1,
  padding = { left = 2, right = 2 },
  source = "always",
}

-- Function to get a configured float config with proper width
local function get_float_config(opts)
  -- Default options
  opts = opts or {}
  local width_percent = opts.width_percent or 0.75
  local min_width_percent = opts.min_width_percent
  local title = opts.title
  local focus = opts.focusable

  -- Create config based on float_config
  local config = vim.deepcopy(float_config)

  -- Calculate widths
  local win_width = vim.api.nvim_win_get_width(0)
  config.max_width = math.floor(win_width * width_percent)

  if min_width_percent then
    config.min_width = math.floor(win_width * min_width_percent)
  end

  -- Add optional properties
  if title then
    config.title = title
    config.title_pos = "center"
  end

  if focus then
    config.focusable = true
    config.style = "minimal"
  end

  return config
end

-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', snacks.picker.lsp_definitions, '[G]oto [D]efinition')

    -- Find references for the word under your cursor.
    map('gr', snacks.picker.lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gI', snacks.picker.lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>D', snacks.picker.lsp_type_definitions, 'Type [D]efinition')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>ds', snacks.picker.lsp_symbols, '[D]ocument [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>ws', snacks.picker.lsp_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[L]SP toggle Inlay [H]ints')
    end

    -- Add hover information keymap with custom styling
    map('K', function()
      local hover_config = get_float_config({
        width_percent = 0.75,
        min_width_percent = 0.5,
        title = "Documentation",
        focusable = true
      })
      vim.lsp.buf.hover(hover_config)
    end, 'Hover Documentation')

    -- Add keymap for diagnostics with custom styling
    map('<leader>e', function()
      local diag_config = get_float_config({ title = "Diagnostics" })
      vim.diagnostic.open_float(diag_config)
    end, 'Show [E]rror Diagnostics')

    -- Navigate between all diagnostics (any severity)
    map('[i', function()
      local diag_config = get_float_config({ title = "Diagnostic" })
      vim.diagnostic.goto_prev({ float = diag_config })
    end, 'Go to previous diagnostic (any)')
    map(']i', function()
      local diag_config = get_float_config({ title = "Diagnostic" })
      vim.diagnostic.goto_next({ float = diag_config })
    end, 'Go to next diagnostic (any)')

    -- Navigate between errors only
    map('[d', function()
      local diag_config = get_float_config({ title = "Error" })
      vim.diagnostic.goto_prev({
        severity = vim.diagnostic.severity.ERROR,
        float = diag_config
      })
    end, 'Go to previous error')

    map(']d', function()
      local diag_config = get_float_config({ title = "Error" })
      vim.diagnostic.goto_next({
        severity = vim.diagnostic.severity.ERROR,
        float = diag_config
      })
    end, 'Go to next error')

    -- Navigate between warnings only
    map('[w', function()
      local diag_config = get_float_config({ title = "Warning" })
      vim.diagnostic.goto_prev({
        severity = vim.diagnostic.severity.WARN,
        float = diag_config
      })
    end, 'Go to previous warning')
    map(']w', function()
      local diag_config = get_float_config({ title = "Warning" })
      vim.diagnostic.goto_next({
        severity = vim.diagnostic.severity.WARN,
        float = diag_config
      })
    end, 'Go to next warning')
  end,
})

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

local lsp_config = vim.lsp.config
local lsp_enable = vim.lsp.enable

local function sorbet_root_dir(fname)
  return require('lspconfig').util.root_pattern('Gemfile', 'sorbet')(fname)
end

local servers = {
  nixd = {},
  graphql = {},
  ts_ls = {},

  lua_ls = {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        return
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
            -- Depending on the usage, you might want to add additional paths here.
            -- "${3rd}/luv/library"
            -- "${3rd}/busted/library",
          }
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
          -- library = vim.api.nvim_get_runtime_file("", true)
        }
      })
    end,
    settings = {
      Lua = {}
    },
  },

  ruby_lsp = {
    cmd = { 'ruby-lsp' },
    priority = 1,
  },

  sorbet = {
    cmd = { 'srb', 'tc', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = sorbet_root_dir,
    priority = 1000000,
  },

}

local function lsp_binary_exists(config)
  local cmd = (config or {}).cmd

  -- cmd must alwayus be an array table of at least one element
  if not (type(cmd) == "table" and #cmd >= 1) then
    return false
  end

  return vim.fn.executable(cmd[1]) == 1
end

for server_name, config in pairs(servers) do
  lsp_config(server_name, config)
  local server = lsp_config[server_name]

  -- Not every server will always be available, especially for more Ruby and JS-like projecst where the server will be
  -- part of the application package.
  --
  -- Only enable servers if we have an executable to avoid the annoying red popup
  if lsp_binary_exists(server) then
    config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
    lsp_enable(server_name)
  end
end
