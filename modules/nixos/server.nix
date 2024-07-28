{ inputs, flake, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.default
    inputs.srvos.nixosModules.server
  ];

  users.users.root.openssh.authorizedKeys.keyFiles = [
    "${flake}/users/dmytrokyrychuk/authorized_keys"
  ];
}
