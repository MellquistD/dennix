{
  self,
  inputs,
  ...
}: {
  flake.homeModules.brightness-keybinds = {
    pkgs,
    lib,
    config,
    ...
  }: {
    # Hyprland
    wayland.windowManager.hyprland.settings = lib.mkIf config.wayland.windowManager.hyprland.enable {
      binde = [
        # Brightness up/down
        ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%+"
        ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-"
      ];
    };

    # Add other WM's if needed
  };
}
