{username, ...}: let
  ddclient-config = import /home/${username}/ddclient-config.nix;
in {
  services.ddclient = {
    enable = true;
    interval = "1hour";
    protocol = "cloudflare";
    username = "token";
    passwordFile = "/home/${username}/cloudflare_api.txt";
    domains = [ddclient-config.domain "*.${ddclient-config.domain}"];
    zone = ddclient-config.domain;
    ssl = true;
  };
}
