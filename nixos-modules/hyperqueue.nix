{ pkgs, config, lib, ... }:
with lib;
let cfg = config.services.hq;
in {
  #TODO:	
  options = {
    services.hq = {
      enable = mkEnableOption "Hyperqueue service";
      worker.enable = mkEnableOption "Is this machine a worker?";
      server.enable = mkEnableOption "Is this machine a server?";
      accessDir = mkOption {
        type = types.str;
        default = "/root/.hq-server/access";
        example = "/root/.hq-server/access";
        description = lib.mdDoc ''
          The access directory for hyperqueue to use
        '';
      };

    };
  };
  config = mkIf cfg.enable {

  };

}
