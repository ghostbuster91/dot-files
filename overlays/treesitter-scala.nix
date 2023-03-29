{ pkgs }:
pkgs.fetchFromGitHub {
  owner = "tree-sitter";
  repo = "tree-sitter-scala";
  rev = "7d348f51e442563f4ab2b6c3e136dac658649f93";
  hash = "sha256-jIbVw4jKMJYbKeeai3u7J+xKRfo2YNoL3ZcW1NLc9fg=";
}

