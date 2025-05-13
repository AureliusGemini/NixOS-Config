# Cockpit service module
{ config, lib, pkgs, ... }:

{
  options = {
    services.cockpit = {
      enable = lib.mkEnableOption "Cockpit web service";
      port = lib.mkOption {
        type = lib.types.port;
        default = 9090;
        description = "Port to listen on";
      };
      openFirewall = lib.mkEnableOption "Open firewall for Cockpit";
      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Cockpit configuration";
      };
    };
  };

  config = lib.mkIf config.services.cockpit.enable {
    environment.systemPackages = [ pkgs.cockpit pkgs.sscg ];
    
    # Create Cockpit configuration directory
    environment.etc."cockpit/cockpit.conf".text = ''
      [WebService]
      Origins = https://localhost:${toString config.services.cockpit.port} https://${config.networking.hostName}:${toString config.services.cockpit.port}
      ProtocolHeader = X-Forwarded-Proto
      
      [Log]
      Fatal = criticals
    '';

    # Open firewall if enabled
    networking.firewall.allowedTCPPorts = lib.mkIf config.services.cockpit.openFirewall [ config.services.cockpit.port ];
    
    # Create systemd service for Cockpit
    systemd.services.cockpit = {
      description = "Cockpit Web Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.cockpit}/libexec/cockpit-ws --no-tls";
        User = "root";
        Restart = "on-failure";
      };
    };
  };
}
