{
  tmuxinator-nix,
  ...
}:
let
  defaultTmuxWindow = name: root: {
    inherit name root;
    layout = tmuxinator-nix.lib.constants.layouts.wideRightMainVertical;
    panes = [
      "zsh"
      "vi"
    ];
  };
in
{
  config.programs = {
    tmux = {
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      baseIndex = 1;
      historyLimit = 10000;
      clock24 = true;
      mouse = true;
      shell = "$SHELL";
      terminal = "screen-256color";
      extraConfig = ''
        set -g prefix2 C-s

        # Don't suspend tmux
        unbind-key C-z

        # Vim-like pane navigation
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
        bind-key -r C-h select-window -t :-
        bind-key -r C-l select-window -t :+

        # Smart pane switching with Vim integration
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
        # Version-specific handling for 
        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

        # Copy mode navigation
        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l

        set -g renumber-windows on

        # Status bar configuration
        set -g status-position bottom
        set -g status-style bg=colour234,fg=colour137
        set -g status-left ""
        set -g status-right '#[fg=colour159,bg=colour241,bold] %Y-%d-%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
        set -g status-right-length 50
        set -g status-left-length 20
        set -g status-justify left
        set -g status-interval 2

        # Window status formatting
        setw -g window-status-current-style fg=colour81,bg=colour238,bold
        setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
        setw -g window-status-style fg=colour138,bg=colour235,none
        setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
        set -g window-status-bell-style fg=colour255,bg=colour1,bold

        # Split pane commands
        bind \\ split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # Pane styling
        set -g pane-border-style bg=colour235,fg=colour238
        set -g pane-active-border-style bg=colour236,fg=colour51
        set -g window-style 'fg=colour242,bg=colour236'
        set -g window-active-style 'fg=colour250,bg=black'

        # Message styling
        set -g message-style fg=colour232,bg=colour166,bold
        set -g message-command-style fg=blue,bg=black

        # Window mode styling
        setw -g mode-style fg=colour196,bg=colour238,bold
        setw -g clock-mode-colour colour135

        # Quiet operation
        set-option -g visual-activity off
        set-option -g visual-bell off
        set-option -g visual-silence off
        set-window-option -g monitor-activity off
        set-option -g bell-action none

        # Undercurls for tokyonight vim theme
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      '';
    };

    tmuxinator = {
      enable = true;
      rubyPackage = null; # use the package defined above
      projects = {
        s = {
          root = "~/";
          windows = [
            (defaultTmuxWindow "main" "~/")
            (defaultTmuxWindow "blog" "~/flying-grizzly")
            (defaultTmuxWindow "plamotrack" "~/src/plamotrack")
            { name = "tty"; }
            (defaultTmuxWindow "nixfiles" "~/nixfiles")
            (defaultTmuxWindow "claude-nix" "~/src/claude-nix")
            (defaultTmuxWindow "tmuxinator-nix" "~/src/tmuxinator-nix")
          ];
        };
      };
    };
  };
}
