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
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=x11"
        "--disable-features=WaylandFractionalScaleV1,UseChromeOSDirectVideoDecoder,UseSkiaRenderer"
      ];
    })
    (pkgs.slack.overrideAttrs (old: {
      wrapperArgs = (old.wrapperArgs or [ ]) ++ [
        "--add-flags"
        "--disable-gpu"
        "--add-flags"
        "--disable-gpu-compositing"
        "--add-flags"
        "--use-gl=swiftshader"
      ];
    }))
  ];


}
