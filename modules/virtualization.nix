# Virtualization module for NixOS (Proxmox alternative, ext4 only)
{ config, lib, pkgs, ... }:

{
  # Enable VirtualBox
  virtualisation.virtualbox.host.enable = true;

  # Enable KVM/QEMU virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  users.groups.libvirtd.members = [ "aurelius" ];

  # Enable LXD (LXC alternative)
  virtualisation.lxd = {
    enable = true;
    recommendedSysctlSettings = true;
  };
  users.groups.lxd.members = [ "aurelius" ];

  # Enable Podman with Docker compatibility
  virtualisation.docker.enable = false;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  users.groups.podman.members = [ "aurelius" ];

  # Optional: Enable virt-manager for GUI management
  environment.systemPackages = with pkgs; [ virt-manager ];
}
