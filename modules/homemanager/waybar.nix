{...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        reload_style_on_change = true;
        layer = "top";
        position = "bottom";
        spacing = 0;

        # Autohide. The bar is unmapped at startup and slides in and out from
        # under the bottom edge; the cursor hotzone and the SUPER+SHIFT+B pin
        # that drive it live in hyprland.lua. No exclusive zone, so revealing
        # the bar floats it over the windows instead of reflowing them.
        exclusive = false;
        start_hidden = true;
        "on-sigusr1" = "show";
        "on-sigusr2" = "hide";
        modules-center = [
          "hyprland/workspaces"
          "network"
          "pulseaudio"
          "battery"
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
      };
    };
    # Appended after stylix's sheet, so these win on equal specificity and the
    # @baseXX colours it defines are in scope.
    style = ''
      * {
        font-family: 'JetbrainsMono Nerd Font';
        font-size: 18px;
      }

      /* One floating pill in the middle. The bar surface stays full width but
         is painted transparent; the centre group is the only visible box, so
         the pill hugs its contents and the wallpaper shows through beside it. */
      window#waybar {
        background: transparent;
      }

      .modules-center {
        background: alpha(@base00, 0.85);
        border: 1px solid alpha(@base04, 0.25);
        border-radius: 18px;
        margin-bottom: 8px;
        padding: 1px 6px;
      }

      #workspaces,
      #bluetooth,
      #network,
      #pulseaudio,
      #battery {
        padding: 0 8px;
      }

      /* Breathing room between the workspace cluster and the status cluster. */
      #workspaces {
        margin-right: 10px;
        padding: 0 2px;
      }

      /* Stylix underlines the active workspace; the active icon already marks
         it, and a flat underline fights the rounded pill. */
      .modules-center #workspaces button,
      .modules-center #workspaces button.active,
      .modules-center #workspaces button.focused {
        border-bottom: 3px solid transparent;
      }

      .modules-center #workspaces button {
        padding: 0 6px;
      }
    '';
  };
}
