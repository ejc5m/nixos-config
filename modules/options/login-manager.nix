{ lib, ... }:

{
  options.profiles.displayManager = lib.mkOption
  {
    type = lib.types.enum [ "sddm" "greetd" "gdm" "lightdm" ];
    default = "sddm";
    description = "The display manager to use for the system";
  };
}
