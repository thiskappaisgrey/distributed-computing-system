{
  inputs = { nixpkgs.url = "nixpkgs/nixos-unstable"; };
  description = "A very basic flake";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      # add Hyperqueue to the overlays of nix
      hyperqueue-overlay = (final: prev: {
        hyperqueue = prev.callPackage ./packages/hyperqueue.nix { };
      });
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ hyperqueue-overlay ];
      };
      # hyperqueue = pkgs.hyperqueue;

    in {
      # Exeperimenting with juicefs
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = with pkgs; [ hyperqueue juicefs sqlite kubo ];
      };

      #TODO: Play with a shared filesystem ...
      #TODO: Assume no security implications + sharing data is fine..?
      nixosModules.shared-fs = { pkgs, ... }: {
        # container - set this up as a container
        # set 
        boot.isContainer = true;
      };
      #TODO: Move this into it's own nix file / module
      nixosModules.base = { pkgs, ... }:
        let
          accessFile =
            pkgs.writeText "access.json" (builtins.readFile ./access.json);
          accessDir = "/root/.hq-server/access";

        in {
          # system = "x86_64-linux";
          nixpkgs.overlays = [ hyperqueue-overlay ];
          system.stateVersion = "23.05";
          environment.systemPackages = with pkgs; [ hyperqueue bash vim ];
          boot.isContainer = true;
          #TODO: Set up a way to either:
          # a. send files from local to server
          # b. send files from stdin
          # c. shared filesystem
          # d. Not sure - wormhole..? Git? Something (simplest solution works.)

          #TODO: Rewrite this as a module
          systemd.services.hq-server = {
            description = "Hyperqueue start server";

            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            # requires = [ "postfix-setup.service" ];
            path = [ pkgs.hyperqueue ];
            serviceConfig = {
              Type = "simple";
              Restart = "always";
              ExecStart =
                "${pkgs.hyperqueue}/bin/hq server start  --access-file=${accessDir}/access.json";
            };
          };

          #TODO: This starts the hyperqueue worker
          systemd.services.hq-worker = {
            description = "Hyperqueue start worker";

            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            # requires = [ "postfix-setup.service" ];
            path = [ pkgs.hyperqueue ];
            serviceConfig = {
              Type = "simple";
              Restart = "always";
              ExecStart =
                "${pkgs.hyperqueue}/bin/hq worker start --server-dir=${accessDir}";
            };
          };

          #TODO: Also setup the open ports for server / worker
          networking.firewall.allowedTCPPorts = [ 6789 1234 ];

          #TODO: Shoudl prob also set this to a variable so I can set the services working directory on start
          system.activationScripts.linkAccsesFile = ''
            mkdir -p ${accessDir}
            ln -s ${accessFile} ${accessDir}/access.json
          '';

          #TODO: Need to setup secrets..

        };

      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ self.nixosModules.base ];
      };

    };
}
