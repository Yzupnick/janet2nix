{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      janet = forAllSystems (system: (pkgs.${system}.janet.overrideAttrs (old: {
                 src = pkgs.${system}.fetchFromGitHub {
                      owner = "janet-lang";
                      repo = "janet";
                      rev = "9593c930de587183cb47cc961a364631c1bf9650";
                      hash = "sha256-R9JYZvhCPW8xxAztflTPzcUej1pXHAQP7qqfmu8Nfy8=";
                  };
            })));
      jpm = forAllSystems (system: (pkgs.${system}.jpm.overrideAttrs (old: {
                 version = "1.2.0";
                 src = pkgs.${system}.fetchFromGitHub {
                      owner = "janet-lang";
                      repo = "jpm";
                      rev = "3d9d4c410fb64763620c3166c77f6340eae58ded";
                      hash = "sha256-V19Ty2Kzp/58SOGsO0cw2WERGwvgCYFCjWhh9cyxhLo=";
                  };
                  buildInputs = [ 
                    pkgs.${system}.makeWrapper 
                    pkgs.${system}.clang 
                    janet.${system}
                  ];
                  postInstall = "wrapProgram $out/bin/jpm --add-flags '-l --headerpath=${janet.${system}}/include --libpath=${janet.${system}}/lib --ldflags=-L${pkgs.${system}.glibc}/lib '";
            })));
      buildInputs = forAllSystems (system: [
        janet.${system}
        jpm.${system}
      ]);
    in
    {
      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShell {
          packages = buildInputs.${system};
        };
      });
    };
}
