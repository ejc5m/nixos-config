{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules.system;
in
with lib;
{
  imports = [
    ../environments/kde.nix
    ../login-manager/login-manager.nix
    ../profiles/gaming.nix
  ];

  options.modules.system = {
    boot = {
      enable = mkEnableOption "boot";
      kernel = mkOption {
        type = types.raw;
        default = pkgs.linuxPackages_latest;
      };
      bootloader = mkOption {
        type = types.enum [
          "grub"
          "systemd-boot"
        ];
        default = "systemd-boot";
        description = ''
          Bootloader to use. Must be either \"grub" or \"systemd-boot".
        '';
      };
    };

    users = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              isAdmin = mkEnableOption "admin";

              extraGroups = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Additional groups to add to this user. By default networkmanager and audio are added if system.network is enabled and system.audio is enabled.";
              };

              home = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = "Path to Home Manager config file.";
              };

              packages = mkOption {
                type = types.listOf types.package;
                default = [ ];
                description = "List of user packages to install if this user isn't using home manager (Doesn't have home set).";
              };
            };
          }
        )
      );
      default = { };
    };

    network = {
      enable = mkEnableOption "network";
      hostName = mkOption {
        type = types.nullOr types.str;
        description = "Hostname of this machine";
      };
    };

    bluetooth = {
      enable = mkEnableOption "bluetooth";
    };

    audio = {
      enable = mkEnableOption "audio";
    };

    printing = {
      enable = mkEnableOption "printing";
    };

  };

  config = mkMerge [
    {
      system.stateVersion = "25.11";
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      time.timeZone = "America/Detroit";

      #users
      users.users = lib.mapAttrs (name: userCfg: {
        isNormalUser = true;
        extraGroups = mkMerge [
          (mkIf userCfg.isAdmin [ "wheel" ])
          (mkIf cfg.network.enable [ "networkmanager" ])
          (mkIf cfg.audio.enable [ "audio" ])
          userCfg.extraGroups
        ];
        packages = lib.mkIf (userCfg.home == null) userCfg.packages;
      }) cfg.users;

      #hostname
      networking.hostName = cfg.network.hostName;
    }

    (
      let
        hmUsers = lib.filterAttrs (name: userCfg: userCfg.home != null) cfg.users;
      in
      {
        home-manager = {
          extraSpecialArgs = { inherit inputs; };

          users = lib.mapAttrs (name: userCfg: import userCfg.home) hmUsers;
        };
      }
    )

    (mkIf cfg.boot.enable (mkMerge [
      (mkIf (cfg.boot.bootloader == "grub") {
        boot.loader.grub.enable = true;
        boot.loader.grub.device = "/dev/sda";
        boot.loader.grub.useOSProber = true;
      })

      (mkIf (cfg.boot.bootloader == "systemd-boot") {
        boot.kernelPackages = cfg.boot.kernel;
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.timeout = 3;
        boot.kernelParams = [
          "quiet"
          "loglevel=3"
        ];
        boot.plymouth.enable = true;
        boot.initrd.systemd.enable = true;
      })
    ]))

    (mkIf cfg.network.enable {
      networking.networkmanager.enable = true;
      systemd.services.NetworkManager-wait-online.enable = false;
    })

    (mkIf cfg.bluetooth.enable {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = true;
    })

    (mkIf cfg.audio.enable {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
      environment.systemPackages = [ pkgs.alsa-utils ];
    })

    (mkIf cfg.printing.enable {
      services.printing.enable = true;
    })
  ];

}
