{
  pname,
  flake,
  pkgs,
  ...
}:
let
  inherit (flake.lib) erp1-settings;
  # configuration = flake.nixosConfigurations."${erp1-settings.hostname}".config;
  hostPlatform = "x86_64-linux"; # TODO: how to extract it from configuration?
  tarball = flake.nixosConfigurations."${erp1-settings.hostname}".config.system.build.tarball;
  imageName = "${erp1-settings.hostname}-nixos-system-${hostPlatform}.tar.xz";
in
pkgs.writeShellApplication {
  name = pname;
  text = ''
    if ssh ${erp1-settings.ssh-target} "pct status ${erp1-settings.vmid}"; then
      echo "Warning: VMID ${erp1-settings.vmid} may be taken. Cancelling container creation."
      exit 1
    fi
    scp ${tarball}/tarball/nixos-system-${hostPlatform}.tar.xz ${erp1-settings.ssh-target}:/var/lib/vz/template/cache/${imageName}
    ssh ${erp1-settings.ssh-target} \
      "pct create ${erp1-settings.vmid} local:vztmpl/${imageName} \
      --hostname ${erp1-settings.hostname} \
      --net0 name=eth0,bridge=vmbr0,firewall=1,ip=dhcp,type=veth \
      --storage local-zfs --features nesting=1 \
      --start"
  '';
}
