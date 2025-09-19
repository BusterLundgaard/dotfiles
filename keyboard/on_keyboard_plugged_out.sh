#!/bin/bash
sudo touch /tmp/kanata-start-trigger
sudo rm /tmp/kanata-start-trigger
cp "/home/buster/dotfiles/hyprland/inputs/danish.conf" "/home/buster/dotfiles/hyprland/input.conf"
pkill -SIGRTMIN+10 waybar
