{ self, inputs, ... }:
{
  flake.overlays = {
    default = _final: prev:
      let
        nvimPlugins = import ./nvimPlugins.nix { pkgs = prev; inherit inputs; };
        treesitter-grammars =
          import ./treesitter-grammars.nix { pkgs = prev; inherit inputs; };
      in
      {
        google-chrome = import ./chrome.nix { pkgs = prev; };
        nvim-treesitter-textobjects =
          import ./nvim-treesitter-textobjects.nix { pkgs = prev; };
        vimPlugins = prev.vimPlugins // nvimPlugins;
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
