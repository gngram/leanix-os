{ prev }:
prev.google-chrome.override (old: {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=x11"
        "--disable-features=WaylandFractionalScaleV1,UseChromeOSDirectVideoDecoder,UseSkiaRenderer"
      ];
    })
