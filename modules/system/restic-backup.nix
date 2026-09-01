# Nightly offsite backup of the Immich photo library to Backblaze B2.
#
# Immich's own nightly job dumps the Postgres DB into /media/immich/backups;
# this timer runs after that (03:30, giving it a buffer) and pushes
# everything except the regenerable caches (thumbs/, encoded-video/) up to
# B2 with restic, which handles client-side encryption, dedup, and
# incremental chunking on its own.
{
  config,
  username,
  pkgs,
  ...
}: let
  libraryPath = "/media/immich";

  backup = pkgs.writeShellApplication {
    name = "immich-backup";
    runtimeInputs = [pkgs.restic];
    text = ''
      restic backup ${libraryPath} \
        --exclude '${libraryPath}/thumbs' \
        --exclude '${libraryPath}/encoded-video' \
        --tag immich

      restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
    '';
  };
in {
  environment.systemPackages = [pkgs.restic];

  sops.secrets."restic-env" = {
    sopsFile = ../../secrets/restic-backup.yaml;
    key = "env";
    owner = username;
  };

  systemd.services.immich-backup = {
    description = "Back up the Immich photo library to Backblaze B2";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backup}/bin/immich-backup";
      EnvironmentFile = config.sops.secrets."restic-env".path;
      User = username;
    };
  };

  systemd.timers.immich-backup = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "03:30";
      Persistent = true;
      Unit = "immich-backup.service";
    };
  };
}
