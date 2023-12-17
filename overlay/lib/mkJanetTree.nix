{
  stdenv,
  pkgs,
  lib,
  name,
  withJanetPackages
}:
let 
  janet = pkgs.janet.overrideAttrs (old: {
             src = pkgs.fetchFromGitHub {
                  owner = "janet-lang";
                  repo = "janet";
                  rev = "9593c930de587183cb47cc961a364631c1bf9650";
                  hash = "sha256-R9JYZvhCPW8xxAztflTPzcUej1pXHAQP7qqfmu8Nfy8=";
              };
        });
  jpm = pkgs.jpm.overrideAttrs (old: {
                 version = "1.2.0";
                 src = pkgs.fetchFromGitHub {
                      owner = "janet-lang";
                      repo = "jpm";
                      rev = "3d9d4c410fb64763620c3166c77f6340eae58ded";
                      hash = "sha256-V19Ty2Kzp/58SOGsO0cw2WERGwvgCYFCjWhh9cyxhLo=";
                  };
                  buildInputs = [ 
                    pkgs.makeWrapper 
                    pkgs.clang 
                    janet
                  ];
                });
in

stdenv.mkDerivation {
  name = name;
  nativeBuildInputs = [
    pkgs.git
    pkgs.makeWrapper
    janet
    jpm
  ];
  buildInputs = map (p: p.package) withJanetPackages ++ [janet jpm];
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
    wrapProgram $out/bin/jpm --add-flags "--tree=$out/jpm_tree --headerpath=${janet}/include --libpath=${janet}/lib --ldflags=-L${pkgs.glibc}/lib ";
  '';
}
