{
  pkgs,
  lib,
  nvf,
  config,
  ...
}:
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

  telescope-zotero-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-zotero-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "jmbuhr";
      repo = "telescope-zotero.nvim";
      rev = "376728bccfcbce95f59ef028d93bf0a33ee34bc2";
      sha256 = "00y2mqx1dml46g5niasdzgwm4p1hswjm50kgcpq1ppzgdm6imcnd";
    };
    doCheck = false; # the require checks on telescope fail; it will be available in the runtime
  };

  vim-heritage = pkgs.vimUtils.buildVimPlugin {
    name = "vim-heritage";
    src = pkgs.fetchFromGitHub {
      owner = "jessarcher";
      repo = "vim-heritage";
      rev = "cffa05c78c0991c998adc4504d761b3068547db6";
      sha256 = "sha256-Lebe5V1XFxn4kSZ+ImZ69Vst9Nbc0N7eA9IzOCijFS0=";
    };
  };

  mdTodos = import ./neovim/md-todos.nix;

  nvfConfig = {
    config.vim = {
      viAlias = true;
      vimAlias = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      theme.name = "dracula";
      theme.enable = true;

      lineNumberMode = "number";

      extraPackages = with pkgs; [
        fzf
        ripgrep
      ];

      lsp = {
        enable = true;
        formatOnSave = false;
        lspkind.enable = false;
        lightbulb.enable = false;
        lspsaga.enable = false;
        inlayHints.enable = true;
        otter-nvim = {
          enable = true;
          setupOpts.buffers.write_to_disk = true;
        };
        trouble.enable = true;
        nvim-docs-view.enable = false; # lags *horribly* whenever l is pressed
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        bash.enable = true;
        css.enable = true;
        lua.enable = true;
        markdown.enable = true;
        nix = {
          enable = true;
          lsp.servers = [
            "nixd"
            "nil"
          ];
        };
        ruby = {
          enable = true;
          lsp.servers = [
            "ruby-lsp" # add rails extension
          ];
        };
        typescript = {
          enable = true;
          extraDiagnostics.enable = false;
        };
      };

      autocomplete.blink-cmp = {
        enable = true;
        setupOpts = {
          sources = {
            default = [
              "lsp"
              "path"
              "buffer"
              "references"
            ];
          };
        };
        sourcePlugins = {
          references = {
            enable = true;
            package = pkgs.vimPlugins.cmp-pandoc-references;
            module = "cmp-pandoc-references.blink";
          };
        };
      };

      autopairs.nvim-autopairs.enable = true;

      comments.comment-nvim = {
        enable = true;
        mappings = {
          toggleCurrentLine = "<leader>cc";
          toggleCurrentBlock = "<leader>cb";
          toggleSelectedLine = "<leader>cc";
          toggleSelectedBlock = "<leader>cb";
        };
      };

      utility = {
        motion.leap = {
          enable = true;
          mappings = {
            leapForwardTo = "s";
            leapBackwardTo = "S";
          };
        };
        surround = {
          enable = true;
          useVendoredKeybindings = false;
        };
      };

      statusline.lualine = {
        enable = true;
      };

      git = (import ./neovim/git.nix).git;

      treesitter = {
        context.enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          ruby
          javascript
          typescript
          markdown
          markdown_inline
          toml
          yaml
        ];
      };

      telescope = {
        enable = true;
        mappings = {
          findFiles = "<C-p>";
        };
        extensions = [
          {
            name = "zotero";
            packages = with pkgs.vimPlugins; [
              telescope-zotero-nvim
              sqlite-lua
            ];
          }
        ];
      };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      keymaps = [
        (bindKey "n" ";" ":" { desc = "; as :"; })

        # jk/kj as escape/C-c
        (bindKey "i" "jk" "<esc>" { desc = "jk as <esc>"; })
        (bindKey "i" "kj" "<esc>" { desc = "kj as <esc>"; })
        (bindKey "c" "jk" "<C-c>" { desc = "jk as <C-c>"; })
        (bindKey "c" "kj" "<C-c>" { desc = "kj as <C-c>"; })

        # Quick save
        (bindKey "n" "<leader>f" ":update<CR>" { desc = "<leader>f quick save"; })

        # Tab switching
        (bindKey "n" "H" "gT" { desc = "H -> Tab Left"; })
        (bindKey "n" "L" "gt" { desc = "L -> Tab Right"; })

        # Exit terminal easily
        (bindKey "t" "<esc><esc>" "<C-\\><C-n>" { desc = "Exit Terminal"; })

        (bindKey "n" "<leader>fz" ":Telescope zotero<CR>" { desc = "Find Zotero reference"; })

        (bindKey "n" "<leader>tc<CR>" ":TSContext toggle" { desc = "Toggle TSContext"; })
      ]
      ++ mdTodos.keymaps;

      options = {
        # Decrease delay before which-key opens
        timeoutlen = 300;
        encoding = "utf-8";
        backspace = "2";
        ruler = true;
        incsearch = true;
        laststatus = 2;
        autowrite = true;

        # Be sane!
        shiftwidth = 2;
        tabstop = 2;
        shiftround = true;
        expandtab = true;

        # Show invisibles nicely
        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };

        # Always know where the end is
        textwidth = 120;
        colorcolumn = "+1";

        # Mouse mode on; useful for splits
        mouse = "a";

        # Mode is already in statusline
        showmode = false;

        # Split better
        splitright = true;
        splitbelow = true;

        breakindent = true;

        undofile = true;

        updatetime = 250;

        inccommand = "split";

        cursorline = true;
        scrolloff = 10;
      };

      startPlugins = with pkgs.vimPlugins; [
        vim-endwise
        vim-eunuch
        vim-heritage
        vim-slime
        vim-tmux-navigator
      ];

      lazy.plugins = with pkgs.vimPlugins; {
        ${quarto-nvim.pname} = {
          package = quarto-nvim;
          lazy = true;
          event = "BufEnter *.qmd";
          setupOpts = {
            lspFeatures = {
              enabled = true;
              chunks = "curly";
            };
            codeRunner = {
              enabled = true;
              default_method = "slime";
            };
          };
        };
        ${vim-ruby.pname} = {
          package = vim-ruby;
          lazy = true;
          ft = [ "ruby" ];
        };
      };
    };
  };

  configuredNeovim = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [ nvfConfig ];
  };

  cfg = config.modules.neovim;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.modules.neovim = {
    enable = mkEnableOption "Enable neovim config";
  };

  config = mkIf cfg.enable {
    home.packages = [ configuredNeovim.neovim ];
  };
}
