echo "Kanata:" `systemctl --user status kanata.service | grep -Po "Active: \K(..)?active"`
