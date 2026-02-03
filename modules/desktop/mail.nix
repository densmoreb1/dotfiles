{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    isync
    localsend
    lynx
    msmtp
    mutt-wizard
    neomutt
  ];
}
