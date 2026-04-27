{...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        reload_style_on_change = true;
        layer = "top";
        position = "bottom";
        spacing = 0;
        height = 26;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = [
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "battery"
          "clock"
        ];
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "󱓻";
          };
        };

        cpu = {
          interval = 5;
          format = "󰍛";
          on-click = "alacritty -e btop";
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          format-alt = "{:L%d %B W%V}";
          tooltip = false;
        };

        network = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          spacing = 1;
        };

        battery = {
          bat = "BAT0";
          format = "{capacity}% {icon}";
          format-discharging = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon}";
          format-plugged = "";
          format-icons = {
            charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
            default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };
          format-full = "󰂅";
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
          interval = 5;
          states = {
            warning = 20;
            critical = 10;
          };
        };

        bluetooth = {
          format = "";
          format-disabled = "󰂲";
          format-connected = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "alacritty -e bluetoothctl";
        };

        pulseaudio = {
          format = "{icon}";
          tooltip-format = "Playing at {volume}%";
          scroll-step = 5;
          format-muted = "";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
        };

        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
        };
      };
    };
    style = ''
      @define-color foreground #cdd6f4;
      @define-color background #1a1b26;
      * {
        background-color: @background;
        color: @foreground;

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: 'JetbrainsMono Nerd Font';
        font-size: 18px;
        font-weight: 400;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #cpu,
      #battery,
      #pulseaudio {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #tray {
        margin-right: 16px;
      }

      #bluetooth {
        margin-right: 17px;
      }

      #network {
        margin-right: 13px;
      }

      tooltip {
        padding: 2px;
      }

      #clock {
        margin-left: 8.75px;
      }

      .hidden {
        opacity: 0;
      }
    '';
  };
}
