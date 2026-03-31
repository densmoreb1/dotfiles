{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/system/default.nix
  ];

  networking.hostName = "pipboy";

  virtualisation.docker.enable = true;

  system.stateVersion = "24.11";

  # Hardware
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/151e61d4-b548-4c52-8453-63820438dba1";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/4e0737a6-0160-4f6b-9b61-4ff7f1c09cf8";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/606C-9DDE";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
