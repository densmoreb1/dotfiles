{
  config,
  pkgs,
  username,
  ...
}: let
  appDir = "/home/${username}/hyprapp";
  # Lives under the Immich library so immich-backup.nix's restic run sweeps it
  # up to B2, but in its own subdirectory: the library root belongs to Immich.
  backupDir = "/media/immich/hyprapp";
  container = "hypertrophy-mysql";
  keepDays = 5;
in {
  systemd.services.hyprapp-backup = {
    description = "Archive the hyprapp MySQL data directory";

    # The whole job is docker calls, so the daemon has to be up first.
    after = ["docker.service"];
    requires = ["docker.service"];

    path = [
      config.virtualisation.docker.package
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnutar
      pkgs.gzip
    ];

    serviceConfig.Type = "oneshot";

    script = ''
      set -euo pipefail

      if [ ! -d ${appDir}/mysql ]; then
        echo "no data directory at ${appDir}/mysql, nothing to back up" >&2
        exit 1
      fi

      archive="${backupDir}/hyprapp-$(date +%Y%m%d-%H%M%S).tar.gz"
      tmp="$archive.part"

      # Restart the container only if it was up when we arrived; starting a
      # stack that was deliberately stopped would be a surprise.
      running=$(docker inspect -f '{{.State.Running}}' ${container} 2>/dev/null || echo absent)

      cleanup() {
        # A half-written archive is dead weight that restic would otherwise
        # keep shipping to B2, so it never outlives the run that made it.
        rm -f "$tmp"
        if [ "$running" = "true" ]; then
          docker start ${container} >/dev/null
        fi
      }
      trap cleanup EXIT

      if [ "$running" = "true" ]; then
        # InnoDB's files on disk are only self-consistent once mysqld has
        # exited cleanly, so the archive is taken with the container down.
        # The long timeout leaves room to flush rather than be killed.
        docker stop --time 60 ${container} >/dev/null
      fi

      tar czf "$tmp" -C ${appDir} mysql

      # A truncated archive that looks like a backup is worse than no archive,
      # so it only gets its real name once the whole thing reads back cleanly.
      # Listing it checks the tar structure too, not just the gzip stream.
      tar tzf "$tmp" >/dev/null
      mv "$tmp" "$archive"
      chown ${username}:users "$archive"
      echo "wrote $archive ($(du -h "$archive" | cut -f1))"

      find ${backupDir} -maxdepth 1 -name 'hyprapp-*.tar.gz' -type f -mtime +${toString keepDays} -delete

      # The trap above handles the usual failures; this catches leftovers from
      # a run that was killed outright (power loss, SIGKILL).
      find ${backupDir} -maxdepth 1 -name 'hyprapp-*.tar.gz.part' -type f -mtime +1 -delete
    '';
  };

  systemd.timers.hyprapp-backup = {
    description = "Daily hyprapp MySQL archive";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
      # Catch up after downtime instead of skipping the missed run.
      Persistent = true;
    };
  };

  systemd.tmpfiles.rules = ["d ${backupDir} 0750 ${username} users -"];
}
