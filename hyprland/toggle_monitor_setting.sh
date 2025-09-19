MONITOR_CONF_PATH=~/dotfiles/hyprland/monitor.conf
MONITOR_VALUE_PATH=~/dotfiles/hyprland/monitor_value.txt
MONITOR_FOLDER_PATH=~/dotfiles/hyprland/monitors

NUM_OF_SETTINGS=$(ls $MONITOR_FOLDER_PATH | wc -l)

MON_VAL=$((($(cat $MONITOR_VALUE_PATH)+1) % $NUM_OF_SETTINGS))
echo $MON_VAL > $MONITOR_VALUE_PATH

SETTINGS=($MONITOR_FOLDER_PATH/*)
# notify-send ${SETTINGS[$MON_VAL]}
cp ${SETTINGS[$MON_VAL]} $MONITOR_CONF_PATH
