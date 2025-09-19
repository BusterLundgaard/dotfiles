#!/bin/bash
cp "/home/buster/dotfiles/hyprland/inputs/english.conf" "/home/buster/dotfiles/hyprland/input.conf"
touch /tmp/kanata-start-trigger
pkill -SIGRTMIN+10 waybar
