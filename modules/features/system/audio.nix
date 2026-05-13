{
  self,
  inputs,
  ...
}:
builtins.trace "LOADED AUDIO FILE"
{
  flake = {
    nixosModules.audio = {pkgs, ...}: {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        wireplumber.enable = true;
        pulse.enable = true;
        alsa.enable = true;
      };
    };

    homeModules.audio-keybinds = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # Hyprland
      wayland.windowManager.hyprland.settings = lib.mkIf config.wayland.windowManager.hyprland.enable {
        binde = [
          # System volume up/down
          ",XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%-"

          # Media player volume up/down
          "CTRL,XF86AudioRaiseVolume, exec, ${pkgs.playerctl}/bin/playerctl volume 0.1+"
          "CTRL,XF86AudioLowerVolume, exec, ${pkgs.playerctl}/bin/playerctl volume 0.1-"
        ];

        bind = [
          # Audio
          ## Volume mute
          ",XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ## Microphone mute
          ",XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

          # Media player
          ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ];
      };

      # Add other WM's if needed
    };
  };
}
