#/usr/bin/zsh

# Requires iproute2

nic=$(ip -br link | grep -v LOOPBACK | awk '{ print $1 }')
current_ip=$(ip addr show $(ip route | awk '/default/ { print $5 }') | grep "inet" | head -n 1 | awk '/inet/ {print $2}')
default_gw=$(ip route | awk '/default/ {print $3}')


ip link add name br666 type bridge
ip link set dev br666 up
ip address add ${current_ip} dev br666
ip route append default via ${default_gw} dev br666

ip link set ${nic} master br666
ip address del ${current_ip} dev ${nic}

