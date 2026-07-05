{ scala-cli-nix }:

scala-cli-nix.buildCoursierApp {
  pname = "metals";
  version = "1.6.7";
  lockFile = ./scala.lock.json;
}
