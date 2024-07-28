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
  runtimeInputs = [ pkgs.dialog ];
  text = ''
    if ! ssh ${erp1-settings.ssh-target} "pct config ${erp1-settings.vmid}" | grep 'hostname: ${erp1-settings.hostname}'; then
      echo "Warning: VMID ${erp1-settings.vmid} hostname does not match ${erp1-settings.hostname}. Please verify that VMID is configured correctly."
      exit 1
    fi
    if dialog --yesno "Are you sure you want to delete container ${erp1-settings.hostname} (VMID: ${erp1-settings.vmid})?" 10 60; then
      ssh ${erp1-settings.ssh-target} "pct destroy ${erp1-settings.vmid} --force --purge"
    else
      echo "Container ${erp1-settings.hostname} (VMID: ${erp1-settings.vmid}) was not destroyed."
    fi
  '';
}
