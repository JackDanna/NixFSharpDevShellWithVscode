
{
  description = "A FSharp Dev Shell";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs/c792c60b8a97daa7efe41a6e4954497ae410e0c1";
  };

  outputs = { self, nixpkgs, nixpkgs-old }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
          "vscode-with-extensions"
          "vscode"
          "vscode-extension-mhutchie-git-graph"
        ];
        allowUnfree = true;
      };
    };
    
    oldPkgs = import nixpkgs-old {
      inherit system;
    };
  in 
  {
    packages.${system} = {
      default = pkgs.writeShellScriptBin "run" ''
        nix develop -c -- code .
      '';
    };

    devShells.${system}.default = pkgs.mkShell rec {
      name = "FSharpDevShell";
      buildInputs = with pkgs; [
        bashInteractive
        dotnet-sdk_9
        vscode-fhs
      ];

      shellHook = ''
        export PS1+="${name}> "
        echo "Welcome to the FSharp Dev Shell!"
      '';
    };
  };

}

