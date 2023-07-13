{ pkgs, inputs }:
let
  treesitterGrammarBuilder = pluginInput: pkgs.tree-sitter.buildGrammar rec {
    inherit (pluginInput) language;
    version = pluginInput.rev;
    src = pluginInput;
  };
  prefix = "p_treesitter";
  prefixLength = builtins.stringLength prefix;
  treesitterGrammars = pkgs.lib.attrsets.mapAttrs
    (k: v: v // {
      language = k;
    })
    (pkgs.lib.attrsets.filterAttrs (k: v: builtins.substring 0 prefixLength k == prefix) inputs);
in
pkgs.lib.attrsets.mapAttrs (k: v: (treesitterGrammarBuilder v)) treesitterGrammars
