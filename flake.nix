{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      package_overlay = import ./overlay/packages.nix;
      pkgs = import nixpkgs { inherit system; overlays = [ 
        package_overlay
      ]; };
      mkJanetApplication = pkgs.callPackage ./overlay/lib/mkJanetApplication.nix;
      janet2nix = mkJanetApplication {
          name = "janet2nix";
          src = ./.;
      };
    in {
      packages = {
        default = janet2nix;
      };

      devshell = pkgs.mkShell {
        packages = [
          pkgs.janet
          pkgs.jpm
        ];
      };
   });
}
