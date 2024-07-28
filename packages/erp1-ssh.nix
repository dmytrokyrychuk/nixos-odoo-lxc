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
    # shellcheck disable=SC2029
    ssh root@${erp1-settings.dnsName} "$@"
  '';
}
