# User configuration
{ config, lib, pkgs, ... }:

{
  # Define user account
  users.users.aurelius = {
    isNormalUser = true;
    description = "Elvin Aurelius Yamin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
