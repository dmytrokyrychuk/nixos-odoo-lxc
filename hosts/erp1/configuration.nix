{
  inputs,
  flake,
  modulesPath,
  ...
}:
{
  imports = [
    ./odoo.nix
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    flake.nixosModules.server
    inputs.srvos.nixosModules.server
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "24.05";
}
