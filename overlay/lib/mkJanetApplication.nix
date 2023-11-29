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
  buildInputs = map (p: p.package) withJanetPackages;
  buildPhase = ''
    set -o xtrace
    ${lib.strings.concatMapStrings (x: lib.strings.concatStrings ["jpm install file://" (toString x.package) "/\n" ]) withJanetPackages}
    jpm build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/* $out/bin
    wrapProgram $out/bin/${name} \
        --prefix PATH : ${lib.makeBinPath propagatedBuildInputs}
  '';
}
