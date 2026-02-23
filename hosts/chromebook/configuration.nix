{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ../../modules/system

    ];

    modules.system =
    {
      boot.enable = true;
      boot.kernel = pkgs.linuxPackages_6_18;

      boot =
      {
        enable = true;
        kernel = pkgs.linuxPackages_latest;
        bootloader = "systemd-boot";
      };

      users =
      {
        ejc5million =
        {
          isAdmin = true;
          home = ./home.nix;
        };
      };

      network.enable = true;
      audio.enable = true;
      bluetooth.enable = true;
      printing.enable = true;
    };
    security.polkit.enable = true;




  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}
