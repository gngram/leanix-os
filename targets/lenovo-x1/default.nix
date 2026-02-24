{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  my-nixos = {
    hostname = "cosmic";
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
}
