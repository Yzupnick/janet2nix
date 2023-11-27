{
  lib,
  stdenv,
  pkgs,
  name,
  src,
  propagatedBuildInputs ? [],
  withJanetPackages ? []
}:
stdenv.mkDerivation {
  name = name;
  src = src;
  nativeBuildInputs = [
    pkgs.git
    pkgs.makeWrapper
    pkgs.janet
    pkgs.jpm
  ];
  buildPhase = ''
    for p in $withJanetPackages; do
        jpm install file://$p/
    done
    jpm build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/* $out/bin
    wrapProgram $out/bin/${name} \
        --prefix PATH : ${lib.makeBinPath propagatedBuildInputs}
  '';
}
