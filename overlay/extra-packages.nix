final: prev: {
  janetPackages = {
    spork = prev.mkJanetPackage {
      name = "spork";
      url = "https://github.com/janet-lang/spork.git";
      rev = "d644da0fd05612a2d5a3c97277bf7b9bb96dcf6b";
      hash = "sha256-wvU4j2A+5kfRvb7HCIyQ8QH8qJV93Iz86grBOO0Rff8=";
    };
    sh = prev.mkJanetPackage {
      name = "sh";
      url = "https://github.com/andrewchambers/janet-sh.git";
      rev = "221bcc869bf998186d3c56a388c8313060bfd730";
      hash = "sha256-pFR5kIFpAV0ReYGE9QRc63fzD39TqwGI15RxdsqExl4=";
      withJanetPackages = [
        final.janetPackages.posix-spawn
      ];
    };
    posix-spawn = prev.mkJanetPackage {
      name = "posix-spawn";
      url = "https://github.com/andrewchambers/janet-posix-spawn.git";
      hash = "sha256-kC+HPtpnGOGGt6Msqk36znGMpZmy89DRzx9/TZdF8vg=";
      rev = "d73057161a8d10f27b20e69f0c1e2ceb3e145f97";
    };
  };
}
