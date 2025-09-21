if [ "$1" = "internal" ] 
then
	REGEX_SUFFIX="Family"
else
	REGEX_SUFFIX="Radeon"
fi
AUDIO_SINK_ID=`wpctl status 2>/dev/null | tr -d " \t\n\r" | grep -o -P "Audio├─Devices.*?(?=├─Sinks)├─Sinks:\K.*?(?=├─Sources:)" | grep -oP "│(.?)\K[0-9][0-9](?=\.$REGEX_SUFFIX)"`
wpctl set-default $AUDIO_SINK_ID 2>/dev/null
