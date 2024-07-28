# This file is included in the flake lib output, this is not a module.
# This file is placed under the hosts/erp1 directory for convenience, to keep
# all of the host specific settings in one place.

rec {
  ssh-target = "root@pve01.home.kyrych.uk";
  vmid = "501";
  hostname = "erp1";
  dnsName = "${hostname}.home.kyrych.uk";
}
