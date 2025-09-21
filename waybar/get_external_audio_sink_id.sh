EXTERNAL_SINK_ID=`wpctl status 2>/dev/null | tr -d " \t\n\r" | grep -o -P "Audio├─Devices.*?(?=├─Sinks)├─Sinks:\K.*?(?=├─Sources:)" | grep -oP "│(.?)\K[0-9][0-9](?=\.Radeon)"`
INTERNAL_SINK_ID=`wpctl status 2>/dev/null | tr -d " \t\n\r" | grep -o -P "Audio├─Devices.*?(?=├─Sinks)├─Sinks:\K.*?(?=├─Sources:)" | grep -oP "│(.?)\K[0-9][0-9](?=\.Family)"`
echo "External sink is: $EXTERNAL_SINK_ID"
echo "Internal sink is: $INTERNAL_SINK_ID"
