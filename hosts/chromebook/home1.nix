{ pkgs, inputs, ...}:
{
    imports =
    [

    ];

    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
    nixpkgs.config =
    {
        allowUnfree = true;
    };



    home.packages = with pkgs;
    [

    ];
}
