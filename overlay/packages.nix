final: prev: {
  janet = prev.janet.overrideAttrs (old: {
             src = prev.fetchFromGitHub {
                  owner = "janet-lang";
                  repo = "janet";
                  rev = "9593c930de587183cb47cc961a364631c1bf9650";
                  hash = "sha256-R9JYZvhCPW8xxAztflTPzcUej1pXHAQP7qqfmu8Nfy8=";
              };
        });
  jpm = prev.jpm.overrideAttrs (old: {
                 version = "1.2.0";
                 src = prev.fetchFromGitHub {
                      owner = "janet-lang";
                      repo = "jpm";
                      rev = "3d9d4c410fb64763620c3166c77f6340eae58ded";
                      hash = "sha256-V19Ty2Kzp/58SOGsO0cw2WERGwvgCYFCjWhh9cyxhLo=";
                  };
                  buildInputs = [ 
                    prev.makeWrapper 
                    prev.clang 
                    final.janet
                  ];
                  postInstall = "wrapProgram $out/bin/jpm --add-flags '--headerpath=${final.janet}/include --libpath=${final.janet}/lib --ldflags=-L${prev.glibc}/lib '";
                });
}
