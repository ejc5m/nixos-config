{ config, lib, ... }:

let
  dm = config.environments.displayManager;
in
{
  options.environments.displayManager = lib.mkOption {
    type = lib.types.enum [
      "sddm"
      "greetd"
      "gdm"
      "lightdm"
    ];
    default = "sddm";
    description = "The display manager to use for the system";
  };

  config = {
    # Enable the chosen display manager
    services.displayManager.sddm.enable = dm == "sddm";
    services.greetd.enable = dm == "greetd";
    services.displayManager.gdm.enable = dm == "gdm";
    services.xserver.displayManager.lightdm.enable = dm == "lightdm";
  };
}
