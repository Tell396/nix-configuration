# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest-libre;

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable virtualbox (virtualisation)
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Enable Emacs as daemon
  # services.emacs.enable = true;

  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #   }))
  # ];

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # hardware.bluetooth.settings = {
  #       General = {
  #           ControllerMode = "bredr";
  #       };
  # };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Vladivostok";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.utf8";

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.

	# # rtkit is optional but recommended
	# security.rtkit.enable = true;
	# 	services.pipewire = {
	# 	enable = true;
	# 	alsa.enable = true;
	# 	alsa.support32Bit = true;
	# 	pulse.enable = true;
	# 	# If you want to use JACK applications, uncomment this
	# 	jack.enable = true;
	# };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.desktopManager.plasma5.enable = false;

   services.xserver.windowManager = {
   awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks # is the package manager for Lua modules
      luadbi-mysql # Database abstraction layer
    ];
  };

   exwm.enable = true;
   xmonad.enable = true;
};
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sibelius = {
    isNormalUser = true;
    description = "Jean Sibelius";
    home = "/home/beethoven";
    extraGroups = [ "audio" "networkmanager" "wheel" ];
    packages = with pkgs; [
      #vivaldi
      ungoogled-chromium

	    tdesktop
      discord
      spotify
      syncthing
      vlc

      rofi
      nitrogen
      alacritty

      # Open-source games/projects
      zeroad
      xonotic
      stellarium

      dbeaver
      dolphin
      evince
      lxappearance
      numix-icon-theme
      adwaita-qt
      gnome.file-roller

      # GNOME Extensions
      gnomeExtensions.dash-to-dock

      # Emacs optional dependences
      nodejs
      nodePackages.prettier
      nodePackages.npm
      nodePackages.typescript-language-server
      rust-analyzer

      # Emacs packages
      emacs28Packages.prettier-js
      emacs28Packages.telega
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xorg.xbacklight

    rustfmt
    cargo
    go

    unzip
    xclip

    gitui
    git
    fish

    micro
    vim
    emacs
    tmux
    fzf

    btop

    wget
    acpi
    gzip
    pamixer
    bluez-tools
    blueman
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    
    source-code-pro
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 6566 ];
  };

  services.postgresql = {
     enable = true;
     package = pkgs.postgresql_14;
     #dataDir = "/share/postgresql";
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
