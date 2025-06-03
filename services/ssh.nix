# /etc/nixos/services/ssh.nix
{ config, pkgs, lib, ... }:

{
  services.openssh = {
    enable = true;
    package = pkgs.openssh;  # Specify the OpenSSH package to use
    ports = [ 22 ];          # Define the ports to listen on
    settings = {
      PasswordAuthentication = false;  # Disable password authentication for better security
      PermitRootLogin = "yes";

      KexAlgorithms = [
        # "[email protected]"
        "curve25519-sha256"
        # "[email protected]"
        "diffie-hellman-group-exchange-sha256"
      ];  # Specify secure key exchange algorithms

      Ciphers = [
        # "[email protected]"
        # "[email protected]"
        # "[email protected]"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];  # Define secure ciphers

      Macs = [
        # "[email protected]"
        # "[email protected]"
        # "[email protected]"
        "hmac-sha2-512"
        "hmac-sha2-256"
        # "[email protected]"
      ];  # Set secure MACs

      LogLevel = "VERBOSE";          # Enable verbose logging
      AllowTcpForwarding = false;    # Disable TCP forwarding
      AllowAgentForwarding = false;  # Disable agent forwarding
      MaxAuthTries = 3;              # Limit the number of authentication attempts
      MaxSessions = 2;               # Limit the number of open sessions
      TCPKeepAlive = false;          # Disable TCP keep-alive
      ClientAliveInterval = 300;     # Set client alive interval
      ClientAliveCountMax = 0;       # Set client alive count max
    };

    extraConfig = ''
      # ClientAliveCountMax 0        # redundant, already in settings
      # ClientAliveInterval 300      # redundant, already in settings
      # AllowTcpForwarding no        # redundant, already in settings
      # AllowAgentForwarding no      # redundant, already in settings
      # MaxAuthTries 3               # redundant, already in settings
      # MaxSessions 2                # redundant, already in settings
      # TCPKeepAlive no              # redundant, already in settings
    '';  # Additional SSH configurations (currently empty because redundant)
  };
}
