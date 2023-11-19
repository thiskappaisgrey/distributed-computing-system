{
  inputs = { nixpkgs.url = "nixpkgs/nixos-unstable"; };

  description = "A flake full of scripts for experimenting";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      producer-script = builtins.readFile ./simple-pipeline/producer.py;
      producer = pkgs.writers.writePython3Bin "producer" {
        libraries = [
          # Add any library dependency of the script here.
          pkgs.python3Packages.pyyaml
        ];
      } producer-script;

      consumer = pkgs.writers.writePython3Bin "producer" {
        libraries = [
          # Add any library dependency of the script here.
          pkgs.python3Packages.pyyaml
        ];
      } (builtins.readFile ./simple-pipeline/consumer.py);

    in {
      # devShells."${system}".default = pkgs.mkShell { buildInputs = [ ]; };
      packages = {
        "${system}" = {
          producer = producer;
          consumer = consumer;
        };
      };

    };
}

