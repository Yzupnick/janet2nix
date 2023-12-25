{
  lib,
  fetchgit,
  stdenv,
  pkgs,
  name,
  url,
  hash ? null,
  rev ? null,
  withJanetPackages ? [],
  # This is a temporary hack to get judge installed with the "tag" style of dependencies. 
  # TODO come up with an alternative method (probably bite the bullet and parse project.janet files and generate a nix file
  manualTag ? "v1"
}:
{
  package = stdenv.mkDerivation {
    name = name;
    nativeBuildInputs = [
      pkgs.git
      pkgs.janet
      pkgs.jpm
    ];
    src = fetchGit {
      url = url;
      rev = rev;
    };
    buildPhase = ''
      set -o xtrace
      cat project.janet
    ${lib.strings.concatMapStrings (x: lib.strings.concatStrings ["sed -i s#" (lib.strings.escapeShellArg x.url) "#file://" (lib.strings.escapeShellArg x.package) "#g project.janet\n" ]) withJanetPackages}
      git init
      git add .
      git -c user.name='nix' -c user.email='nix@nix' commit -m "dummy commit"
      git tag ${manualTag}
    '';
    installPhase = ''
      mkdir -p $out/
      cp -r . $out/
    '';
  };
  name = name;
  url = url;
}

