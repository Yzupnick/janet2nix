# janet2nix

janet2nix is a set of tools for writing and packaging janet applications with and for the nix package manager.

## How to use
See the [example repo](https://github.com/Yzupnick/example-janet2nix) for how to use in a flake.

janet2nix provides 4 tools.

### 1. mkJanetApplication
`mkJanetApplication` accepts an attrset with 3 properties;

1. `name` - this should be the name of your final executable. The function currently looks for this name to copy to the `bin/` folder.
2.  `src` - this gets passed to mkDerivation, all the same rules apply.  
3. `withJanetPackages` - this is a list of packages built using `mkJanetPackage`

`mkJanetApplication` will run `jpm install` for each dependency listed in `withJanetPackages`. 
It currently ignores any dependency listed 

```nix
pkgs.mkJanetApplication {
    name = "example";
    src = ./.; # local
    withJanetPackages = [
      # Add any janet dependencies. These are made using mkJanetPackage
      pkgs.janetPackages.spork
    ];
};
```

### 2. mkJanetPackage
`mkJanetPackage` downloads a jpm package from a public git repository and sets it up to be installed by `jpm install`. 

```nix
pkgs.mkJanetPackage {
      name = "sh";
      url = "https://github.com/andrewchambers/janet-sh.git";
      rev = "221bcc869bf998186d3c56a388c8313060bfd730";
      hash = "sha256-pFR5kIFpAV0ReYGE9QRc63fzD39TqwGI15RxdsqExl4=";
      withJanetPackages = [
        pkgs.janetPackages.posix-spawn
      ];
    };
```

### 3. mkJanetTree
`mkJanetTree` accepts an attrset with 2 properties;

1. `name` - this should be the name of your final executable. The function currently looks for this name to copy to the `bin/` folder.
3. `withJanetPackages` - this is a list of packages built using `mkJanetPackage`

`mkJanetTree` will build a derivation that provides a janet and jpm binary with there path set to find any provided packages. `jpm install` is run for every package.

```nix
pkgs.mkJanetTree {
    name = "example";
    withJanetPackages = [
      # Add any janet dependencies. These are made using mkJanetPackage
      pkgs.janetPackages.spork
    ];
};
```

### 4. janetPackages
Some jpm packages are pre-packaged here. 

Current list includes:

1. spork
2. sh
3. posix-spawn


## TODO
- [ ] Read `project.janet` file to generate dependencies instead of explicitly creating them.
- [ ] Read `project.janet` file determine what executable to copy to `bin/`.
- [ ] Optionally copy library exes to `$out/bin/`.
- [ ] Make all the "blessed" janet packages available in `pkgs.janetPackages`.
- [ ] Switch mkJanetPackage to take a `src` attribute instead of assuming a git repo. 

