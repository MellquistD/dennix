{
  self,
  inputs,
  ...
}: {
  flake.homeModules.sauceCodePro = {
    pkgs,
    lib,
    config,
    ...
  }: let
    fontName = "SauceCodePro Nerd Font Mono";
  in {
    # Install font
    home.packages = [
      pkgs.nerd-fonts.sauce-code-pro
    ];

    fonts.fontconfig = {
      enable = true;
      # Set the font as the default monospace font
      defaultFonts.monospace = [fontName];
    };

    # Rio terminal configuration
    programs.rio.fonts = lib.mkIf config.programs.rio.enable {
      regular = {
        family = fontName;
        style = "Normal";
        width = "Normal";
        weight = 400;
      };
      bold = {
        family = fontName;
        style = "Normal";
        width = "Normal";
        weight = 800;
      };
      italic = {
        family = fontName;
        style = "Italic";
        width = "Normal";
        weight = 400;
      };
      bold-italic = {
        family = fontName;
        style = "Italic";
        width = "Normal";
        weight = 800;
      };
    };
  };
}
