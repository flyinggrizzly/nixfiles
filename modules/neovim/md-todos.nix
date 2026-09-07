let
  bindKey =
    mode: key: action: opts:
    (
      {
        inherit mode key action;
        silent = true;
        noremap = true;
        unique = true;
      }
      // opts
    );

  luaFn = functionBody: ''
    function()
      ${functionBody}
    end
  '';

  bindLuaKey =
    mode: key: functionBody:
    opts@{ desc, ... }:
    (bindKey mode key (luaFn functionBody) (opts // { lua = true; }));

  todoKey = key: "<leader>d${key}";
in
{
  keymaps = [
    (bindLuaKey "n" (todoKey "d") /* lua */ ''
      if vim.bo.filetype ~= "markdown" then return end

      local line = vim.fn.getline('.')
      local new_line = line:gsub("^(%s*)%-%s%[(.)%]%s?(.*)", function(indent, status, text)
        local new_status = status == " " and "x" or " "
        return indent .. "- [" .. new_status .. "] " .. text
      end)

      vim.fn.setline('.', new_line)
    '' { desc = "Toggle Markdown TODO"; })

    (bindLuaKey "v" (todoKey "d") /* lua */ ''
      if vim.bo.filetype ~= "markdown" then return end

      local start_line = vim.fn.line('v')
      local end_line = vim.fn.line('.')

      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end

      for line_nr = start_line, end_line do
        local line = vim.fn.getline(line_nr)
        local new_line = line:gsub("^(%s*)%-%s%[(.)%]%s?(.*)", function(indent, status, text)
          local new_status = status == " " and "x" or " "
          return indent .. "- [" .. new_status .. "] " .. text
        end)
        vim.fn.setline(line_nr, new_line)
      end
    '' { desc = "Toggle Markdown TODOs"; })

    (bindLuaKey "n" (todoKey "x") /* lua */ ''
      if vim.bo.filetype ~= "markdown" then return end

      local line = vim.fn.getline('.')
      local new_line = line:gsub("^(%s*)%-%s%[.%]%s?(.*)", function(indent, text)
        return indent .. "- ~~" .. text .. "~~"
      end)

      vim.fn.setline('.', new_line)
    '' { desc = "Cancel Markdown TODO"; })

    (bindLuaKey "v" (todoKey "x") /* lua */ ''
      if vim.bo.filetype ~= "markdown" then return end

      local start_pos = vim.api.nvim_buf_get_mark(0, '<')
      local end_pos = vim.api.nvim_buf_get_mark(0, '>')
      local start_line = start_pos[1]
      local end_line = end_pos[1]

      for line_nr = start_line, end_line do
        local line = vim.fn.getline(line_nr)
        local new_line = line:gsub("^(%s*)%-%s%[.%]%s?(.*)", function(indent, text)
          return indent .. "- ~~" .. text .. "~~"
        end)
        vim.fn.setline(line_nr, new_line)
      end
    '' { desc = "Cancel Markdown TODOs"; })

    (bindLuaKey "n" (todoKey "X") /* lua */ ''
      if vim.bo.filetype ~= "markdown" then return end

      require('snacks').input({
        prompt = "Cancellation reason: ",
      }, function(reason)
        if not reason then return end

        local line = vim.fn.getline('.')
        local new_line = line:gsub("^(%s*)%-%s%[.%]%s?(.*)", function(indent, text)
          return indent .. "- ~~" .. text .. "~~ CANCELLED: " .. reason
        end)

        vim.fn.setline('.', new_line)
      end)
    '' { desc = "Cancel Markdown TODO (with reason)"; })

    (bindLuaKey "v" (todoKey "X") /* lua */ ''
      if vim.bo.filetype ~= "markdown" then return end

      require('snacks').input({
        prompt = "Cancellation reason: ",
      }, function(reason)
        if not reason then return end

        local start_pos = vim.api.nvim_buf_get_mark(0, '<')
        local end_pos = vim.api.nvim_buf_get_mark(0, '>')
        local start_line = start_pos[1]
        local end_line = end_pos[1]

        for line_nr = start_line, end_line do
          local line = vim.fn.getline(line_nr)
          local new_line = line:gsub("^(%s*)%-%s%[.%]%s?(.*)", function(indent, text)
            return indent .. "- ~~" .. text .. "~~ CANCELLED: " .. reason
          end)
          vim.fn.setline(line_nr, new_line)
        end
      end)
    '' { desc = "Cancel Markdown TODOs (with reason)"; })
  ];
}
