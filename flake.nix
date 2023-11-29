{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let 
      package_overlay = import ./overlay/packages.nix;
      function_overlay = import ./overlay/functions.nix;
      extra_packages = import ./overlay/extra-packages.nix;
      pkgs = import nixpkgs { inherit system; overlays = [ 
        package_overlay
        function_overlay
        extra_packages
      ]; };
      janet2nix = pkgs.mkJanetApplication {
          name = "janet2nix";
          src = ./.;
          withJanetPackages = [
            pkgs.janetPackages.spork
            pkgs.janetPackages.posix-spawn
            pkgs.janetPackages.sh
          ];
      };
    in {
      packages = {
        janetPackages = pkgs.janetPackages;
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
