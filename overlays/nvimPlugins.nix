{ pkgs, inputs }:
let
  nvimPluginBuilder = pluginInput: pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    pname = pluginInput.name;
    version = pluginInput.rev;
    src = pluginInput;
  };
  nvimPluginInputs = pkgs.lib.attrsets.mapAttrs (k: v: v // { name = k; }) (pkgs.lib.attrsets.filterAttrs (k: v: builtins.substring 0 6 k == "p_nvim") inputs);
in
pkgs.lib.attrsets.mapAttrs (k: v: (nvimPluginBuilder v)) nvimPluginInputs
