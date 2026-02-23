{ lib, ... }:

{
  options.profiles.displayManager = {
    type = lib.types.enum [ "sddm" "greetd" "gdm" "lxdm" ];
    default = "sddm";
    description = "The display manager to use for the system";
  };
}
