{
  pkgs,
  lib,
  config,
  ...
}:
{
    programs.niri.settings = {
      outputs."eDP-1".scale = 2.0;
      binds =
        with lib;
        with config.lib.niri.actions;
        let
          binds =
            {
              suffixes,
              prefixes,
              substitutions ? { },
            }:
            let
              replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
              format =
                prefix: suffix:
                let
                  actual-suffix =
                    if isList suffix.action then
                      {
                        action = head suffix.action;
                        args = tail suffix.action;
                      }
                    else
                      {
                        inherit (suffix) action;
                        args = [ ];
                      };

                  action = replacer "${prefix.action}-${actual-suffix.action}";
                in
                {
                  name = "${prefix.key}+${suffix.key}";
                  value.action.${action} = actual-suffix.args;
                };
              pairs =
                attrs: fn:
                concatMap (
                  key:
                  fn {
                    inherit key;
                    action = attrs.${key};
                  }
                ) (attrNames attrs);
            in
            listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [ (format prefix suffix) ])));
          sh = spawn "sh" "-c";
        in
        lib.attrsets.mergeAttrsList [
          {
            "Mod+Return".action = spawn "alacritty";
            "Mod+D".action = spawn "fuzzel";
            "Mod+W".action = spawn "firefox";

            "Mod+L".action = spawn "blurred-locker";

            "Mod+Shift+S".action = screenshot;
            "Print".action = screenshot-screen;
            "Mod+Print".action = screenshot-window;

            "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
            "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            "XF86MonBrightnessUp".action = sh "brightnessctl set 10%+";
            "XF86MonBrightnessDown".action = sh "brightnessctl set 10%-";

            "Mod+Q".action = close-window;

            "XF86AudioNext".action = focus-column-right;
            "XF86AudioPrev".action = focus-column-left;

            "Mod+Tab".action = focus-window-down-or-column-right;
            "Mod+Shift+Tab".action = focus-window-up-or-column-left;
          }
          (binds {
            suffixes."Left" = "column-left";
            suffixes."Down" = "window-down";
            suffixes."Up" = "window-up";
            suffixes."Right" = "column-right";
            prefixes."Mod" = "focus";
            prefixes."Mod+Shift" = "move";
            prefixes."Mod+Ctrl" = "focus-monitor";
            prefixes."Mod+Shift+Ctrl" = "move-window-to-monitor";
            substitutions."monitor-column" = "monitor";
            substitutions."monitor-window" = "monitor";
          })
          (binds {
            suffixes."Home" = "first";
            suffixes."End" = "last";
            prefixes."Mod" = "focus-column";
            prefixes."Mod+Ctrl" = "move-column-to";
          })
          (binds {
            suffixes."U" = "workspace-down";
            suffixes."I" = "workspace-up";
            prefixes."Mod" = "focus";
            prefixes."Mod+Ctrl" = "move-window-to";
            prefixes."Mod+Shift" = "move";
          })
          (binds {
            suffixes = builtins.listToAttrs (
              map (n: {
                name = toString n;
                value = [
                  "workspace"
                  n
                ];
              }) (range 1 9)
            );
            prefixes."Mod" = "focus";
            prefixes."Mod+Ctrl" = "move-window-to";
          })
          {
            "Mod+Comma".action = consume-window-into-column;
            "Mod+Period".action = expel-window-from-column;

            "Mod+R".action = switch-preset-column-width;
            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+C".action = center-column;

            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Plus".action = set-column-width "+10%";
            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Plus".action = set-window-height "+10%";

            "Mod+Shift+E".action = quit;
            "Mod+Shift+P".action = power-off-monitors;

            "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
          }
        ];

    };
};
