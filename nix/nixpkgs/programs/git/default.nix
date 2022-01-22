{ pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "ghostbuster91";
    userEmail = "ghostbuster91@users.noreply.github.com";
    extraConfig = {
      merge = { conflictStyle = "diff3"; };
      core = {
        editor = "nvim";
        pager = "diff-so-fancy | less -FXRi";
      };
      color = { ui = true; };
      push = { default = "simple"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
      alias = { gone = "!bash ~/bin/git-gone.sh"; };
    };
    includes = [
      {
        condition = "gitdir:~/dev/";
        contents = {
          user = {
            name = "Kasper Kondzielski";
            email = "kasper.kondzielski@iohk.io";
            signingKey = "5A22DAA4D02BA94A";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
  };
}
