{
  fetchgit,
  stdenv,
  pkgs
}:
{
  name,
  url,
  hash ? null,
  rev ? null,
}:

stdenv.mkDerivation {
  name = name;
  nativeBuildInputs = [
    pkgs.git
    pkgs.janet
    pkgs.jpm
  ];
  src = fetchGit {
    url = url;
    hash = hash;
    rev = rev;
  };
  buildPhase = ''
    git init
    git add .
    git -c user.name='nix' -c user.email='nix@nix' commit -m "dummy commit"
  '';
  installPhase = ''
    mkdir -p $out/
    cp -r . $out/
  '';
}
