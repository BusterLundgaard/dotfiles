resolution=`cat ~/dotfiles/hyprland/external_monitor.conf | grep -Eo "[0-9]{3,4}x[0-9]{3,4}@[0-9]{2,3}"`
if [ "$resolution" = "" ] 
then
	resolution="disabled"
fi
echo "HDMI: $resolution"
