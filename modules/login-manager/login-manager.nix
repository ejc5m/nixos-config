{ config, lib, ... }:

let
  dm = config.profiles.displayManager;
in
{
  config =
  {
    # Enable the chosen display manager
    services.xserver.displayManager.sddm.enable = dm == "sddm";
    services.greetd.enable = dm == "greetd";
    services.xserver.displayManager.gdm.enable = dm == "gdm";
    services.xserver.displayManager.lightdm.enable = dm == "lightdm";
  };
}
