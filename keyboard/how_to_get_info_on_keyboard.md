Run this command to see the device names of the keyboard:
grep -i cidoo /sys/class/input/*/device/name
then, if it's in /input/event18, do:
udevadm info /sys/class/input/event18
