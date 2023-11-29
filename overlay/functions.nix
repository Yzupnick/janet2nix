final: prev: {
  mkJanetPackage = prev.callPackage ./lib/mkJanetPackage.nix;
  mkJanetApplication = prev.callPackage ./lib/mkJanetApplication.nix;
}
