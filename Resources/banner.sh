#!/bin/bash

echo " "
echo -e '\e[34m ██████╗ ██╗    ██╗███╗   ██╗██████╗  ██████╗ ██╗  ██╗     \e[31m ██╗  ██╗ █████╗ ██╗     ██╗ '
echo -e '\e[34m ██╔══██╗██║    ██║████╗  ██║██╔══██╗██╔═══██╗╚██╗██╔╝     \e[31m ██║ ██╔╝██╔══██╗██║     ██║ '
echo -e '\e[34m ██████╔╝██║ █╗ ██║██╔██╗ ██║██████╔╝██║   ██║ ╚███╔╝█████╗\e[31m █████╔╝ ███████║██║     ██║ '
echo -e '\e[34m ██╔═══╝ ██║███╗██║██║╚██╗██║██╔══██╗██║   ██║ ██╔██╗╚════╝\e[31m ██╔═██╗ ██╔══██║██║     ██║ '
echo -e '\e[34m ██║     ╚███╔███╔╝██║ ╚████║██████╔╝╚██████╔╝██╔╝ ██╗     \e[31m ██║  ██╗██║  ██║███████╗██║ '
echo -e '\e[34m ╚═╝      ╚══╝╚══╝ ╚═╝  ╚═══╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝     \e[31m ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝ '
echo " "
echo -e '\e[37m                                 J U S T - H A C K - I T  '
echo " "
echo -e '\e[37m                                 Made by @BlackSnufkin '
echo " "                                                                                     


cat  /opt/pwnbox/banner | /usr/games/lolcat -S 33
echo " "
netdevice=$(ip r | grep default | awk '/default/ {print $5}')
ip=$(ip addr | grep $netdevice | grep inet | grep 1* | tr -s " " | cut -d " " -f 3 | cut -d "/" -f 1)
if ! [[ $ip == *"169."* ]];then
    gwip=$(ip route | grep eth0 | grep via | cut -d " " -f 3)
    ping=$(ping -c 1 $gwip -W 1 | sed '$!d;s|.*/\([0-9.]*\)/.*|\1|' | cut -c1-4)
    netmask=$(ip -o -f inet addr show "$netdevice"| awk '/scope global/{sub(/[^.]+\//,"0/",$4);print $4}')
    DNS_SRV=$(cat /etc/resolv.conf |grep -i '^nameserver'|head -n1|cut -d ' ' -f2)
    echo "Interface: $netdevice: " | lolcat
    echo "  IP: $ip [$ping ms] " | lolcat
    echo "  Subnet: $netmask" | lolcat
    echo "  Default GW: $gwip " | lolcat
    echo "  DNS Server: $DNS_SRV" | lolcat
    echo -n "  Internet via wget: " | lolcat
    
    wget -q --spider https://google.com
    if [ $? -eq 0 ]; then
        echo "YES" | lolcat
    else
        echo -n "NO" | lolcat
    fi
        echo -n "  Internet via Ping: " | lolcat

    ping -c1 "8.8.8.8" &>"/dev/null"

    if [[ "${?}" -ne 0 ]]; then
        echo "NO"
    elif [[ "${#args[@]}" -eq 0 ]]; then
        echo "YES"
    fi


else
    echo "Disconnected"
fi

echo " "

read -r -p "Press ENTER key to Hack The Planet =). " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    exit
fi
