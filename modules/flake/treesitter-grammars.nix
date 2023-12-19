{ pkgs, inputs }:
let
  inherit (pkgs) lib;
  treesitterGrammarBuilder = pluginInput: pkgs.tree-sitter.buildGrammar rec {
    inherit (pluginInput) language location;
    version = pluginInput.rev;
    src = pluginInput;
  };
  prefix = "p_treesitter-";
  treesitterGrammars = pkgs.lib.attrsets.mapAttrs
    (k: v: v // rec {
      language = lib.strings.removePrefix prefix k;
      location = if language == "xml" then "tree-sitter-xml" else null;
    })
    (pkgs.lib.attrsets.filterAttrs (k: _v: lib.strings.hasPrefix prefix k) inputs);
in
pkgs.lib.attrsets.mapAttrs (_k: v: (treesitterGrammarBuilder v)) treesitterGrammars
