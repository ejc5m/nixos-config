{ lib, config, pkgs, ...}: with lib;
{
    options.profiles.gaming.enable = mkEnableOption "Enable gaming profile which includes steam, lutris, heroic, and enables 32-bit graphics support.";

    config = mkMerge
    [
        (mkIf config.profiles.gaming.enable
        {
            environment.systemPackages = with pkgs; [ lutris heroic ];
            programs.steam.enable = true;
            hardware.graphics.enable32Bit = true;
        })
    ];
}
