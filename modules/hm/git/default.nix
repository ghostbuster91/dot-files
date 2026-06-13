{ pkgs, ... }: {

  programs.git = {
    enable = true;
    settings = {
      merge = { conflictStyle = "diff3"; };
      core = {
        editor = "nvim";
        pager = "${pkgs.diff-so-fancy}/bin/diff-so-fancy | less -FXRi";
      };
      color = { ui = true; };
      push = { default = "simple"; autoSetupRemote = true; };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
      alias = { gone = "!${pkgs.git-gone}/bin/git-gone"; };
      submodule = { recurse = true; };
      user = {
        name = "ghostbuster91";
        email = "ghostbuster91@users.noreply.github.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFFeU4GXH+Ae00DipGGJN7uSqPJxWFmgRo9B+xjV3mK4";
      };
      gpg.format = "ssh";
      gpg.ssh = { allowedSignersFile = "~/.ssh/allowed_signers"; };
      commit.gpgsign = true;
    };
    ignores = [
      ".bloop"
      ".metals"
      "metals.sbt"
      ".claude/settings.local.json"
    ];
  };

  home.file."./.ssh/allowed_signers".text = ''
    ghostbuster91@users.noreply.github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFFeU4GXH+Ae00DipGGJN7uSqPJxWFmgRo9B+xjV3mK4
  '';
}
