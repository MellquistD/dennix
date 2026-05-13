{
  self,
  inputs,
  ...
}: {
  flake.homeModules.screen-record-wayland = {
    pkgs,
    lib,
    config,
    ...
  }: let
    scriptPath = ".config/scripts/screen-record.sh";
  in {
    # Create the script for screen-recording
    home.file."${scriptPath}" = {
      executable = true; # Make the script runnable
      text = ''
        #!/usr/bin/env bash

        # Directory to save recordings
        REC_DIR="$HOME/Videos/Screen-Recordings"
        mkdir -p "$REC_DIR"

        # Filename with timestamp
        FILENAME="$REC_DIR/rec_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

        # System audio source (monitor of the default sink)
        SYSTEM_SOURCE="$(${pkgs.pulseaudio}/bin/pactl get-default-sink | sed 's/Name: //').monitor"

        # Check if a recording is already in progress
        if ${pkgs.procps}/bin/pgrep -x "wf-recorder" > /dev/null; then
            ${pkgs.libnotify}/bin/notify-send "Recording in Progress" "A screen recording is already active."
            exit 1
        fi

        # Main logic based on argument
        case $1 in
            area)
                GEOMETRY=$(${pkgs.slurp})
                if [ -n "$GEOMETRY" ]; then
                    ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Starting area recording with system audio..."
                    ${pkgs.wf-recorder} -g "$GEOMETRY" -f "$FILENAME" \
                        --audio="$SYSTEM_SOURCE"
                else
                    ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Selection cancelled."
                fi
                ;;
            screen)
                ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Starting full-screen recording with system audio..."
                ${pkgs.wf-recorder} -f "$FILENAME" \
                    --audio="$SYSTEM_SOURCE"
                ;;
            *)
                echo "Usage: $0 {area|screen}"
                exit 1
                ;;
        esac
      '';
    };

    # Hyprland uses hyprshot as it's screenshotter, and the script for recording
    wayland.windowManager.hyprland.settings = lib.mkIf config.wayland.windowManager.hyprland.enable {
      bind = [
        # Screenshotting
        "$mod, PRINT, exec, ${pkgs.hyprshot} -m window"
        ", PRINT, exec, ${pkgs.hyprshot} -m output"
        "$modshift, PRINT, exec, ${pkgs.hyprshot} -m region"

        # Video recording
        "$mod, R, exec, ${scriptPath} area"
        "$modshift, R, exec, ${scriptPath} screen"
        "$mod, S, exec, ${pkgs.procps}/bin/pkill -INT wf-recorder && ${pkgs.libnotify}/bin/notify-send 'Screen Recording' 'Recording stopped.'"
      ];
    };
  };
}
