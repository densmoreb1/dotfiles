# Edge router: NAT, firewall, and DHCP. IPv4 only.
# DNS is served by the Pi-hole container, not by this config -- dnsmasq runs
# with port=0 so the two don't fight over :53.
#
# NOT imported yet. Fill in the two MAC addresses below, then add
# ../../modules/system/router.nix to systems/pipboy/default.nix. Deploying
# with the placeholder MACs will leave the host with no working network.
{lib, ...}: let
  wanIf = "wan";
  lanIf = "lan";

  # From `ip -br link` once the NIC is installed.
  wanMac = "00:00:00:00:00:00";
  lanMac = "b8:85:84:a6:4a:46";

  # Existing subnet, so statically-addressed hosts keep working.
  # The old router becomes an AP at .2.
  lanAddr = "192.168.50.1";
  lanPrefix = 24;
in {
  # Pin interface names by MAC. Adding a PCIe card shifts the enp* names
  # around, and guessing wrong here puts the LAN on the public port.
  # .link files are applied by udev, so this works without networkd.
  systemd.network.links = {
    "10-wan" = {
      matchConfig.PermanentMACAddress = wanMac;
      linkConfig.Name = wanIf;
    };
    "10-lan" = {
      matchConfig.PermanentMACAddress = lanMac;
      linkConfig.Name = lanIf;
    };
  };

  networking = {
    # ./default.nix turns the firewall off and NetworkManager on. Neither is
    # survivable on a host with a public interface.
    firewall.enable = lib.mkForce true;
    networkmanager.enable = lib.mkForce false;

    useDHCP = false;
    interfaces.${wanIf}.useDHCP = true;
    interfaces.${lanIf}.ipv4.addresses = [
      {
        address = lanAddr;
        prefixLength = lanPrefix;
      }
    ];

    nat = {
      enable = true;
      externalInterface = wanIf;
      internalInterfaces = [lanIf];
    };

    # Everything inbound on the LAN is allowed; the WAN keeps its default
    # deny. This is what keeps SSH private -- see openssh.openFirewall below.
    firewall.trustedInterfaces = [lanIf];

    # Upstream on purpose, NOT Pi-hole. If the router resolved through its own
    # container, a container that is broken or not yet pulled would leave
    # nixos-rebuild unable to fetch the fix. Clients still use Pi-hole.
    nameservers = ["1.1.1.1" "9.9.9.9"];
  };

  # No IPv6 forwarding is enabled, so the LAN has no v6 path out and there is
  # no unfiltered v6 to worry about. The router's own WAN v6 address, if the
  # ISP hands one out, is covered by the firewall's default deny.

  services.vnstat.enable = true;

  # DHCP only. Pi-hole owns DNS.
  services.dnsmasq = {
    enable = true;

    # Would otherwise point this host at 127.0.0.1, where nothing listens now
    # that dnsmasq serves no DNS. networking.nameservers above replaces it.
    resolveLocalQueries = false;

    settings = {
      # dnsmasq's built-in way to run as a pure DHCP server. Frees :53 for the
      # Pi-hole container, which is itself dnsmasq and would otherwise clash.
      port = 0;

      # LAN only, never the WAN. bind-dynamic avoids failing at boot if the
      # interface isn't up yet.
      interface = [lanIf];
      bind-dynamic = true;

      dhcp-range = ["192.168.50.100,192.168.50.240,24h"];
      dhcp-option = [
        "option:router,${lanAddr}"
        # Pi-hole, via its published port on the LAN address.
        "option:dns-server,${lanAddr}"
      ];
    };
  };

  services.resolved.enable = false;

  # ./default.nix sets openssh to port 6977. openFirewall defaults to true,
  # which would open that port on every interface including the WAN.
  # trustedInterfaces above still allows SSH from the LAN.
  services.openssh.openFirewall = false;

  # Docker writes its DNAT rules ahead of networking.firewall, so a published
  # port lands on the WAN and the firewall does not stop it. This makes the
  # LAN address the default bind, so `-p 8080:8080` stays internal.
  # Containers using --network host are ordinary host sockets and are already
  # covered by the firewall above.
  #
  # userland-proxy=false forces published ports through real DNAT, which
  # preserves the client's source address. Without it Pi-hole can log every
  # query as coming from the docker bridge gateway, losing per-client stats.
  virtualisation.docker.daemon.settings = {
    ip = lanAddr;
    userland-proxy = false;
  };
}
