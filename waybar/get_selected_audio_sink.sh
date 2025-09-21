SELECTED_SINK=`wpctl status 2>/dev/null | tr -d " \t\n\r" | grep -o -P "Audio├─Devices.*?(?=├─Sinks)├─Sinks:\K.*?(?=├─Sources:)" | grep -oP "│\*[0-9][0-9]\.\K(Family|Radeon)"`
if [ "$SELECTED_SINK" = "Family" ] 
then
	echo "Internal speaker"
else
	echo "External speaker"
fi
