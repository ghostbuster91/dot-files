#!/usr/bin/env sh
gsettings set org.gnome.desktop.input-sources show-all-sources "false"
gsettings set org.gnome.desktop.input-sources xkb-options "['numpad:shift3', 'numpad:microsoft']"
gsettings set org.gnome.desktop.input-sources per-window "false"
gsettings set org.gnome.desktop.input-sources current "uint32 0"
gsettings set org.gnome.desktop.input-sources mru-sources "@a(ss) []"
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"