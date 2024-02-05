{ home-manager, username, ... }:
{
  home-manager.users.${username} = _: {
    home.file = {
      ".config/hypr/hyprpaper.conf".text = ''
        '';

      ".config/hypr/hyprland.conf".text = ''
        # env = WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0
        # env = LIBVA_DRIVER_NAME,nvidia
        # env = XDG_SESSION_TYPE,wayland
        # env = GBM_BACKEND,nvidia-drm
        # env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        # env = WLR_NO_HARDWARE_CURSORS,1

        monitor=HDMI-A-1, 2560 x 1440, 1920x0, 1
        monitor=eDP-1, 1920x1080, 0x0, 1
        monitor=, preferred, auto, auto

        exec-once = waybar & hyprpaper & mako & lxqt-policykit-agent & dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = sfwbar -m eDP-1 & sfwbar -m HDMI-A-1

        # some default env vars.
        env=BROWSER, firefox
        env=XCURSOR_SIZE,24

        env=XDG_CURRENT_DESKTOP,Hyprland
        env=XDG_SESSION_DESKTOP,Hyprland
        env=XDG_SESSION_TYPE,wayland

        env=GDK_BACKEND,wayland,x11
        env=MOZ_ENABLE_WAYLAND,1
        env=MOZ_DISABLE_RDD_SANDBOX,1

        env=QT_AUTO_SCREEN_SCALE_FACTOR,1
        env=QT_QPA_PLATFORM,wayland

        $mainMod = SUPER
        $term = alacritty

        # bind = $mainMod, q, exec, foot 
        bind = $mainMod, w, killactive 
        bind = $mainMod, f, fullscreen, 1
        # bind = $mainMod, d, exec, pavucontrol
        # bind = $mainMod, m, exit
        bind = $mainMod, i, togglefloating, 
        bind = $mainMod, Space, exec, fuzzel
        bind = $mainMod, Return, exec, $term
        # bind = $mainMod, p, pseudo, # dwindle
        bind = $mainMod, j, togglesplit, # dwindle
        bind = $mainMod, l, exec, swaylock
        bind = $mainMod, n, togglegroup

        # bind = ALT, Tab, cyclenext
        # bind = ALT, Tab, bringactivetotop
        bind = ALT, Tab, changegroupactive, f

        $wA = 1
        $wB = 2
        $wC = 3
        $wD = 4
        $wE = 5
        $wF = 6
        $wG = 7
        $wH = 8
        $wI = 9
        $wJ = 0


        # for all categories, see https://wiki.hyprland.org/configuring/variables/
        input {
            kb_layout = pl
            follow_mouse = 1
            touchpad {
                natural_scroll = no
            }
            sensitivity = -0.1 # -1.0 - 1.0, 0 means no modification.
        }

        general {
            gaps_in = 5
            gaps_out = 10
            border_size = 2
            col.active_border = rgba(0D599Fee) rgba(ffffffee) 45deg
            col.inactive_border = rgba(595959aa)
            layout = dwindle
            cursor_inactive_timeout = 15
            no_cursor_warps = yes
        }

        decoration {
            rounding = 10
            drop_shadow = yes
            shadow_range = 4
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
            active_opacity = 1.0
            inactive_opacity = 1.0
            fullscreen_opacity = 1.0
        }

        animations {
            enabled = no
            bezier = snappyBezier, 0.4, 0.0, 0.2, 1.0
            bezier = smoothBezier, 0.25, 0.1, 0.25, 1.0
            animation = windows, 1, 7, snappyBezier
            animation = windowsOut, 1, 7, snappyBezier, popin 85%
            animation = border, 1, 10, snappyBezier
            animation = borderangle, 1, 8, smoothBezier
            animation = fade, 1, 7, smoothBezier
            animation = workspaces, 1, 6, smoothBezier
        }

        dwindle {
            pseudotile = yes # master switch for pseudotiling. enabling is bound to mainmod + p in the keybinds section below
            preserve_split = yes # you probably want this
        }

        master {
            new_is_master = true
        }

        gestures {
            workspace_swipe = off
        }

        device:epic-mouse-v1 {
            sensitivity = -0.5
        }

        misc {
            disable_hyprland_logo = true
            enable_swallow = true
            swallow_regex = ^(foot)$
            # background_color = 0x232136
        }

        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        # bind = $mainMod shift, left, movewindow, l
        # bind = $mainMod shift, right, movewindow, r
        # bind = $mainMod shift, up, movewindow, u
        # bind = $mainMod shift, down, movewindow, d

        bind = $mainMod shift, left, movewindoworgroup, l
        bind = $mainMod shift, right, movewindoworgroup, r
        bind = $mainMod shift, up, movewindoworgroup, u
        bind = $mainMod shift, down, movewindoworgroup, d

        workspace=name:$wA,monitor:eDP-1
        workspace=name:$wB,monitor:eDP-1
        workspace=name:$wC,monitor:eDP-1
        workspace=name:$wD,monitor:eDP-1,default:true
        workspace=name:$w5,monitor:eDP-1
        workspace=name:$wF,monitor:HDMI-A-1
        workspace=name:$wG,monitor:HDMI-A-1,default:true
        workspace=name:$wH,monitor:HDMI-A-1
        workspace=name:$wI,monitor:HDMI-A-1
        workspace=name:$wJ,monitor:HDMI-A-1

        # builtin display
        bind = $mainMod, 1, workspace, name:$wA
        bind = $mainMod, 2, workspace, name:$wB
        bind = $mainMod, 3, workspace, name:$wC
        bind = $mainMod, 4, workspace, name:$wD
        bind = $mainMod, 5, workspace, name:$wE

        bind = $mainMod SHIFT, 1, movetoworkspace,name:$wA
        bind = $mainMod SHIFT, 2, movetoworkspace,name:$wB
        bind = $mainMod SHIFT, 3, movetoworkspace,name:$wC
        bind = $mainMod SHIFT, 4, movetoworkspace,name:$wD
        bind = $mainMod SHIFT, 5, movetoworkspace,name:$wE

        # external display
        bind = $mainMod, 6, workspace, name:$wF
        bind = $mainMod, 7, workspace, name:$wG
        bind = $mainMod, 8, workspace, name:$wH
        bind = $mainMod, 9, workspace, name:$wI
        bind = $mainMod, O, workspace, name:$wJ

        bind = $mainMod SHIFT, 6, movetoworkspace,name:$wF
        bind = $mainMod SHIFT, 7, movetoworkspace,name:$wG
        bind = $mainMod SHIFT, 8, movetoworkspace,name:$wH
        bind = $mainMod SHIFT, 9, movetoworkspace,name:$wI
        bind = $mainMod SHIFT, O, movetoworkspace,name:$wJ

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow 

        # Brightness
        bindsym XF86MonBrightnessDown exec light -U 10
        bindsym XF86MonBrightnessUp exec light -A 10

        # Volume
        bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
        bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
        bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
      '';

    };
  };
}
