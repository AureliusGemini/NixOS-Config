# The one user, on every host. Hosts/features append extra groups (lists merge).
{ user, ... }:

{
  security.sudo.wheelNeedsPassword = false;

  users.users.${user.name} = {
    isNormalUser = true;
    description = user.description;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = user.sshKeys;
  };
}
