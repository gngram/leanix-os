{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  my-nixos = {
    hostname = "leanix";
    enableBluetooth = true;
    enableNvidia = false;
  };

  # File 1 specific packages
  users.users.gangaram.packages = with pkgs; [ binutils ];
  environment.systemPackages = with pkgs; [
    devenv
    meld
    google-chrome
    joplin
    gtkterm
    pdfstudio2024
  ];

  programs.ssh.extraConfig = ''
    host ghaf-net
      hostname 192.168.0.101
    host ghaf-host
      hostname 192.168.100.2
      proxyjump ghaf-net
  '';
}
