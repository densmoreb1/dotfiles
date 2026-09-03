{
  pkgs,
  lib,
  ...
}: let
  # mailsync shells out to all of these. A systemd user unit gets a leaner
  # PATH than an interactive login, so spell the dependencies out rather than
  # relying on whatever the session happens to export.
  syncPath = lib.makeBinPath (with pkgs; [
    coreutils
    findutils
    gawk
    gnugrep
    gnupg
    gnused
    isync
    libnotify
    mutt-wizard
    pass
    procps
  ]);
in {
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 3750;
    maxCacheTtl = 3750;
  };

  systemd.user.services.refresh-mail = {
    Unit.Description = "Sync all mutt-wizard accounts with mbsync";
    Service = {
      Type = "oneshot";
      Environment = ["PATH=${syncPath}"];
      ExecStart = "${pkgs.mutt-wizard}/bin/mailsync";
    };
  };

  systemd.user.timers.refresh-mail = {
    Unit.Description = "Sync mail every 15 minutes";
    Timer = {
      OnCalendar = "*:0/15";
      # Catch up on a sync missed while suspended or powered off.
      Persistent = true;
      RandomizedDelaySec = "60";
    };
    Install.WantedBy = ["timers.target"];
  };
}
