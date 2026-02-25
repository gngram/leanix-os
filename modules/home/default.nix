{ config, pkgs, home-manager, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.gangaram = {
    home.stateVersion = "25.11"; # match your nixpkgs version

    home.packages = with pkgs; [
      gtkterm
      nnn
      fzf
      notepad-next
      pinta
      nomacs
      wl-clipboard
    ];
    home.file = {
      ".gitconfig".source = ./dotfiles/gitconfig;
      ".vimrc".source = ./dotfiles/vimrc;
      ".config/nix/nix.conf".text = ''
        # Enable flakes
        experimental-features = nix-command flakes

        # Extra platforms to build for (optional)
        extra-platforms = aarch64-linux x86_64-linux

        # Allow trusted caches
        substituters = https://cache.nixos.org https://cuda-maintainers.cachix.org https://cache.nixos.org/ https://devenv.cachix.org
        trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= 
      '';
    };

    programs.home-manager.enable = true;
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true; 
    };
    programs.bash = {
      enable = true;

      shellAliases = {
        build-lenovo = "nix build .#lenovo-x1-carbon-gen11-debug";
        locate = "ls -al /run/current-system/sw/bin/ | grep -in";
        ghost = "rm -rf ~/.ssh/known_hosts; ssh -o StrictHostKeyChecking=no root@ghaf-host";
        ghost-unknown = "ssh -o StrictHostKeyChecking=no root@ghaf-host";
        ghaf-reset = "ssh -o StrictHostKeyChecking=no root@ghaf-host \"reboot\"";
        ghaf-clean = "rm -rf ~/.ssh/known_hosts; ssh -o StrictHostKeyChecking=no root@ghaf-host \"nix-collect-garbage --delete-old\"";
        lenovo-rebuild = "rm -rf ~/.ssh/known_hosts; nixos-rebuild --flake .#lenovo-x1-carbon-gen11-debug --target-host root@ghaf-host --no-reexec boot";
        ghaf-sys76-rebuild = "rm -rf ~/.ssh/known_hosts; nixos-rebuild --flake .#system76-darp11-b-debug --target-host root@ghaf-host --no-reexec boot";
        ghost-build-known = "nixos-rebuild --flake .#lenovo-x1-carbon-gen11-debug --target-host root@ghaf-host --no-reexec boot";
        fe = "sudo ghaf-flash -d /dev/sde -i ./result/disk1.raw.zst";
        ff = "sudo ghaf-flash -d /dev/sdf -i ./result/disk1.raw.zst";
        cdr = "cd /workspace/repositories/gngram";
        c = "clear";
        ghaf = "cd /work/repositories/gngram/ghaf";
        givc = "cd /work/repositories/gngram/ghaf-givc";
        poc = "cd /work/repositories/gngram/poc-store";
        notepad = "NotepadNext";
      };

      bashrcExtra = ''
        	    # Force load the Nix profile if it exists
        		if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        			. "$HOME/.nix-profile/etc/profile.d/nix.sh"
        		fi
  
                parse_git_branch() {
                  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
                }

                CYAN="\[\e[02;36m\]"
                WHITE="\[\e[02;37m\]"
                BLUE="\[\e[02;34m\]"
                GREEN="\[\e[02;42m\]"
                YELLOW="\[\e[33;93m\]"
                RED="\[\e[02;31m\]"
                TEXT_RESET="\[\e[00m\]"
                CURRENT_PATH="\w"

                export PS1="''${YELLOW}[\\w]''${TEXT_RESET} ''${CYAN}\$(parse_git_branch)''${CYAN}:''${TEXT_RESET} "

                bind 'set enable-bracketed-paste on'

                # fnm (Node version manager)
                FNM_PATH="$HOME/.local/share/fnm"
                if [ -d "$FNM_PATH" ]; then
                  export PATH="$FNM_PATH:$PATH"
                  eval "$(fnm env)"
                fi

                export EDITOR="$HOME/.nix-profile/bin/NotepadNext"
                export VISUAL="$HOME/.nix-profile/bin/NotepadNext"
                export QT_QPA_PLATFORM=wayland

                # fzf (completion & keybindings) — refer from nixpkgs
                if [ -f "${pkgs.fzf}/share/fzf/completion.bash" ]; then
                  source "${pkgs.fzf}/share/fzf/completion.bash"
                fi

                if [ -f "${pkgs.fzf}/share/fzf/key-bindings.bash" ]; then
                  source "${pkgs.fzf}/share/fzf/key-bindings.bash"
                fi
      '';
    };
  };
}
