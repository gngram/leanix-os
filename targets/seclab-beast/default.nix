{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  my-nixos = {
    enableNvidia = true;
    isBuilder = true;
  };

  # Hardware/Mounts specific to this machine
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/work" = {
    device = "/dev/disk/by-uuid/e25724ed-f7a4-4e63-ac52-bb2f6380c810";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  # AppImage & SSH Config
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override { extraPkgs = pkgs: [ pkgs.python312 pkgs.libthai ]; };
  };

  programs.ssh.extraConfig = ''
    host ghaf-net
      hostname 192.168.0.101
    host ghaf-host
      hostname 192.168.100.2
      proxyjump ghaf-net
  '';

  networking.firewall.allowedTCPPorts = [ 5201 ];
}
