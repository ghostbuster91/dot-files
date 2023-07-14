{ pkgs, inputs }:
let
  inherit (pkgs) lib;
  treesitterGrammarBuilder = pluginInput: pkgs.tree-sitter.buildGrammar rec {
    inherit (pluginInput) language;
    version = pluginInput.rev;
    src = pluginInput;
  };
  prefix = "p_treesitter-";
  treesitterGrammars = pkgs.lib.attrsets.mapAttrs
    (k: v: v // {
      language = lib.strings.removePrefix prefix k;
    })
    (pkgs.lib.attrsets.filterAttrs (k: v: lib.strings.hasPrefix prefix k) inputs);
in
pkgs.lib.attrsets.mapAttrs (k: v: (treesitterGrammarBuilder v)) treesitterGrammars
