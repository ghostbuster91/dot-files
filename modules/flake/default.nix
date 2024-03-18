{ self, inputs, lib, ... }:
{
  flake.overlays = {
    default = _final: prev:
      let
        nvimPlugins = import ./nvimPlugins.nix { pkgs = prev; inherit inputs; };
        treesitter-grammars =
          import ./treesitter-grammars.nix { pkgs = prev; inherit inputs; };
      in
      {
        nvim-treesitter-textobjects =
          import ./nvim-treesitter-textobjects.nix { pkgs = prev; };
        vimPlugins = prev.vimPlugins // nvimPlugins;
        slack = prev.slack.overrideAttrs (_oldAttrs: {

          fixupPhase = ''
            sed -i -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

            rm $out/bin/slack
            makeWrapper $out/lib/slack/slack $out/bin/slack \
              --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
              --suffix PATH : ${lib.makeBinPath [ prev.xdg-utils ]} \
              --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer"
          '';
        });
      } // treesitter-grammars;
  };

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        self.overlays.default
      ];
    };
  };
}
