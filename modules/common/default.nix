{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my-nixos;
in
{
  options.my-nixos = {
    enableNvidia = mkEnableOption "NVIDIA drivers and hardware acceleration";
    enableBluetooth = mkEnableOption "Bluetooth support";
    isBuilder = mkEnableOption "Optimizations and tools for build server";
    hostname = mkOption {
      type = types.str;
      default = "leanix";
    };
  };

  config = {
    # --- COMMON CONFIGURATION (The "Defaults") ---
    networking.hostName = cfg.hostname;
    networking.networkmanager.enable = true;
    networking.networkmanager.plugins = with pkgs; [
      networkmanager-openconnect
    ];

    time.timeZone = "Asia/Dubai";
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };

    # Bootloader & Emulation
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.binfmt.emulatedSystems = [ "riscv64-linux" "aarch64-linux" ];

    # GNOME Desktop (Requested to use only GNOME)
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.displayManager.gdm.banner = "
     Welcome to Leanix!
    ";
    services.desktopManager.gnome.enable = true;
    services.gnome.gnome-keyring.enable = lib.mkForce false;
    # Common Programs & Settings
    programs.nix-ld.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    services.printing.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    
    nix.settings.trusted-users = [ "root" "@wheel" ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (import ../../overlays/overlays.nix)
    ];

    users.users.gangaram = {
      isNormalUser = true;
      shell = pkgs.bash;
      description = "Ganga Ram";
      extraGroups = [ "networkmanager" "wheel" ] ++ (if cfg.isBuilder then [ "disk" ] else [ ]);
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfyjcPGIRHEtXZgoF7wImA5gEY6ytIfkBeipz4lwnj6 Ganga.Ram@tii.ae"
      ];
    };

    environment.systemPackages = with pkgs; [
      vim
      gitFull
      nettools
      firefox
      teams-for-linux
      ghostty
      my-slack
      my-google-chrome
    ];
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 445 139 8080 ];
    networking.firewall.allowedUDPPorts = [ 137 138 8080 ];
    system.stateVersion = "25.11";

    # Bluetooth (File 1 specific)
    hardware.bluetooth.enable = mkIf cfg.enableBluetooth true;
    services.blueman.enable = mkIf cfg.enableBluetooth true;

    # NVIDIA Logic (File 2 specific)
    hardware.nvidia = mkIf cfg.enableNvidia {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    };
    services.xserver.videoDrivers = mkIf cfg.enableNvidia [ "nvidia" ];

    # Builder/Server specific tweaks (File 2)
    systemd.targets.sleep.enable = mkIf cfg.isBuilder false;
    services.flatpak.enable = mkIf cfg.isBuilder true;
  };
}
