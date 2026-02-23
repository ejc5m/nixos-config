{ pkgs, inputs, ...}:
{
    imports =
    [

    ];

    home.stateVersion = "25.11";
    programs.home-manager.enable = true;

    home.packages = with pkgs;
    [
        firefox
        kdePackages.kate
        discord
    ];
}
