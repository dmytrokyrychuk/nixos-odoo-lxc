{
  inputs,
  flake,
  config,
  ...
}:
let
  domain = flake.lib.erp1-settings.dnsName;
in
{
  imports = [ inputs.srvos.nixosModules.mixins-nginx ];

  services.odoo = {
    enable = true;
    domain = domain;
    addons = [ ];
    autoInit = true;
  };

  sops.secrets.LINODE_TOKEN = { };
  sops.templates."acmedns.kyrych.uk.env" = {
    content = ''
      LINODE_TOKEN=${config.sops.placeholder.LINODE_TOKEN}
    '';
    owner = "acme";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "dmytro+acme@kyrych.uk";
    certs.${domain} = {
      dnsProvider = "linode";
      environmentFile = config.sops.templates."acmedns.kyrych.uk.env".path;
    };
  };

  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    acmeRoot = null; # disable HTTP-1 challenge
    forceSSL = true;
  };
}
