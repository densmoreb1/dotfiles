{config, ...}: {
  services.crowdsec = {
    enable = true;

    # Refresh hub parsers and scenarios daily.
    autoUpdateService = true;

    # The local API is off by default, and without it the agent has no client
    settings.general.api.server.enable = true;
    settings.lapi.credentialsFile = "/var/lib/crowdsec/state/local_api_credentials.yaml";

    hub.collections = [
      "crowdsecurity/linux"
      "crowdsecurity/caddy"
    ];

    # Both services log to the journal, so read them from there rather than
    # pointing at files that don't exist.
    localConfig.acquisitions = [
      {
        source = "journalctl";
        journalctl_filter = ["_SYSTEMD_UNIT=caddy.service"];
        labels.type = "caddy";
      }
      {
        source = "journalctl";
        journalctl_filter = ["_SYSTEMD_UNIT=sshd.service"];
        labels.type = "syslog";
      }
    ];
  };

  systemd.tmpfiles.settings."09-crowdsec-root"."/var/lib/crowdsec".d = {
    user = config.services.crowdsec.user;
    group = config.services.crowdsec.group;
    mode = "0750";
  };

  sops.secrets."crowdsec_bouncer_key" = {
    sopsFile = ../../secrets/ddclient.yaml;
    key = "crowdsec_bouncer_key";
  };

  # Turns decisions into nftables drops.
  services.crowdsec-firewall-bouncer = {
    enable = true;

    # Self-registration runs an unwrapped `cscli`, which looks for a config file
    # NixOS never creates, so the key is issued once by hand and kept in sops.
    registerBouncer.enable = false;
    secrets.apiKeyPath = config.sops.secrets."crowdsec_bouncer_key".path;
  };
}
