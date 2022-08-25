# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

#with import <nixpkgs> {};

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable docker
  #virtualisation.docker.enable = true;

  # Enable flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable virtualbox (virtualisation)
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "beethoven" ];

  # Enable Emacs as daemon
  #services.emacs.enable = true;
  #services.emacs.package = import /home/beethoven/.emacs.d { pkgs = pkgs; };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Setting the Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
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

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.beethoven = {
    isNormalUser = true;
    description = "beethoven";
    extraGroups = [ "networkmanager" "wheel" ];
    home = "/home/beethoven";
    packages = with pkgs; [
      vivaldi
      chromium
      discord
      spotify
      nitrogen

      dolphin
      lxappearance
      numix-icon-theme
      capitaine-cursors
      adwaita-qt

      nodePackages.npm
      nodePackages.typescript-language-server
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

    environment.systemPackages = with pkgs; [
    xorg.xbacklight

    alacritty
    vim
    emacs

    btop
    wget
    acpi
    gzip
    pamixer
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
