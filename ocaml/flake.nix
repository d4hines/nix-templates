{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    nixpkgs.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix-filter,
  }: let
    out = system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          # add overlays here
        ];
      };
      pkgsCross= pkgs.pkgsCross.muls64;
      inherit (pkgs) lib;
      native = pkgs.callPackage ./nix {
        ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_1;
        nix-filter = nix-filter.lib;
        doCheck = true;
      };
      static = pkgsCross.callPackage ./nix {
        ocamlPackages = pkgsCross.ocaml-ng.ocamlPackages_5_1;
        nix-filter = nix-filter.lib;
        doCheck = true;
      };
    in {
      devShell = pkgs.mkShell {
        inputsFrom = [native];
        buildInputs = with pkgs;
        with ocaml-ng.ocamlPackages_5_1; [
          ocaml-lsp
          ocamlformat
          odoc
          ocaml
          dune_3
          nixfmt
          utop
        ];
      };

      packages = {
        inherit native static;
      };
      defaultPackage = native;

      defaultApp = {
        type = "app";
        program = "${self.defaultPackage.${system}}/bin/service";
      };
    };
  in
    with flake-utils.lib; eachSystem defaultSystems out;
}
