#!/bin/bash

becho() {
    local arg2=${2:-" "}  # Set default value for $2 to " "
    printf "\n"
    if [ "$arg2" = " " ]; then
        # echo -e "$(tput setaf 1)$1$(tput sgr0)"
        echo -e "$1"
    else
        echo -n "$(tput setaf 1)$1$(tput sgr0)"
    fi
}

# Backup Dir
mkdir -p /audit/backup
chown -R root:root /audit
chmod -R 600 /audit

backup_dir="/audit/backup"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

becho "Save Iptables:"
if command -v iptables &> /dev/null; then
    iptables-save > "$backup_dir/iptables.$timestamp.rules"
else
    becho "iptables Not Found"
    exit 1
fi

becho "List IP Tables Rules"
iptables -L --line-numbers


printf "\n"
read -p "Press any key to flush current iptables rules..."

becho "Flush iptables"
iptables -F

becho "Allowing everything on loopback"
iptables -A INPUT -s 127.0.0.1 -j ACCEPT
iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT

becho "Dropping anything marked INVALID"
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

becho "Allow Ping"
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -j ACCEPT

becho "ACCEPT *incoming* RELATED/ESTABLISHED"
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

becho "ACCEPT *outgoing* RELATED/ESTABLISHED"
iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT


# Ask Questions for popular ports
port=22
echo "Allow incomming and outgoing for port $port (y/n) ?"
read allowSSH
if [ "$allowSSH" == "y" ]; then
    iptables -A INPUT -p tcp --dport $port -m conntrack --ctstate NEW -j ACCEPT
    iptables -A OUTPUT -p tcp --dport $port -m conntrack --ctstate NEW -j ACCEPT
fi

port=443
echo "Allow incomming and outgoing for port $port (y/n) ?"
read allowHTTPS
if [ "$allowHTTPS" == "y" ]; then
    iptables -A INPUT -p tcp --dport $port -m conntrack --ctstate NEW -j ACCEPT
    iptables -A OUTPUT -p tcp --dport $port -m conntrack --ctstate NEW -j ACCEPT
fi

port=80
echo "Allow incomming and outgoing for port $port (y/n) ?"
read allowHTTP
if [ "$allowHTTP" == "y" ]; then
    iptables -A INPUT -p tcp --dport $port -m conntrack --ctstate NEW -j ACCEPT
    iptables -A OUTPUT -p tcp --dport $port -m conntrack --ctstate NEW -j ACCEPT
fi

port=53
echo "ACCEPT outgoing DNS [port 53/udp] (y/n) ?"
read allowDNS
if [ "$allowDNS" == "y" ]; then
    iptables -A INPUT -p tcp --dport $port -m conntrack --ctstate NEW -j ACCEPT
fi


becho "Set Default Policy to DROP"
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
iptables -P INPUT DROP

becho "Graceful UDP REJECTs"
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable

becho "Graceful TCP REJECTs"
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-rst

becho "Graceful UNKNOWN REJECTs"
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable


mkdir -p /etc/iptables

becho "Save IP table at /etc/iptables/iptables.rules"
iptables-save | tee /etc/iptables/iptables.rules
chmod +x /etc/iptables/iptables.rules