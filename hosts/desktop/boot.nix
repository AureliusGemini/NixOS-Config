# Bootloader and kernel module quirks.
{ ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10; # keep the ESP from filling up
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Realtek Wi-Fi stability
  boot.extraModprobeConfig = ''
    options rtl8188ee fwlps=N ips=N aspm=0
  '';
}
