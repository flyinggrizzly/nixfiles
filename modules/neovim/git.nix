let
  bindToLeader = keys: "<leader>${keys}";
  bindHunkKey = key: bindToLeader "h${key}";
  bindBlameKey = key: bindToLeader "b${key}";
in
{
  git = {
    enable = true;
    octo-nvim.enable = false;
    neogit.enable = false;
    gitsigns = {
      setupOpts = {
      };
      mappings = {
        stageHunk = bindHunkKey "s";
        resetHunk = bindHunkKey "r";
        undoStageHunk = bindHunkKey "u";
        stageBuffer = bindHunkKey "S";
        resetBuffer = bindHunkKey "R";
        previewHunk = bindHunkKey "p";
        blameLine = bindBlameKey "l";
        toggleBlame = bindToLeader "b";
        nextHunk = "]h";
        previousHunk = "[h";
      };
    };
  };
}
