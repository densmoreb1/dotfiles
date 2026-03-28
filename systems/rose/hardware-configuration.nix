{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/effbb375-18d4-4948-8813-8e72bf66fb8e";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-dba8fa5f-bee4-4336-b85a-ee95fb08b755".device = "/dev/disk/by-uuid/dba8fa5f-bee4-4336-b85a-ee95fb08b755";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C8FB-6B76";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
