{pkgs, ...}: {
  # mutt-wizard writes ~/.config/mutt by hand, so any nix store path it bakes
  # in dies at the next garbage collection and neomutt stops starting. Link
  # these into the system profile instead and point the config at
  # /run/current-system/sw/..., which survives both GC and rebuilds.
  environment.pathsToLink = [
    "/share/mutt-wizard"
    "/libexec" # gnupg's gpg-wks-client, used by the key-publishing macros
  ];

  environment.systemPackages = with pkgs; [
    isync
    lynx
    msmtp
    mutt-wizard
    neomutt
  ];
}
