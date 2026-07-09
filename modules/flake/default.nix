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
        # MCP-server binary that Claude Code launches to bridge into a running
        # Neovim. It talks to the socket that the vimPlugins.p_nvim-mcp plugin
        # opens via serverstart(). Built from the same pinned source as the
        # plugin (inputs.p_nvim-mcp). Upstream builds it with a fenix toolchain;
        # we build against our own nixpkgs rust (>= the crate's 1.88 MSRV) to
        # avoid pulling fenix in as a flake input. build.rs falls back to
        # "unknown" without git, but we stamp the pinned rev for good measure.
        nvim-mcp = prev.rustPlatform.buildRustPackage {
          pname = "nvim-mcp";
          version = inputs.p_nvim-mcp.shortRev or "unstable";
          src = inputs.p_nvim-mcp;
          cargoLock.lockFile = "${inputs.p_nvim-mcp}/Cargo.lock";
          env = {
            GIT_COMMIT_SHA = inputs.p_nvim-mcp.rev or "unknown";
            GIT_DIRTY = "false";
          };
          # Integration tests spawn a real Neovim; not available in the sandbox.
          doCheck = false;
          meta.mainProgram = "nvim-mcp";
        };
        nvim-treesitter-textobjects =
          import ./nvim-treesitter-textobjects.nix {
            pkgs = prev;
          };
        vimPlugins = prev.vimPlugins // nvimPlugins;
        # Drop the ~645 MiB mbrola voice database from speech-dispatcher's
        # closure. speechd only pulls mbrola when its espeak (espeak-ng) is
        # built with mbrolaSupport; espeak-ng's built-in voices remain, so
        # Orca / TTS still works.
        speechd = prev.speechd.override {
          espeak = prev.espeak.override { mbrolaSupport = false; };
        };
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
