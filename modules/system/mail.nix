{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    isync
    lynx
    msmtp
    mutt-wizard
    neomutt
  ];
}
