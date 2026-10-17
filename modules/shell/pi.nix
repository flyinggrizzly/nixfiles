{ ... }:
{
  config.programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "everforest-dark-medium";
      defaultProvider = "pi-sub-anthropic";
      defaultModel = "claude-sonnet-5-5";
      packages = [
        "npm:@jopqior/pi-subagents"
        "npm:@termdraw/pi"

        "npm:pi-everforest"
        "npm:pi-lens"
        "npm:pi-mcp-adapter"
        "npm:pi-sub-anthropic"
        "npm:pi-verdict"
        "npm:pi-vim"
      ];
    };
  };
}
