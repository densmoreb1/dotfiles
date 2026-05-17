{...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        reload_style_on_change = true;
        layer = "top";
        position = "bottom";
        spacing = 0;
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
      * {
        font-family: 'JetbrainsMono Nerd Font';
        font-size: 18px;
      }

      #wireplumber,
      #pulseaudio,
      #sndio {
        padding: 0 10px;
      }
      #wireplumber.muted,
      #pulseaudio.muted,
      #sndio.muted {
        padding: 0 10px;
      }
    '';
  };
}
