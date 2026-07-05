{ scala-cli-nix }:

# AWS smithy-language-server (software.amazon.smithy:smithy-language-server).
# pname is `smithy_ls` so the wrapper lands at bin/smithy_ls — the path neovim
# invokes as `smithy_ls 0`. javaOptions mirror the JVM tuning the old
# nix-smithy-ls derivation used.
scala-cli-nix.buildCoursierApp {
  pname = "smithy_ls";
  version = "0.7.0";
  lockFile = ./scala.lock.json;
  mainClass = "software.amazon.smithy.lsp.Main";
  javaOptions = [ "-XX:+UseG1GC" "-XX:+UseStringDeduplication" "-Xss4m" "-Xms100m" ];
}
