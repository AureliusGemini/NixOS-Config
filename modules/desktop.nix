# Desktop environment module
{ config, lib, pkgs, ... }:

{
  # Enable SDDM and KDE Plasma 6
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable X11 (needed for xrdp and fallback)
  services.xserver.enable = true;

  # Configure xrdp to use X11 session
  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11";
  };

  # Open RDP port
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # X11 keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Set virtual screen resolution for remote (XRDP)
  services.xserver.virtualScreen = {
    enable = true;
    x = 1920;
    y = 1080;
  };

  # Enable CUPS for printing
  services.printing.enable = true;

  # Enable PipeWire audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Disable pulseaudio
  services.pulseaudio.enable = false;

  # Enable portals (KDE-specific portal preferred)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = "*";
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    xrdp
    pipewire
    wireplumber
    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde
    kdePackages.plasma-browser-integration
  ];

  # Optional: Use systemd service to switch to Wayland session if HDMI TV is connected
  systemd.services.set-display-server-mode = {
    description = "Set SDDM to Wayland if HDMI is connected";
    wantedBy = [ "multi-user.target" ];
    script = ''
      mkdir -p /etc/sddm.conf.d
      HDMI_CONNECTED=$(cat /sys/class/drm/card1-HDMI-A-1/status)
      if [ "$HDMI_CONNECTED" = "connected" ]; then
        echo "WaylandSession=plasma" > /etc/sddm.conf.d/wayland.conf
      else
        echo "Session=plasma" > /etc/sddm.conf.d/x11.conf
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

}
