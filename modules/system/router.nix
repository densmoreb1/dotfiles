{lib, ...}: let
  maria = "192.168.0.216";
  rose = "192.168.0.66";
  routerAddress = "192.168.0.1";
  subnet = "0";
in {
  # Give the two network ports permanent names, so they can't swap identities
  systemd.network.links = {
    "10-wan" = {
      matchConfig.PermanentMACAddress = "b8:85:84:a6:4a:46";
      linkConfig.Name = "wan";
    };

    "10-lan" = {
      matchConfig.PermanentMACAddress = "c4:62:37:0f:6c:8b";
      linkConfig.Name = "lan";
    };
  };

  networking = {
    firewall.enable = lib.mkForce true;

    # Turn off the automatic network manager so it can't override the fixed settings below
    networkmanager.enable = lib.mkForce false;

    # Leave this to pihole
    useDHCP = false;

    # The internet-facing port asks the ISP for an address, the same way any normal device would.
    interfaces.wan.useDHCP = true;

    # Turn off ipv6
    dhcpcd.extraConfig = ''
      interface wan
        nodhcp6
    '';

    interfaces.lan.ipv4.addresses = [
      {
        address = "${routerAddress}";
        prefixLength = 24;
      }
    ];

    # Share one internet connection among every device in the house -- this translation is the core job of a router.
    nat = {
      enable = true;
      externalInterface = "wan";
      internalInterfaces = ["lan"];
      forwardPorts = [
        {
          sourcePort = 32400;
          proto = "tcp";
          destination = "${maria}:32400";
        }
      ];
    };

    # Devices inside the house may reach services running on the router; the internet side stays closed unless something explicitly opens it.
    firewall.trustedInterfaces = ["lan"];

    # The base OS will use these DNS
    nameservers = ["9.9.9.9" "1.1.1.1"];
  };

  # Records stats
  services.vnstat.enable = true;

  services.pihole-ftl = {
    enable = true;

    # `lan` is trusted already, and these open their ports on every interface.
    # Leaving them off is what keeps a resolver off the internet side.
    openFirewallDNS = false;
    openFirewallDHCP = false;
    openFirewallWebserver = false;

    queryLogDeleter.enable = true;

    lists = [
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/ultimate.txt";
        description = "HaGeZi Ultimate";
      }
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt";
        description = "HaGeZi Threat Intelligence Feeds";
      }
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/popupads.txt";
        description = "HaGeZi Pop-Up Ads";
        enabled = false;
      }
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/doh-vpn-proxy-bypass.txt";
        description = "HaGeZi DoH/VPN/Proxy Bypass";
        enabled = false;
      }
    ];

    settings = {
      dns = {
        interface = "lan";
        listeningMode = "BIND";
        upstreams = ["127.0.0.1#5335"];
        domainNeeded = true;
      };

      dhcp = {
        active = true;
        router = routerAddress;
        start = "192.168.${subnet}.2";
        end = "192.168.${subnet}.253";
        leaseTime = "24h";
        hosts = [
          "60:cf:84:64:bd:59,${maria},maria"
          "3c:7c:3f:21:ab:35,${rose},rose"
          "8c:90:2d:ea:e7:99,192.168.${subnet}.119,c200"
        ];
      };

      ntp = {
        ipv4.active = true;
        ipv6.active = true;
        # timesyncd owns this machine's clock; FTL only serves time to clients.
        sync.active = false;
      };

      # Required for `lists` to be loaded through the local API on startup.
      webserver.api.cli_pw = true;
    };
  };

  services.pihole-web = {
    enable = true;
    ports = [8081];
  };

  # Recursive resolver sitting exactly where the old container sat: reachable
  # only from this machine, and only by Pi-hole.
  services.unbound = {
    enable = true;

    # Pi-hole answers for the house; don't let unbound claim resolv.conf.
    resolveLocalQueries = false;

    settings.server = {
      interface = ["127.0.0.1"];
      port = 5335;
      access-control = ["127.0.0.1/32 allow"];
      do-ip6 = false;

      harden-glue = true;
      harden-dnssec-stripped = true;
      use-caps-for-id = false;
      prefetch = true;
      edns-buffer-size = 1232;
    };
  };

  # Turn off systemd's own name-lookup service so nothing competes for port 53.
  services.resolved.enable = false;

  # Stop SSH from opening itself to the internet. The trusted-interface rule above still lets you in from inside the house.
  services.openssh.openFirewall = false;

  virtualisation.docker.daemon.settings = {
    # A container publishing a port lands on the house network only. Docker sidesteps the firewall entirely, so this is the setting doing the protecting.
    ip = "${routerAddress}";
  };
}
