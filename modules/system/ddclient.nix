{config, ...}: {
  sops.secrets."ddclient_domain" = {
    sopsFile = ../../secrets/ddclient.yaml;
    key = "domain";
  };
  sops.secrets."ddclient_api_key" = {
    sopsFile = ../../secrets/ddclient.yaml;
    key = "api_key";
  };

  # Mirrors what the ddclient module would otherwise generate from its
  # typed options (services.ddclient.domains/zone/etc.) -- using a raw
  # configFile instead lets the domain/API key come from sops placeholders
  # rather than needing to be known at Nix eval time.
  sops.templates."ddclient.conf".content = ''
    cache=/var/lib/ddclient/ddclient.cache
    foreground=YES
    usev4=webv4
    login=token
    password=${config.sops.placeholder.ddclient_api_key}
    protocol=cloudflare
    zone=${config.sops.placeholder.ddclient_domain}
    ssl=yes
    wildcard=YES
    quiet=no
    verbose=no
    ${config.sops.placeholder.ddclient_domain},*.${config.sops.placeholder.ddclient_domain}
  '';

  services.ddclient = {
    enable = true;
    interval = "1hour";
    configFile = config.sops.templates."ddclient.conf".path;
  };
}
