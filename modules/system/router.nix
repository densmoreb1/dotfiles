{lib, ...}: let
  routerAddress = "192.168.50.1";
  subnet = "50";
in {
  # Give the two network ports permanent names, so they can't swap identities
  systemd.network.links = {
    "10-wan" = {
      matchConfig.PermanentMACAddress = "b8:85:84:a6:4a:46";
      linkConfig.Name = "wan";
    };

    "10-lan" = {
      matchConfig.PermanentMACAddress = "";
      linkConfig.Name = "lan";
    };
  };

  networking = {
    # Turn the firewall on
    firewall.enable = lib.mkForce true;

    # Turn off the automatic network manager so it can't wander in and override the fixed settings below.
    networkmanager.enable = lib.mkForce false;

    # Don't let every port grab an address on its own; each one is configured deliberately below.
    useDHCP = false;

    # The internet-facing port asks the ISP for an address, the same way any normal device would.
    interfaces.wan.useDHCP = true;

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
    };

    # Devices inside the house may reach services running on the router; the internet side stays closed unless something explicitly opens it.
    firewall.trustedInterfaces = ["lan"];

    # The base OS will use these DNS
    nameservers = ["9.9.9.9" "1.1.1.1"];
  };

  # Records stats
  services.vnstat.enable = true;

  # Hands out addresses to devices as they join the network.
  services.dnsmasq = {
    enable = true;

    # Don't point this machine at itself for name lookups -- it no longer answers them.
    resolveLocalQueries = false;

    settings = {
      # Switch off this program's name-lookup half. Pi-hole does that job
      port = 0;

      # Only offer addresses to the house side. Never answer a stranger on the internet.
      interface = ["lan"];
      # Start up gracefully even if the network port isn't ready yet at boot.
      bind-dynamic = true;

      # Range of IP
      dhcp-range = ["192.168.${subnet}.2,192.168.${subnet}.253,24h"];

      # Reservations
      dhcp-host = ["60:cf:84:64:bd:59,192.168.${subnet}.216,maria" "3c:7c:3f:21:ab:35,192.168.${subnet}.66,rose" "8c:90:2d:ea:e7:99,192.168.${subnet}.119,c200"];

      # Resolv.conf
      dhcp-option = [
        "option:router,${routerAddress}"
        "option:dns-server,${routerAddress}"
      ];
    };
  };

  # Turn off systemd's own name-lookup service so nothing competes for port 53.
  services.resolved.enable = false;

  # Stop SSH from opening itself to the internet. The trusted-interface rule above still lets you in from inside the house.
  services.openssh.openFirewall = false;

  virtualisation.docker.daemon.settings = {
    # A container publishing a port lands on the house network only. Docker sidesteps the firewall entirely, so this is the setting doing the protecting.
    ip = "${routerAddress}";
    # Keep the real device's address visible to containers, so Pi-hole can report which device made each request instead of lumping them together.
    userland-proxy = false;
  };
}
