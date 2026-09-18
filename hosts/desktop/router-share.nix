{ config, pkgs, ... }:

let
  lanInterface = "enp4s0";
  usbTetherInterface = "enp1s0f0u4";
  sharedFolderPath = "/home/aurelius/Shared";
in
{
  # ---------------------------------------------------------------------------
  # 1. NETWORK INTERFACE & ROUTING (NAT)
  # ---------------------------------------------------------------------------
  networking.interfaces.${lanInterface} = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.50.1";
        prefixLength = 24;
      }
    ];
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.nat = {
    enable = true;
    externalInterface = usbTetherInterface;
    internalInterfaces = [ lanInterface ];
  };

  # ---------------------------------------------------------------------------
  # 2. DNSMASQ (DHCP & DNS Server)
  # ---------------------------------------------------------------------------
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = lanInterface;
      bind-interfaces = true;
      dhcp-range = [ "192.168.50.10,192.168.50.100,255.255.255.0,12h" ];
      dhcp-option = [
        "option:router,192.168.50.1"
        "option:dns-server,192.168.50.1"
      ];
    };
  };

  # ---------------------------------------------------------------------------
  # 3. FIREWALL RULES FOR ROUTING & SAMBA
  # ---------------------------------------------------------------------------
  networking.firewall = {
    allowedUDPPorts = [ 53 67 137 138 ];
    allowedTCPPorts = [ 53 139 445 ];
  };

  # ---------------------------------------------------------------------------
  # 4. SAMBA FILE SHARING & WINDOWS AUTO-DISCOVERY
  # ---------------------------------------------------------------------------
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "NixOS-Desktop";
        "netbios name" = "NIXOS-DESKTOP";
        "security" = "user";
        "hosts allow" = "192.168.50.0/24 100.64.0.0/10 127.0.0.1";
        "hosts deny" = "0.0.0.0/0";
        "map to guest" = "bad user";
      };
      "SharedFolder" = {
        "path" = sharedFolderPath;
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "aurelius";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d ${sharedFolderPath} 0755 aurelius users - -"
  ];
}
