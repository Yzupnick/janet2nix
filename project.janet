(declare-project
  :name "janet2nix"
  :description "A tool for building janet programs using the nix package manager" # some example metadata.

  # Optional urls to git repositories that contain required artifacts.
  :dependencies ["sh"])

(declare-executable
 :name "janet2nix"
 :entry "main.janet"
 :install true)
