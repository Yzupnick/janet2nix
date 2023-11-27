final: prev: {
  mkJanetPackage = prev.callPackage ./lib/mkJanetPackage.nix;
  mkJanetApplication = prev.callPackage ./lib/mkJanetApplication.nix;
  #janetPackages = {
  #  spork = mkJanetPackage {
  #    url = "https://github.com/janet-lang/spork.git";
  #    hash = "sha256-wvU4j2A+5kfRvb7HCIyQ8QH8qJV93Iz86grBOO0Rff8=";
  #  };
  #  sh = mkJanetPackage {
  #    url = "https://github.com/andrewchambers/janet-sh.git";
  #    hash = "sha256-pFR5kIFpAV0ReYGE9QRc63fzD39TqwGI15RxdsqExl4=";
  #  };
  #  posix-spawn = mkJanetPackage {
  #    url = "https://github.com/andrewchambers/janet-posix-spawn.git";
  #    hash = "sha256-kC+HPtpnGOGGt6Msqk36znGMpZmy89DRzx9/TZdF8vg=";
  #  };
  #};
}
