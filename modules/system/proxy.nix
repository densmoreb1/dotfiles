{
  config,
  pkgs,
  ...
}: let
  maria = "192.168.0.216";
in {
  sops.secrets."proxy_domain" = {
    sopsFile = ../../secrets/ddclient.yaml;
    key = "domain";
  };

  sops.secrets."hyprapp_subdomain" = {
    sopsFile = ../../secrets/ddclient.yaml;
    key = "hyprapp_subdomain";
  };

  sops.secrets."photos_subdomain" = {
    sopsFile = ../../secrets/ddclient.yaml;
    key = "photos_subdomain";
  };

  sops.secrets."cloudflare_api_key" = {
    sopsFile = ../../secrets/ddclient.yaml;
    key = "api_key";
  };

  sops.templates."Caddyfile" = {
    owner = config.services.caddy.user;
    restartUnits = ["caddy.service"];

    content = ''
      {
        # A wildcard can only be issued over DNS, which is why Caddy is built
        # with the Cloudflare provider.
        acme_dns cloudflare ${config.sops.placeholder.cloudflare_api_key}
      }

      # A wildcard covers one label, never the bare zone, so the apex is its own
      # certificate either way.
      ${config.sops.placeholder.proxy_domain} {
        log
        reverse_proxy ${maria}:5055
      }

      *.${config.sops.placeholder.proxy_domain} {
        log

        @hyprapp host ${config.sops.placeholder.hyprapp_subdomain}.${config.sops.placeholder.proxy_domain}
        handle @hyprapp {
          reverse_proxy ${maria}:8501
        }

        @photos host ${config.sops.placeholder.photos_subdomain}.${config.sops.placeholder.proxy_domain}
        handle @photos {
          request_body {
            max_size 50GB
          }

          reverse_proxy ${maria}:2283
        }

        # The wildcard answers for every name under the zone; anything that
        # isn't one of the two above gets nothing.
        handle {
          abort
        }
      }
    '';
  };

  services.caddy = {
    enable = true;

    # DNS-01 needs a provider module, which means building Caddy with it.
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
      hash = "sha256-dQvk6ezY6TQ1J7PjhCXnThF/SqVgPwBO8/RXzHCY+js=";
    };

    # Point at the decrypted file rather than a generated one in the store.
    configFile = config.sops.templates."Caddyfile".path;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
