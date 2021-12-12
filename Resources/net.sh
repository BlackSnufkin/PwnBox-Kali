#! /bin/bash
netdevice=$(ip r | grep default | awk '/default/ {print $5}')
ip=$(ip addr | grep $netdevice | grep inet | grep 1* | tr -s " " | cut -d " " -f 3 | cut -d "/" -f 1)
if ! [[ $ip == *"169."* ]]
then
        echo "$ip" 
else
   echo "Disconnected"
fi