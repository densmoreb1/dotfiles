{
  config,
  lib,
  pkgs,
  ...
}: let
  maria = "192.168.0.216";

  # Published at https://www.cloudflare.com/ips-v4 and ips-v6. Requests arrive
  # from these, so without them every client looks like Cloudflare.
  cloudflareRanges = [
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
    "2400:cb00::/32"
    "2606:4700::/32"
    "2803:f800::/32"
    "2405:b500::/32"
    "2405:8100::/32"
    "2a06:98c0::/29"
    "2c0f:f248::/32"
  ];
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

  # Caddy checks each request against CrowdSec's decisions, which needs its own
  # bouncer key -- separate from the firewall bouncer's.
  sops.secrets."crowdsec_caddy_key" = {
    sopsFile = ../../secrets/ddclient.yaml;
    key = "crowdsec_caddy_key";
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

        # The zone is proxied, so the connecting address is always a Cloudflare
        # edge. Trusting it makes Caddy read the real client from
        # X-Forwarded-For -- which is what the logs, and CrowdSec, then see.
        servers {
          trusted_proxies static ${lib.concatStringsSep " " cloudflareRanges}
        }

        # Run the check ahead of anything that would serve or proxy a response.
        order crowdsec first

        crowdsec {
          api_url http://127.0.0.1:8080
          api_key ${config.sops.placeholder.crowdsec_caddy_key}
          ticker_interval 15s
        }
      }

      # A wildcard covers one label, never the bare zone, so the apex is its own
      # certificate either way.
      ${config.sops.placeholder.proxy_domain} {
        log
        crowdsec
        reverse_proxy ${maria}:5055
      }

      *.${config.sops.placeholder.proxy_domain} {
        log
        crowdsec

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

    # DNS-01 needs a provider module, and the bouncer enforces CrowdSec's
    # decisions here, where the real client address is known.
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.2.4"
        "github.com/hslatman/caddy-crowdsec-bouncer/http@v0.14.1"
      ];
      # Covers Caddy 2.11.4 and the plugin set above; changing either changes
      # this, and the build reports the replacement.
      hash = "sha256-BlrmYluzYuTvkvORF/eLpX62xux+5seMmvEaHZ1bIrc=";

      # The bouncer lives in a subdirectory with no go.mod of its own, so the
      # build records the root module and the default check can't match the
      # path above. Presence is verified with `caddy list-modules` instead.
      doInstallCheck = false;
    };

    # Point at the decrypted file rather than a generated one in the store.
    configFile = config.sops.templates."Caddyfile".path;
  };

  # The bouncer connects to the local API as it starts. Without this, Caddy
  # comes up first and serves against an empty decision list until it retries.
  systemd.services.caddy.after = ["crowdsec.service"];

  networking.firewall.allowedTCPPorts = [80 443];
}
