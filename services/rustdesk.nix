(config, pkgs, ... );

{
    services.rustdesk-server.enable = true;
    services.rustdesk-server.openFirewall = true;
    services.rustdesk-server.package = pkgs.rustdesk-server;
    services.rustdesk-server.relay.enable = true;
    # services.rustdesk-server.relay.extraArgs = [ "--relay-hosts=relay1.example.com,relay2.example.com" ];
    services.rustdesk-server.signal.enable = true;
    # services.rustdesk-server.signal.extraArgs = [ "--relay-hosts=signal1.example.com,signal2.example.com" ];
    # services.rustdesk-server.signal.relayHosts = [ "signal1.example.com" "signal2.example.com" ];
}