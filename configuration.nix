# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

#with import <nixpkgs> {};

{ config, pkgs, ... }:

# Listing current channels                                                      nix-channel --list
# Adding a primary channel                                                      nix-channel --add https://nixos.org/channels/channel-name nixos
# Adding other channels                                                         nix-channel --add https://some.channel/url my-alias
# Remove a channel                                                              nix-channel --remove channel-alias
# Updating a channel                                                            nix-channel --update channel-alias
# Updating all channels                                                         nix-channel --update
# Rollback the last update (useful if the last update breaks the nixos-rebuild) nix-channel --rollback

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable flatpak
  services.flatpak.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable virtualbox (virtualisation)
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Enable Emacs as daemon
  # services.emacs.enable = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
        General = {
            ControllerMode = "bredr";
        };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Asia/Vladivostok";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.utf8";
    LC_IDENTIFICATION = "ru_RU.utf8";
    LC_MEASUREMENT = "ru_RU.utf8";
    LC_MONETARY = "ru_RU.utf8";
    LC_NAME = "ru_RU.utf8";
    LC_NUMERIC = "ru_RU.utf8";
    LC_PAPER = "ru_RU.utf8";
    LC_TELEPHONE = "ru_RU.utf8";
    LC_TIME = "ru_RU.utf8";
  };

  nix.settings.experimental-features = "nix-command flakes";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Setting the Desktop Environment.
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.plasma5.enable = false;
  services.xserver.desktopManager.gnome.enable = true;

        services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks # is the package manager for Lua modules
      luadbi-mysql # Database abstraction layer
    ];
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.

  # Not strictly required but pipewire will use rtkit if it is present
  # security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
        enable = true;
        # Compatibility shims, adjust according to your needs
        alsa = {
       enable = true;
      support32Bit = true;
    };
        pulse.enable = true;
        jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.beethoven = {
    isNormalUser = true;
    description = "beethoven";
    extraGroups = [ "networkmanager" "wheel" "docker" "beethoven" ];
    home = "/home/beethoven";
    packages = with pkgs; [
      vivaldi
      #chromium
      ungoogled-chromium

      discord
      spotify
      syncthing
      nitrogen

          # Open-source games
      zeroad
      xonotic

      dolphin
          evince
      lxappearance
      numix-icon-theme
      gruvbox-dark-gtk # GTK theme
      adwaita-qt
      gnome.file-roller

      # GNOME Extensions
      gnomeExtensions.dash-to-dock

      nodePackages.npm
      nodePackages.typescript-language-server
      rust-analyzer
    ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    xorg.xbacklight

    rustfmt
    cargo
    go

    alacritty
    unzip
    xclip

        gitui
        git
    fish

    micro
    vim
    emacs
    neovim
    fzf

    btop

    wget
    acpi
    gzip
    pamixer

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];


  services.postgresql = {
     enable = true;
     package = pkgs.postgresql_14;
     #dataDir = "/share/postgresql";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 6566 ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
