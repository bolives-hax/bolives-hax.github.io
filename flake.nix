{
  inputs = {
    bl0v3_static = {
      url = "github:bolives-hax/bl0v3.com-static";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = {self,bl0v3_static,flake-utils,nixpkgs}: flake-utils.lib.eachDefaultSystem(system: 
  let
    pkgs = import nixpkgs {inherit system;};
  in {
    packages.default = pkgs.writeShellScriptBin "update-site" ''
      SITE_PATH="${bl0v3_static.packages.${system}.github}"
      echo $SITE_PATH
      if [ -z "$1" ]; then
        echo usage: nix run .# \"git commit message\"
      else 
      cp -Lr --no-preserve=mode $SITE_PATH site
      cp -r .git flake.nix README.md site/
      cd site
      git add *
      git commit -m \"$1\"
      git push
      cd ../
      rm -rf site
      fi
    '';
  });
}
