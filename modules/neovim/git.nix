let
  bindToLeader = keys: "<leader>${keys}";
  bindHunkKey = key: bindToLeader "h${key}";
  bindGitKey = key: bindToLeader "g${key}";
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
        blameLine = bindGitKey "b";
        toggleBlame = bindGitKey "B";
        nextHunk = "]h";
        previousHunk = "[h";
      };
    };
  };
}
