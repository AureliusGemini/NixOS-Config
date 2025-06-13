# /etc/nixos/minecraft-server.nix
{ pkgs, lib, ...}: 

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    package = pkgs.minecraft-server;
    dataDir = "/var/lib/minecraft-server";

    serverProperties = {
      gamemode = "creative";
      difficulty = "normal";
      simulation-distance = 10;
      level-seed = "4";
      motd = "NixOS Minecraft server!";
      max-players = 5; 
    };

    whitelist = {
      # Add whitelisted players here
    };

    jvmOpts = "-Xms4G -Xmx8G -XX:+UseG1GC";
  };
}