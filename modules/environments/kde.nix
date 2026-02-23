{ lib, config, pkgs, ...}: with lib;
{
    options.environments.kde.enable = mkEnableOption "KDE Plasma Desktop";

    config = mkIf config.profiles.environments.kde.enable
    {
        services.xserver.enable = true;
        services.desktopManager.plasma6.enable = true;

        environment.systemPackages = with pkgs;
        [
            kdePackages.konsole
            kdePackages.kate
        ];
    };
}
