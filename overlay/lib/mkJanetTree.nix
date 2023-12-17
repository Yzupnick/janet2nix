{
  stdenv,
  pkgs,
  lib,
  name,
  withJanetPackages
}:
stdenv.mkDerivation {
  name = name;
  nativeBuildInputs = [
    pkgs.git
    pkgs.makeWrapper
    pkgs.janet
    pkgs.jpm
  ];
  buildInputs = map (p: p.package) withJanetPackages ++ [pkgs.janet pkgs.jpm];
  unpackPhase = "true";
  buildPhase = ''
    set -o xtrace
    ${lib.strings.concatMapStrings (x: lib.strings.concatStrings ["jpm -l install file://" (toString x.package) "/\n" ]) withJanetPackages}

    echo '#!/bin/sh' > janet
    echo '${janet}/bin/janet "$@"' >> janet
    chmod +x janet

    echo '#!/bin/sh' > jpm
    echo '${jpm}/bin/jpm "$@"' >> jpm
    chmod +x jpm
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r jpm_tree $out/
    cp janet $out/bin
    cp jpm $out/bin

    wrapProgram $out/bin/janet \
        --prefix JANET_PATH : $out/jpm_tree/lib
    wrapProgram $out/bin/jpm --add-flags "--tree=$out/jpm_tree --headerpath=${pkgs.janet}/include --libpath=${pkgs.janet}/lib --ldflags=-L${pkgs.glibc}/lib ";
  '';
}
