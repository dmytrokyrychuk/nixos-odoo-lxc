{
  pname,
  flake,
  pkgs,
  ...
}:
let
  inherit (flake.lib) erp1-settings;
in
pkgs.writeShellApplication {
  name = pname;
  text = ''
    if ! ssh ${erp1-settings.ssh-target} "pct status ${erp1-settings.vmid}" | grep 'status: running'; then
      echo "Warning: VMID ${erp1-settings.vmid} must be running during update. "
      exit 1
    fi
    nixos-rebuild switch --flake .#erp1 --target-host ${erp1-settings.dnsName}
  '';
}
