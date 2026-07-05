{ self, inputs, lib, ... }:
{
  flake.overlays = {
    default = final: prev:
      let
        nvimPlugins = import ./nvimPlugins.nix { pkgs = prev; inherit inputs; };
        treesitter-grammars =
          import ./treesitter-grammars.nix { pkgs = prev; inherit inputs; };
        zsh-histdb-skim = prev.callPackage ./zsh-skim-histdb.nix { };
      in
      {
        # Language servers built from Maven coordinates via scala-cli-nix's
        # buildCoursierApp. `final.scala-cli-nix` is provided by
        # inputs.scala-cli-nix.overlays.default, composed alongside this overlay
        # wherever pkgs is built (machines/, modules/hm/, and perSystem below).
        metals = final.callPackage ./metals/derivation.nix { };
        smithy-lang-smithy-ls = final.callPackage ./smithy-ls/derivation.nix { };
        nvim-treesitter-textobjects =
          import ./nvim-treesitter-textobjects.nix {
            pkgs = prev;
          };
        vimPlugins = prev.vimPlugins // nvimPlugins;
        slack = prev.slack.overrideAttrs (_oldAttrs: {

          fixupPhase = ''
            sed -i -e 's/"WebRTCPipeWireCapturer"/"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

            rm $out/bin/slack
            makeWrapper $out/lib/slack/slack $out/bin/slack \
              --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
              --suffix PATH : ${lib.makeBinPath [ prev.xdg-utils ]} \
              --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer"
          '';
        });
        inherit zsh-histdb-skim;
      } // treesitter-grammars;
  };

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        inputs.scala-cli-nix.overlays.default
        self.overlays.default
      ];
    };
  };
}
