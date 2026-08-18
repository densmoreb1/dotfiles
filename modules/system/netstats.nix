# Per-device traffic accounting, published as a single JSON file for Home
# Assistant to read.
#
# Two pieces:
#   1. An nftables table that counts bytes per LAN address in the kernel.
#      It is separate from the iptables firewall and never issues a verdict,
#      so the two coexist without interfering.
#   2. A timer that merges those counters with vnstat totals into
#      /var/lib/netstats/usage.json, which HA mounts read-only.
#
# HA needs no extra packages for this -- its sensors are `cat` plus a template.
{pkgs, ...}: let
  lanSubnet = "192.168.50.0/24";
  outputDir = "/var/lib/netstats";
  outputFile = "${outputDir}/usage.json";

  # Counts only, no accept/drop. Priority 300 puts it after the firewall's
  # hooks. Scoping both rules to the LAN subnet is what keeps the maps
  # bounded -- unscoped, they would grow an entry per internet peer.
  rules = pkgs.writeText "accounting.nft" ''
    table ip accounting {
      map upload {
        type ipv4_addr : counter
        flags dynamic
      }

      map download {
        type ipv4_addr : counter
        flags dynamic
      }

      chain acct {
        type filter hook forward priority 300; policy accept;
        ip saddr ${lanSubnet} update @upload { ip saddr counter }
        ip daddr ${lanSubnet} update @download { ip daddr counter }
      }
    }
  '';

  netstats = pkgs.writeShellApplication {
    name = "netstats";
    runtimeInputs = with pkgs; [nftables vnstat jq coreutils];
    text = ''
      acct=$(nft -j list table ip accounting)
      vn=$(vnstat --json m 1)

      # NOTE: verify the .nftables[] element path against real output once --
      # `nft -j list table ip accounting | jq .` -- the shape differs across
      # nftables versions and a wrong path yields an empty devices object
      # rather than an error.
      jq -n --argjson acct "$acct" --argjson vn "$vn" '
        def counters($name):
          [ $acct.nftables[]
            | select(.map != null and .map.name == $name)
            | (.map.elem // [])[]
            | { key:   .[0],
                value: (.[1].counter.bytes // .[1].bytes // 0) }
          ] | from_entries;

        counters("upload")   as $up   |
        counters("download") as $down |
        {
          generated: (now | todate),
          interfaces: [
            $vn.interfaces[]
            | { name: .name,
                month_rx: (.traffic.month[0].rx // 0),
                month_tx: (.traffic.month[0].tx // 0) }
          ],
          devices: (
            ([$up, $down] | add | keys)
            | map({ key: ., value: {
                up:    ($up[.]   // 0),
                down:  ($down[.] // 0),
                total: (($up[.] // 0) + ($down[.] // 0))
              }})
            | from_entries
          )
        }
      ' > ${outputFile}.tmp

      # Atomic replace, so HA never reads a half-written file.
      mv ${outputFile}.tmp ${outputFile}
      chmod 0644 ${outputFile}
    '';
  };
in {
  environment.systemPackages = [netstats pkgs.nftables];

  # Install the counting table at boot and tear it down cleanly on stop.
  systemd.services.net-accounting = {
    description = "Per-device traffic counters (nftables)";
    wantedBy = ["multi-user.target"];
    after = ["network-pre.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.nftables}/bin/nft -f ${rules}";
      ExecStop = "${pkgs.nftables}/bin/nft delete table ip accounting";
    };
  };

  # Refresh the JSON every minute.
  systemd.services.netstats = {
    description = "Write per-device traffic totals to JSON";
    after = ["net-accounting.service"];
    requires = ["net-accounting.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${netstats}/bin/netstats";
      StateDirectory = "netstats";
    };
  };

  systemd.timers.netstats = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "1min";
      Unit = "netstats.service";
    };
  };
}
