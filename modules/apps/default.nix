{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    meld
    firefox
    vim
    gitFull
    nettools
    wget
    notepad-next
    networkmanagerapplet
    htop
    joplin
    gsettings-desktop-schemas
    teams-for-linux
    tree
    wget
    docker
    sysstat
    statix
  ];


}
